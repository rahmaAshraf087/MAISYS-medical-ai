import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/services/api_service.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';
import 'package:share_plus/share_plus.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String chatTitle;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.chatTitle,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  late String _currentTitle;
  List<Map<String, dynamic>> messages = [];
  bool isSending = false;

  // File attachment state
  File? attachedFile;
  String? attachedFileName;
  String? attachedFileType;

  @override
  void initState() {
    super.initState();
    _currentTitle = widget.chatTitle;
    _loadMessages();
  }

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final result = await ApiService.getChatById(widget.chatId);
    if (!mounted) return;
    if (result['success'] == true) {
      setState(() {
        messages = List<Map<String, dynamic>>.from(
            result['chat']['messages'] ?? []);
      });
      _scrollToBottom();
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        attachedFile = File(image.path);
        attachedFileName = image.name;
        attachedFileType = 'image/jpeg';
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        attachedFile = File(image.path);
        attachedFileName = image.name;
        attachedFileType = 'image/jpeg';
      });
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt', 'doc', 'docx'],
    );
    if (result != null) {
      setState(() {
        attachedFile = File(result.files.single.path!);
        attachedFileName = result.files.single.name;
        attachedFileType = 'application/pdf';
      });
    }
  }

  void _showAttachmentOptions(BuildContext context, bool isDark, bool isArabic) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
      isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isArabic ? 'إرفاق ملف' : 'Attach File',
              style: TextStyles.font20whitebold.copyWith(
                color: isDark ? Colors.white : ColorManager.lightTextPrimary,
              ),
            ),
            SizedBox(height: 20),
            _buildAttachOption(
              icon: Icons.photo_library,
              label: isArabic ? 'من المعرض' : 'From Gallery',
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            SizedBox(height: 12),
            _buildAttachOption(
              icon: Icons.camera_alt,
              label: isArabic ? 'التقاط صورة' : 'Take Photo',
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            SizedBox(height: 12),
            _buildAttachOption(
              icon: Icons.insert_drive_file,
              label: isArabic ? 'ملف PDF أو مستند' : 'PDF or Document',
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
                _pickFile();
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showChatOptions(BuildContext context, bool isDark, bool isArabic) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),

            // ✅ Rename
            _buildOptionTile(
              icon: Icons.edit_outlined,
              label: isArabic ? 'إعادة تسمية' : 'Rename',
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
                _showRenameDialog(context, isDark, isArabic);
              },
            ),

            // Pin
            _buildOptionTile(
              icon: Icons.push_pin_outlined,
              label: isArabic ? 'تثبيت المحادثة' : 'Pin Chat',
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isArabic ? 'تم تثبيت المحادثة' : 'Chat pinned'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),

            // Share
            _buildOptionTile(
              icon: Icons.share_outlined,
              label: isArabic ? 'مشاركة المحادثة' : 'Share Chat',
              isDark: isDark,
              onTap: () async {
                Navigator.pop(context);
                final chatLink = 'maisys://chat/${widget.chatId}';
                await Share.share(
                  isArabic
                      ? 'شاهد هذه المحادثة الطبية على MAISYS:\n$chatLink'
                      : 'Check out this medical conversation on MAISYS:\n$chatLink',
                  subject: _currentTitle,
                );
              },
            ),

            // Delete
            _buildOptionTile(
              icon: Icons.delete_outline,
              label: isArabic ? 'حذف المحادثة' : 'Delete Chat',
              isDark: isDark,
              color: Colors.red,
              onTap: () async {
                Navigator.pop(context);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
                    title: Text(
                      isArabic ? 'حذف المحادثة' : 'Delete Chat',
                      style: TextStyle(
                        color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                      ),
                    ),
                    content: Text(
                      isArabic
                          ? 'هل أنت متأكد من حذف هذه المحادثة؟'
                          : 'Are you sure you want to delete this chat?',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : ColorManager.lightTextSecondary,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(isArabic ? 'إلغاء' : 'Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(isArabic ? 'حذف' : 'Delete',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  final result = await ApiService.deleteChat(widget.chatId);
                  if (!mounted) return;
                  if (result['success'] == true) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isArabic ? 'فشل الحذف' : 'Delete failed'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(BuildContext context, bool isDark, bool isArabic) {
    final controller = TextEditingController(text: _currentTitle);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
        title: Text(
          isArabic ? 'إعادة تسمية' : 'Rename Chat',
          style: TextStyle(
            color: isDark ? Colors.white : ColorManager.lightTextPrimary,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(
            color: isDark ? Colors.white : ColorManager.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: isArabic ? 'اسم المحادثة' : 'Chat name',
            hintStyle: TextStyle(
              color: isDark ? Colors.white38 : ColorManager.lightTextSecondary,
            ),
            filled: true,
            fillColor: isDark ? Color(0xFF0D1620) : ColorManager.lightBorder,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final newTitle = controller.text.trim();
              if (newTitle.isEmpty) return;
              Navigator.pop(context);

              final result = await ApiService.renameChat(
                chatId: widget.chatId,
                newTitle: newTitle,
              );

              if (!mounted) return;
              if (result['success'] == true) {
                setState(() => _currentTitle = newTitle);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isArabic ? 'تم التغيير' : 'Renamed successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: Text(
              isArabic ? 'حفظ' : 'Save',
              style: TextStyle(
                color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
    Color? color,
  }) {
    final itemColor =
        color ?? (isDark ? Colors.white : ColorManager.lightTextPrimary);
    return ListTile(
      leading: Icon(icon, color: itemColor),
      title: Text(label,
          style: TextStyles.font16white600w.copyWith(color: itemColor)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildAttachOption({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF0D1620) : ColorManager.lightBorder,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isDark
                    ? ColorManager.primaryBlue
                    : ColorManager.lightPrimaryBlue),
            SizedBox(width: 15),
            Text(label,
                style: TextStyles.font16white600w.copyWith(
                  color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = messageController.text.trim();
    if ((text.isEmpty && attachedFile == null) || isSending) return;

    String? fileBase64;
    String? fileType;
    String? fileName;

    if (attachedFile != null) {
      final bytes = await attachedFile!.readAsBytes();
      fileBase64 = base64Encode(bytes);
      fileType = attachedFileType;
      fileName = attachedFileName;
    }

    final displayContent = text.isNotEmpty
        ? text
        : (attachedFileName ?? 'File attached');

    setState(() {
      messages.add({
        'role': 'user',
        'content': displayContent,
        'hasFile': attachedFile != null,
        'fileName': attachedFileName,
      });
      isSending = true;
      attachedFile = null;
      attachedFileName = null;
      attachedFileType = null;
    });

    messageController.clear();
    _scrollToBottom();

    final result = await ApiService.sendMessage(
      chatId: widget.chatId,
      content: displayContent,
      fileBase64: fileBase64,
      fileType: fileType,
      fileName: fileName,
    );

    if (!mounted) return;

    setState(() {
      isSending = false;
      messages.add({
        'role': 'assistant',
        'content': result['success'] == true
            ? result['aiResponse'] ?? ''
            : result['message'] ?? 'Error getting response',
      });
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state.isDarkMode;
    final isArabic = context.watch<LanguageCubit>().state.isArabic;

    return Scaffold(
      backgroundColor:
      isDark ? ColorManager.kohly : ColorManager.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopHeader(context, isDark, isArabic),
            Expanded(
              child: messages.isEmpty
                  ? _buildEmptyState(isDark, isArabic)
                  : _buildMessageList(isDark, isArabic),
            ),
            if (attachedFile != null)
              _buildFilePreview(isDark, isArabic),
            if (isSending)
              _buildTypingIndicator(isDark, isArabic),
            _buildInputArea(context, isDark, isArabic),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreview(bool isDark, bool isArabic) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? ColorManager.primaryBlue.withOpacity(0.2)
            : ColorManager.lightPrimaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark
              ? ColorManager.primaryBlue
              : ColorManager.lightPrimaryBlue,
        ),
      ),
      child: Row(
        children: [
          Icon(
            attachedFileType?.startsWith('image/') == true
                ? Icons.image
                : Icons.insert_drive_file,
            color: isDark
                ? ColorManager.primaryBlue
                : ColorManager.lightPrimaryBlue,
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              attachedFileName ?? 'File attached',
              style: TextStyles.font12lightgray400w.copyWith(
                color: isDark
                    ? ColorManager.primaryBlue
                    : ColorManager.lightPrimaryBlue,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () => setState(() {
              attachedFile = null;
              attachedFileName = null;
              attachedFileType = null;
            }),
            child: Icon(Icons.close,
                size: 18,
                color: isDark
                    ? ColorManager.primaryBlue
                    : ColorManager.lightPrimaryBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(
      BuildContext context, bool isDark, bool isArabic) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back,
                color:
                isDark ? Colors.white : ColorManager.lightTextPrimary),
          ),
          SizedBox(width: 15),
          Expanded(
            child:Text(
              _currentTitle, // ✅ بدل widget.chatTitle
              style: TextStyles.font20whitebold.copyWith(
                color: isDark ? Colors.white : ColorManager.lightTextPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () => _showChatOptions(context, isDark, isArabic),
            child: Icon(
              Icons.more_vert,
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline,
              size: 80,
              color: isDark ? Colors.white24 : ColorManager.lightBorder),
          SizedBox(height: 20),
          Text(
            isArabic ? 'ابدأ محادثة جديدة' : 'Start a new conversation',
            style: TextStyles.font16white600w.copyWith(
              color: isDark
                  ? Colors.white54
                  : ColorManager.lightTextSecondary,
            ),
          ),
          SizedBox(height: 10),
          Text(
            isArabic
                ? 'اسأل أي سؤال طبي أو ارفع ملف'
                : 'Ask any medical question or attach a file',
            style: TextStyles.font14whitebold.copyWith(
              color: isDark
                  ? Colors.white38
                  : ColorManager.lightTextSecondary,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(bool isDark, bool isArabic) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(20),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isUser = message['role'] == 'user';
        final hasFile = message['hasFile'] == true;
        final fileName = message['fileName'];

        return Align(
          alignment: isUser
              ? (isArabic ? Alignment.centerLeft : Alignment.centerRight)
              : (isArabic
              ? Alignment.centerRight
              : Alignment.centerLeft),
          child: Container(
            margin: EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.all(15),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isUser
                  ? (isDark
                  ? ColorManager.primaryBlue
                  : ColorManager.lightPrimaryBlue)
                  : (isDark
                  ? Color(0xFF1E2A3A)
                  : ColorManager.lightContainer),
              borderRadius: BorderRadius.circular(15),
              border: isUser
                  ? null
                  : Border.all(
                color: isDark
                    ? Color(0xFF2D3E50)
                    : ColorManager.lightBorder,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasFile && fileName != null)
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.attach_file,
                            color: Colors.white, size: 14),
                        SizedBox(width: 6),
                        Text(fileName,
                            style: TextStyles.font12lightgray400w.copyWith(
                                color: Colors.white)),
                      ],
                    ),
                  ),
                Text(
                  message['content'] ?? '',
                  style: isUser
                      ? TextStyles.font14whitebold.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  )
                      : TextStyles.font16white600w.copyWith(
                    // ✅ أكبر للـ AI
                    color: isDark
                        ? Colors.white
                        : ColorManager.lightTextPrimary,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypingIndicator(bool isDark, bool isArabic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Align(
        alignment:
        isArabic ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color:
            isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isDark
                      ? ColorManager.primaryBlue
                      : ColorManager.lightPrimaryBlue,
                ),
              ),
              SizedBox(width: 10),
              Text(
                isArabic ? 'MAISYS يكتب...' : 'MAISYS is typing...',
                style: TextStyles.font12lightgray400w.copyWith(
                  color: isDark
                      ? Colors.white54
                      : ColorManager.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(
      BuildContext context, bool isDark, bool isArabic) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
        border: Border(
          top: BorderSide(
            color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // ✅ زرار الـ attachment
          GestureDetector(
            onTap: () =>
                _showAttachmentOptions(context, isDark, isArabic),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark
                    ? Color(0xFF0D1620)
                    : ColorManager.lightBorder,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.add,
                color: isDark
                    ? ColorManager.primaryBlue
                    : ColorManager.lightPrimaryBlue,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: isDark
                    ? Color(0xFF0D1620)
                    : ColorManager.lightBorder,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isDark
                      ? Color(0xFF2D3E50)
                      : ColorManager.lightBorder,
                  width: 1,
                ),
              ),
              child: Expanded(
                child: TextField(
                  controller: messageController,
                  style: TextStyle(
                    color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                  ),
                  maxLines: 6,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: isArabic ? 'اكتب رسالتك...' : 'Type your message...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white54 : ColorManager.lightTextSecondary,
                    ),
                    filled: true,
                    fillColor: isDark ? Color(0xFF1E2A3A) : ColorManager.lightBorder,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                        width: 1,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  enabled: !isSending,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: isSending ? null : _sendMessage,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSending
                    ? Colors.grey
                    : (isDark
                    ? ColorManager.primaryBlue
                    : ColorManager.lightPrimaryBlue),
                shape: BoxShape.circle,
              ),
              child:
              Icon(Icons.send, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}