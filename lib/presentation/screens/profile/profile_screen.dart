import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/auth_state.dart';
import '../../widgets/app_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts.first.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(AppRouter.login);
        }
      },
      builder: (context, state) {
        final profile = state is AuthAuthenticated ? state.profile : null;
        final name = profile?.fullName?.isNotEmpty == true
            ? profile!.fullName!
            : 'NovaNews Reader';
        final email = profile?.email ?? '';

        return Scaffold(
          backgroundColor: AppColors.surface,
          bottomNavigationBar: const AppBottomNav(currentIndex: 3),
          body: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Blue header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
                  decoration: const BoxDecoration(
                    color: AppColors.brightBlue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        // Top row: back + title
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => context.canPop()
                                  ? context.pop()
                                  : context.go(AppRouter.home),
                              child: Icon(Icons.arrow_back_rounded,
                                  color: Colors.white, size: 24.sp),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => context.push(AppRouter.settings),
                              child: Icon(Icons.settings_outlined,
                                  color: Colors.white, size: 24.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        // Avatar
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 2),
                              ),
                              child: CircleAvatar(
                                radius: 40.r,
                                backgroundColor: AppColors.navy,
                                child: Text(
                                  _initials(profile?.fullName ??
                                      profile?.email ?? 'U'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.verified_rounded,
                                    size: 16.sp, color: AppColors.brightBlue),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        OutlinedButton.icon(
                          onPressed: () =>
                              context.push(AppRouter.editProfile),
                          icon: Icon(Icons.edit_rounded,
                              size: 16.sp, color: Colors.white),
                          label: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.1),
                            side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.25)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 18.w, vertical: 8.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.r)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                // Quick actions
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: _quickCard(
                          icon: Icons.bookmark_border_rounded,
                          title: 'Saved News',
                          subtitle: 'View bookmarked articles',
                          onTap: () => _comingSoon(context),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _quickCard(
                          icon: Icons.settings_outlined,
                          title: 'Settings',
                          subtitle: 'Manage preferences',
                          onTap: () => context.push(AppRouter.settings),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                // General menu
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
                        child: Text(
                          'GENERAL MENU',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: AppColors.outline,
                          ),
                        ),
                      ),
                      _menuRow(
                        icon: Icons.person_outline_rounded,
                        title: 'Edit Profile',
                        subtitle: 'Manage your identity',
                        onTap: () => context.push(AppRouter.editProfile),
                      ),
                      SizedBox(height: 8.h),
                      _menuRow(
                        icon: Icons.menu_book_rounded,
                        title: 'Reading Preferences',
                        subtitle: 'Customize your experience',
                        onTap: () =>
                            context.push(AppRouter.readingPreferences),
                      ),
                      SizedBox(height: 8.h),
                      _menuRow(
                        icon: Icons.lock_outline_rounded,
                        title: 'Change Password',
                        subtitle: 'Update your credentials',
                        onTap: () => context.push(AppRouter.changePassword),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28.h),
                // Logout
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.read<AuthCubit>().signOut(),
                      icon: const Icon(Icons.logout_rounded,
                          color: AppColors.errorRed),
                      label: Text(
                        'LOGOUT ACCOUNT',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          color: AppColors.errorRed,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            AppColors.errorRed.withValues(alpha: 0.05),
                        side: BorderSide(
                            color: AppColors.errorRed.withValues(alpha: 0.2)),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.r)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'NovaNews v1.0.0 • Premium Member',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.outline.withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _quickCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0A0F172A),
                blurRadius: 18,
                offset: Offset(0, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.secondaryFixed,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 20.sp, color: AppColors.navy),
            ),
            SizedBox(height: 12.h),
            Text(title,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface)),
            SizedBox(height: 2.h),
            Text(subtitle,
                style: TextStyle(
                    fontSize: 11.sp,
                    height: 1.3,
                    color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  Widget _menuRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, size: 20.sp, color: AppColors.navy),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface)),
                  SizedBox(height: 2.h),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12.sp, color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 20.sp, color: AppColors.outlineVariant),
          ],
        ),
      ),
    );
  }
}
