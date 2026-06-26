import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_bottom_nav.dart';
import 'settings_scaffold.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      title: 'Contact & Support',
      subtitle: 'We\'re here to help. Reach us through any channel below.',
      children: [
        _contactCard(
          icon: Icons.chat_bubble_outline_rounded,
          title: 'Live Chat',
          subtitle: 'Average reply in under 5 minutes',
          onTap: () => _snack(context, 'Starting live chat...'),
        ),
        SizedBox(height: 12.h),
        _contactCard(
          icon: Icons.email_outlined,
          title: 'Email Support',
          subtitle: 'support@novanews.pro',
          onTap: () => _snack(context, 'Opening email client...'),
        ),
        SizedBox(height: 12.h),
        _contactCard(
          icon: Icons.call_outlined,
          title: 'Call Us',
          subtitle: '+1 (800) 555-0199 • 24/7',
          onTap: () => _snack(context, 'Dialing support...'),
        ),
        SizedBox(height: 12.h),
        _contactCard(
          icon: Icons.bug_report_outlined,
          title: 'Report a Problem',
          subtitle: 'Tell us what went wrong',
          onTap: () => _snack(context, 'Opening report form...'),
        ),
        SizedBox(height: 24.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: AppColors.secondaryFixed.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.schedule_rounded, size: 20.sp, color: AppColors.navy),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Our support team operates around the clock. Premium members '
                  'get priority responses.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.5,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _contactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
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
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryFixed,
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(icon, size: 22.sp, color: AppColors.onSecondaryFixed),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface)),
                    SizedBox(height: 2.h),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  size: 22.sp, color: AppColors.outline),
            ],
          ),
        ),
      );
    });
  }
}
