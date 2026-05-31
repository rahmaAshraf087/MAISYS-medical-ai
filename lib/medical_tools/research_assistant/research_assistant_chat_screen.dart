import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/services/api_service.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class ResearchAssistantChatScreen extends StatefulWidget {
  final String paperId;
  final String paperTitle;

  const ResearchAssistantChatScreen({
    super.key,
    required this.paperId,
    required this.paperTitle,
  });

  @override
  State<ResearchAssistantChatScreen> createState() => _ResearchAssistantChatScreenState();
}

class _ResearchAssistantChatScreenState extends State<ResearchAssistantChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final List<Map<String, String>> messages = [];
  bool isSending = false;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || isSending) return;

    setState(() {
      messages.add({'role': 'user', 'content': text});
      isSending = true;
    });

    messageController.clear();

    final result = await ApiService.sendResearchMessage(
      paperId: widget.paperId,
      content: text,
    );

    if (!mounted) return;

    setState(() {
      isSending = false;
      if (result['success'] == true) {
        messages.add({
          'role': 'assistant',
          'content': result['aiResponse'] ?? '',
        });
      } else {
        messages.add({
          'role': 'assistant',
          'content': result['message'] ?? 'Error getting response',
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state.isDarkMode;
    final isArabic = context.watch<LanguageCubit>().state.isArabic;

    return Scaffold(
      backgroundColor: isDark ? ColorManager.kohly : ColorManager.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopHeader(context, isDark, isArabic),

            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue),
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.article,
                    color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.paperTitle,
                      style: TextStyles.font14whitebold.copyWith(
                        color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: messages.isEmpty
                  ? _buildEmptyState(isDark, isArabic)
                  : _buildMessageList(isDark, isArabic),
            ),

            _buildInputArea(isDark, isArabic),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context, bool isDark, bool isArabic) {
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
            child: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : ColorManager.lightTextPrimary,
            ),
          ),
          SizedBox(width: 15),
          Text(
            isArabic ? 'محادثة البحث' : 'Research Chat',
            style: TextStyles.font20whitebold.copyWith(
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
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: isDark ? Colors.white24 : ColorManager.lightBorder,
          ),
          SizedBox(height: 20),
          Text(
            isArabic ? 'اسأل أي سؤال عن الورقة' : 'Ask any question about the paper',
            style: TextStyles.font16white600w.copyWith(
              color: isDark ? Colors.white54 : ColorManager.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(bool isDark, bool isArabic) {
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isUser = message['role'] == 'user';

        return Align(
          alignment: isUser
              ? (isArabic ? Alignment.centerLeft : Alignment.centerRight)
              : (isArabic ? Alignment.centerRight : Alignment.centerLeft),
          child: Container(
            margin: EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.all(15),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isUser
                  ? (isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue)
                  : (isDark ? Color(0xFF1E2A3A) : ColorManager.lightContainer),
              borderRadius: BorderRadius.circular(15),
              border: isUser
                  ? null
                  : Border.all(
                color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
                width: 1,
              ),
            ),
            child: Text(
              message['content']!,
              style: TextStyles.font14whitebold.copyWith(
                color: isUser
                    ? Colors.white
                    : (isDark ? Colors.white : ColorManager.lightTextPrimary),
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputArea(bool isDark, bool isArabic) {
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
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF0D1620) : ColorManager.lightBorder,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isDark ? Color(0xFF2D3E50) : ColorManager.lightBorder,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: messageController,
                style: TextStyle(
                  color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: isArabic ? 'اسأل عن الورقة...' : 'Ask about the paper...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white54 : ColorManager.lightTextSecondary,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}