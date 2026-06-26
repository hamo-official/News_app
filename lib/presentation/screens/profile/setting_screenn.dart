import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/auth_state.dart';
import '../../widgets/app_bottom_nav.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts.first.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(initials: _initials),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Page header
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Manage your account and app experience',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 28.h),
                    // GENERAL
                    _sectionLabel('General'),
                    SizedBox(height: 12.h),
                    _card(children: [
                      _row(
                        context,
                        icon: Icons.menu_book_rounded,
                        label: 'Reading Preferences',
                        onTap: () =>
                            context.push(AppRouter.readingPreferences),
                      ),
                      _rowDivider(),
                      _row(
                        context,
                        icon: Icons.password_rounded,
                        label: 'Change Password',
                        onTap: () => context.push(AppRouter.changePassword),
                      ),
                      _rowDivider(),
                      _row(
                        context,
                        icon: Icons.security_rounded,
                        label: 'Security',
                        onTap: () => context.push(AppRouter.security),
                      ),
                    ]),
                    SizedBox(height: 28.h),
                    // SUPPORT
                    _sectionLabel('Support'),
                    SizedBox(height: 12.h),
                    _card(children: [
                      _row(
                        context,
                        icon: Icons.help_rounded,
                        label: 'Help Center',
                        onTap: () => context.push(AppRouter.helpCenter),
                      ),
                      _rowDivider(),
                      _row(
                        context,
                        icon: Icons.support_agent_rounded,
                        label: 'Contact & Support',
                        onTap: () => context.push(AppRouter.contactSupport),
                      ),
                    ]),
                    SizedBox(height: 28.h),
                    // LEGAL
                    _sectionLabel('Legal'),
                    SizedBox(height: 12.h),
                    _card(children: [
                      _row(
                        context,
                        icon: Icons.policy_rounded,
                        label: 'Privacy Policy',
                        onTap: () => context.push(AppRouter.privacyPolicy),
                      ),
                      _rowDivider(),
                      _row(
                        context,
                        icon: Icons.description_rounded,
                        label: 'Terms & Conditions',
                        onTap: () => context.push(AppRouter.terms),
                      ),
                      _rowDivider(),
                      _row(
                        context,
                        icon: Icons.info_rounded,
                        label: 'About App',
                        onTap: () => context.push(AppRouter.about),
                      ),
                    ]),
                    SizedBox(height: 32.h),
                    // Logout
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<AuthCubit>().signOut();
                          context.go(AppRouter.login);
                        },
                        icon: const Icon(Icons.logout_rounded,
                            color: AppColors.onErrorContainer),
                        label: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onErrorContainer,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.errorContainer,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
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

  Widget _sectionLabel(String text) => Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
            color: AppColors.navy,
          ),
        ),
      );

  Widget _card({required List<Widget> children}) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A0F172A),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(children: children),
      );

  Widget _rowDivider() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Divider(
            height: 1, thickness: 1, color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      );

  Widget _row(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: const BoxDecoration(
                color: AppColors.secondaryFixed,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 22.sp, color: AppColors.onSecondaryFixed),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 24.sp, color: AppColors.outline),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String Function(String) initials;
  const _TopBar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.navy),
            onPressed: () =>
                context.canPop() ? context.pop() : context.go(AppRouter.home),
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
          const Spacer(),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final profile =
                  state is AuthAuthenticated ? state.profile : null;
              return GestureDetector(
                onTap: () => context.go(AppRouter.profile),
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColors.brightBlue,
                  child: Text(
                    initials(profile?.fullName ?? profile?.email ?? 'U'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
