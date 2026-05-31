import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maisys/cubit/theme_cubit/theme_cubit.dart';
import 'package:maisys/cubit/language_cubit/language_cubit.dart';
import 'package:maisys/services/api_service.dart';
import 'package:maisys/widgets/app_drawer.dart';
import 'package:maisys/widgets/app_header.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<Map<String, dynamic>> activities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final result = await ApiService.getActivities();
    if (!mounted) return;
    setState(() {
      isLoading = false;
      if (result['success'] == true) {
        activities = List<Map<String, dynamic>>.from(
            result['activities'] ?? []);
      }
    });
  }

  IconData _getToolIcon(String toolName) {
    switch (toolName) {
      case 'chat': return Icons.chat_bubble_outline;
      case 'drug_interaction': return Icons.medication_outlined;
      case 'lab_test': return Icons.biotech_outlined;
      case 'research': return Icons.article_outlined;
      default: return Icons.medical_services_outlined;
    }
  }

  Color _getToolColor(String toolName) {
    switch (toolName) {
      case 'chat': return Color(0xFF00B4D8);
      case 'drug_interaction': return Color(0xFFEF4444);
      case 'lab_test': return Color(0xFF10B981);
      case 'research': return Color(0xFFF59E0B);
      default: return Color(0xFF00B4D8);
    }
  }

  String _formatTime(String? dateStr, bool isArabic) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inMinutes < 60) {
        return isArabic ? 'منذ ${diff.inMinutes} دقيقة' : '${diff.inMinutes}m ago';
      } else if (diff.inHours < 24) {
        return isArabic ? 'منذ ${diff.inHours} ساعة' : '${diff.inHours}h ago';
      } else {
        return isArabic ? 'منذ ${diff.inDays} يوم' : '${diff.inDays}d ago';
      }
    } catch (_) {
      return '';
    }
  }

  String _getToolName(String toolName, bool isArabic) {
    final names = {
      'chat': isArabic ? 'الشات بوت الطبي' : 'Medical Chat',
      'drug_interaction': isArabic ? 'تفاعل الأدوية' : 'Drug Interaction',
      'lab_test': isArabic ? 'تحليل التحاليل' : 'Lab Test',
      'research': isArabic ? 'مساعد البحث' : 'Research Assistant',
    };
    return names[toolName] ?? toolName;
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
            AppHeader(title: isArabic ? 'النشاط' : 'Activity'), // ✅
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    isLoading
                        ? Center(
                      child: CircularProgressIndicator(
                        color: isDark
                            ? ColorManager.primaryBlue
                            : ColorManager.lightPrimaryBlue,
                      ),
                    )
                        : _buildActivityList(isDark, isArabic),
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
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => OverviewScreen()),
                  );
                },
                child: _buildNavIcon(Icons.home_outlined, false, isDark),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PreChatScreen()),
                  );
                },
                child: _buildNavIcon(Icons.chat_bubble_outline, false, isDark),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
                child: _buildNavIcon(Icons.settings_outlined, false, isDark),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
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
  }
*/
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
  Widget _buildActivityList(bool isDark, bool isArabic) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: isDark ? ColorManager.primaryBlue : ColorManager.lightPrimaryBlue,
        ),
      );
    }

    if (activities.isEmpty) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            Icon(Icons.history,
                size: 80,
                color: isDark ? Colors.white24 : ColorManager.lightBorder),
            SizedBox(height: 20),
            Text(
              isArabic ? 'لا يوجد نشاط بعد' : 'No activity yet',
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
        children: activities.map((activity) {
          final toolName = activity['toolName'] ?? 'chat';
          final displayName = _getToolName(toolName, isArabic);
          final timeStr = _formatTime(activity['createdAt'], isArabic);
          final icon = _getToolIcon(toolName);
          final color = _getToolColor(toolName);

          return Container(
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
                // ✅ Icon بدون background bubble
                Icon(icon, color: color, size: 32),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: isArabic
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: TextStyles.font16white600w.copyWith(
                          color: isDark ? Colors.white : ColorManager.lightTextPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        timeStr,
                        style: TextStyles.font12lightgray400w.copyWith(
                          color: isDark ? Colors.white54 : ColorManager.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}