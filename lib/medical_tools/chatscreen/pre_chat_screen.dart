import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/medical_tools/chatscreen/chat_screen.dart';
import 'package:maisys/services/api_service.dart';
import 'package:maisys/widgets/app_drawer.dart';
import 'package:maisys/widgets/app_header.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';
import 'package:share_plus/share_plus.dart';

class PreChatScreen extends StatefulWidget {
  const PreChatScreen({super.key});

  @override
  State<PreChatScreen> createState() => _PreChatScreenState();
}

class _PreChatScreenState extends State<PreChatScreen> {
  List<Map<String, dynamic>> chats = [];
  bool isLoading = true;
  File? _profileImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  void _showChatOptions(BuildContext context, String chatId, String chatTitle,
      bool isDark, bool isArabic) {
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

            // Rename
            ListTile(
              leading: Icon(Icons.edit_outlined,
                  color: isDark ? Colors.white : ColorManager.lightTextPrimary),
              title: Text(isArabic ? 'إعادة تسمية' : 'Rename',
                  style: TextStyles.font16white600w.copyWith(
                    color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                  )),
              onTap: () {
                Navigator.pop(context);
                _showRenameDialog(context, chatId, chatTitle, isDark, isArabic);
              },
            ),

            // Pin
            ListTile(
              leading: Icon(Icons.push_pin_outlined,
                  color: isDark ? Colors.white : ColorManager.lightTextPrimary),
              title: Text(isArabic ? 'تثبيت' : 'Pin',
                  style: TextStyles.font16white600w.copyWith(
                    color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                  )),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isArabic ? 'تم التثبيت' : 'Pinned')),
                );
              },
            ),

            // Share
            ListTile(
              leading: Icon(Icons.share_outlined,
                  color: isDark ? Colors.white : ColorManager.lightTextPrimary),
              title: Text(isArabic ? 'مشاركة' : 'Share',
                  style: TextStyles.font16white600w.copyWith(
                    color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                  )),
              onTap: () async {
                Navigator.pop(context);
                await Share.share(
                  'maisys://chat/$chatId',
                  subject: chatTitle,
                );
              },
            ),

            // Delete
            ListTile(
              leading: Icon(Icons.delete_outline, color: Colors.red),
              title: Text(isArabic ? 'حذف' : 'Delete',
                  style: TextStyles.font16white600w.copyWith(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: isDark
                        ? Color(0xFF1E2A3A)
                        : ColorManager.lightContainer,
                    title: Text(isArabic ? 'حذف المحادثة' : 'Delete Chat',
                        style: TextStyle(
                          color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                        )),
                    content: Text(
                      isArabic
                          ? 'هل أنت متأكد؟'
                          : 'Are you sure?',
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
                  final result = await ApiService.deleteChat(chatId);
                  if (!mounted) return;
                  if (result['success'] == true) {
                    _loadChats();
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

  void _showRenameDialog(BuildContext context, String chatId, String currentTitle,
      bool isDark, bool isArabic) {
    final controller = TextEditingController(text: currentTitle);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
        title: Text(isArabic ? 'إعادة تسمية' : 'Rename',
            style: TextStyle(
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            )),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(
            color: isDark ? Colors.white : ColorManager.lightTextPrimary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? Color(0xFF0D1620) : ColorManager.lightBorder,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hintText: isArabic ? 'اسم جديد' : 'New name',
            hintStyle: TextStyle(
              color: isDark ? Colors.white38 : ColorManager.lightTextSecondary,
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
              await ApiService.renameChat(chatId: chatId, newTitle: newTitle);
              if (!mounted) return;
              _loadChats();
            },
            child: Text(
              isArabic ? 'حفظ' : 'Save',
              style: TextStyle(
                color: isDark
                    ? ColorManager.primaryBlue
                    : ColorManager.lightPrimaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _loadChats() async {
    final result = await ApiService.getChats();
    if (!mounted) return;
    setState(() {
      isLoading = false;
      if (result['success'] == true) {
        chats = List<Map<String, dynamic>>.from(result['chats'] ?? []);
      }
    });
  }

  Future<void> _createNewChat() async {
    //final isDark = context.read<ThemeCubit>().state.isDarkMode;
    final isArabic = context.read<LanguageCubit>().state.isArabic;

    final result = await ApiService.createChat(
      title: isArabic ? 'محادثة جديدة' : 'New Chat',
    );

    if (!mounted) return;

    if (result['success'] == true) {
      final chat = result['chat'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            chatId: chat['_id'],
            chatTitle: chat['title'] ?? 'New Chat',
          ),
        ),
      ).then((_) => _loadChats());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed to create chat'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _profileImage = File(image.path));
    }
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _profileImage = File(image.path));
    }
  }

  void _removePhoto() {
    setState(() => _profileImage = null);
  }

  void _showImageOptions(BuildContext context, bool isDark, bool isArabic) {
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
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.photo_library,
                  color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue),
              title: Text(
                isArabic ? 'اختر من المعرض' : 'Choose from Gallery',
                style: TextStyles.font16white600w.copyWith(
                  color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt,
                  color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue),
              title: Text(
                isArabic ? 'التقاط صورة' : 'Take Photo',
                style: TextStyles.font16white600w.copyWith(
                  color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            if (_profileImage != null)
              ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.red),
                title: Text(
                  isArabic ? 'حذف الصورة' : 'Remove Photo',
                  style: TextStyles.font16white600w.copyWith(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _removePhoto();
                },
              ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  String _formatTime(String? dateStr, bool isArabic) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 60) {
        return isArabic
            ? 'منذ ${diff.inMinutes} دقيقة'
            : '${diff.inMinutes}m ago';
      } else if (diff.inHours < 24) {
        return isArabic
            ? 'منذ ${diff.inHours} ساعة'
            : '${diff.inHours}h ago';
      } else {
        return isArabic
            ? 'منذ ${diff.inDays} يوم'
            : '${diff.inDays}d ago';
      }
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state.isDarkMode;
    final isArabic = context.watch<LanguageCubit>().state.isArabic;

    return Scaffold(
      backgroundColor:
      isDark ? ColorManager.kohly : ColorManager.lightBackground,
      endDrawer: AppDrawer(), // ✅
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(title: isArabic ? 'المحادثات' : 'Chat History'), // ✅
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    _buildNewChatButton(context, isDark, isArabic),
                    SizedBox(height: 20),
                    isLoading
                        ? Center(
                      child: CircularProgressIndicator(
                        color: isDark
                            ? ColorManager.primaryBlue
                            : ColorManager.lightPrimaryBlue,
                      ),
                    )
                        : _buildChatList(context, isDark, isArabic),
                    SizedBox(height: 40),
                    // ✅ حذفنا Footer و MedicalDisclaimer
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*Widget _buildTopHeader(BuildContext context, bool isDark) {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            isDark
                ? "assets/svgs/appbar_logo/WhiteLogo.png"
                : "assets/svgs/appbar_logo/BlackLogo.png",
            width: 120,
            height: 40,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: _buildNavIcon(Icons.arrow_back, false, isDark),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => OverviewScreen())),
                child: _buildNavIcon(Icons.home_outlined, false, isDark),
              ),
              SizedBox(width: 10),
              _buildNavIcon(Icons.chat_bubble_outline, true, isDark),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => SettingsScreen())),
                child: _buildNavIcon(Icons.settings_outlined, false, isDark),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ProfileScreen())),
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: isDark
                        ? ColorManager.primaryBlue
                        : ColorManager.lightPrimaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }*/

  /*Widget _buildNavIcon(IconData icon, bool isActive, bool isDark) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: isActive
            ? (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue)
            : (isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isDark ? Colors.white : ColorManager.lightTextPrimary,
        size: 18,
      ),
    );
  }
*/
  Widget _buildNewChatButton(
      BuildContext context, bool isDark, bool isArabic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _createNewChat,
          style: ElevatedButton.styleFrom(
            backgroundColor:
            isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.white),
              SizedBox(width: 10),
              Text(
                isArabic ? 'محادثة جديدة' : 'New Chat',
                style: TextStyles.font16white600w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatList(BuildContext context, bool isDark, bool isArabic) {
    if (chats.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.chat_bubble_outline,
                size: 80,
                color: isDark ? Colors.white24 : ColorManager.lightBorder),
            SizedBox(height: 20),
            Text(
              isArabic ? 'لا توجد محادثات بعد' : 'No chats yet',
              style: TextStyles.font16white600w.copyWith(
                color: isDark ? Colors.white54 : ColorManager.lightTextSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: chats.map((chat) {
          // ✅ نجيب أول رسالة من اليوزر
          final messages = List<dynamic>.from(chat['messages'] ?? []);
          final userMessages = messages.where((m) => m['role'] == 'user').toList();
          final preview = userMessages.isNotEmpty
              ? userMessages.first['content']?.toString() ?? ''
              : (isArabic ? 'لا توجد رسائل بعد' : 'No messages yet');

          // ✅ عنوان الشات
          final title = chat['title']?.toString() ?? 'Chat';
          final timeStr = _formatTime(chat['updatedAt'], isArabic);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    chatId: chat['_id'],
                    chatTitle: title,
                  ),
                ),
              ).then((_) => _loadChats());
            },
            // ✅ Long press
            onLongPress: () => _showChatOptions(
                context, chat['_id'], title, isDark, isArabic),
            child: Container(
              margin: EdgeInsets.only(bottom: 15),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Color(0xFF2D3E50)
                          : ColorManager.lightBorder,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      color: isDark
                          ? ColorManager.primaryBlue
                          : ColorManager.lightPrimaryBlue,
                      size: 22,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ عنوان الشات
                        Text(
                          title,
                          style: TextStyles.font16white600w.copyWith(
                            color: isDark
                                ? Colors.white
                                : ColorManager.lightTextPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        // ✅ أول رسالة
                        Text(
                          preview,
                          style: TextStyles.font14whitebold.copyWith(
                            color: isDark
                                ? Colors.white54
                                : ColorManager.lightTextSecondary,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    timeStr,
                    style: TextStyles.font12lightgray400w.copyWith(
                      color: isDark
                          ? Colors.white38
                          : ColorManager.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}