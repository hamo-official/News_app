import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_bottom_nav.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              height: 56.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                      color: Color(0x0A0F172A),
                      blurRadius: 30,
                      offset: Offset(0, 10)),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: AppColors.navy),
                    onPressed: () => context.pop(),
                  ),
                  Text(
                    'NovaNews',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
                child: Column(
                  children: [
                    Container(
                      width: 84.w,
                      height: 84.w,
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(22.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.navy.withValues(alpha: 0.3),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(Icons.article_rounded,
                          color: Colors.white, size: 42.sp),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'NovaNews',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Version 1.0.0 (Build 1)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Professional Flutter Development',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.navy,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Container(
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x0A0F172A),
                              blurRadius: 24,
                              offset: Offset(0, 8)),
                        ],
                      ),
                      child: Text(
                        'NovaNews delivers curated, AI-powered news tailored to '
                        'your interests. Stay informed with breaking stories, '
                        'in-depth analysis, and personalized content from trusted '
                        'sources around the world.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          height: 1.6,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _infoCard([
                      _infoRow('Developer', 'ILC Soft Training'),
                      _infoRow('Framework', 'Flutter 3.x'),
                      _infoRow('Backend', 'Supabase'),
                      _infoRow('AI Engine', 'Google Gemini'),
                      _infoRow('Version', '1.0.0 (Build 1)', last: true),
                    ]),
                    SizedBox(height: 28.h),
                    Text(
                      '© 2026 NovaNews. All rights reserved.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(List<Widget> rows) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0A0F172A),
                blurRadius: 24,
                offset: Offset(0, 8)),
          ],
        ),
        child: Column(children: rows),
      );

  Widget _infoRow(String label, String value, {bool last = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        border: last
            ? null
            : Border(
                bottom: BorderSide(
                    color: AppColors.outlineVariant.withValues(alpha: 0.4))),
      ),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14.sp, color: AppColors.onSurfaceVariant)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface)),
        ],
      ),
    );
  }
}
