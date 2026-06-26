import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

/// Shared scaffold for simple settings/content sub-pages: a "NovaNews" top bar
/// with back button, a page title + subtitle, then the provided children.
class SettingsScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final Widget? bottomNavigationBar;

  const SettingsScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: bottomNavigationBar,
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
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: AppColors.navy,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 8.h),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 15.sp,
                          height: 1.5,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    SizedBox(height: 24.h),
                    ...children,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A titled block of body text used by the legal pages.
class LegalSection extends StatelessWidget {
  final String heading;
  final String body;
  const LegalSection({super.key, required this.heading, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            body,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.7,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
