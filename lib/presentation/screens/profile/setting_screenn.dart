import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/auth_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsOn = true;
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    _buildProfileCard(),
                    SizedBox(height: 20.h),
                    _sectionLabel('ACCOUNT'),
                    _groupedCard(
                      children: [
                        _tile(
                          icon: Icons.person_outline,
                          label: 'Edit Profile',
                          onTap: () => context.push(AppRouter.profile),
                        ),
                        _divider(),
                        _tile(
                          icon: Icons.lock_outline,
                          label: 'Change Password',
                          onTap: () => context.push(AppRouter.changePassword),
                        ),
                        _divider(),
                        _tile(
                          icon: Icons.shield_outlined,
                          label: 'Security',
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    _sectionLabel('PREFERENCES'),
                    _groupedCard(
                      children: [
                        _switchTile(
                          icon: Icons.notifications_none,
                          label: 'Notifications',
                          value: _notificationsOn,
                          onChanged: (v) =>
                              setState(() => _notificationsOn = v),
                        ),
                        _divider(),
                        _tile(
                          icon: Icons.language,
                          label: 'Language',
                          trailingText: 'English',
                          onTap: () {},
                        ),
                        _divider(),
                        _themeTile(),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    _sectionLabel('SUPPORT'),
                    _groupedCard(
                      children: [
                        _tile(
                          icon: Icons.help_outline,
                          label: 'Help Center',
                          onTap: () {},
                        ),
                        _divider(),
                        _tile(
                          icon: Icons.mail_outline,
                          label: 'Contact Support',
                          onTap: () {},
                        ),
                        _divider(),
                        _tile(
                          icon: Icons.info_outline,
                          label: 'About App',
                          trailingText: 'v2.4.0',
                          onTap: () {},
                          showChevron: false,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    _sectionLabel('ACCOUNT ACTIONS'),
                    _groupedCard(
                      children: [
                        _tile(
                          icon: Icons.logout,
                          label: 'Logout',
                          color: AppColors.primary,
                          showChevron: false,
                          onTap: () {
                            context.read<AuthCubit>().signOut();
                            context.go(AppRouter.login);
                          },
                        ),
                        _divider(),
                        _tile(
                          icon: Icons.delete_outline,
                          label: 'Delete Account',
                          color: AppColors.tertiary,
                          showChevron: false,
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 8.h, 16.w, 8.h),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const Icon(Icons.search, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final profile = state is AuthAuthenticated ? state.profile : null;
        final name = profile?.fullName?.isNotEmpty == true
            ? profile!.fullName!
            : 'Not set';
        final email = profile?.email ?? '';

        return Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.neutral,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26.r,
                backgroundColor: AppColors.primary,
                child: Text(
                  _initials(profile?.fullName ?? profile?.email ?? 'U'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _groupedCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() => Divider(
        height: 1,
        thickness: 1,
        indent: 52.w,
        color: AppColors.divider,
      );

  Widget _tile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.black87,
    String? trailingText,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        child: Row(
          children: [
            Icon(icon, size: 20.sp,
                color: color == Colors.black87 ? AppColors.primary : color),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
              ),
              SizedBox(width: 6.w),
            ],
            if (showChevron)
              Icon(Icons.chevron_right, size: 20.sp,
                  color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: AppColors.primary),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _themeTile() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Row(
        children: [
          Icon(Icons.palette_outlined, size: 20.sp, color: AppColors.primary),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              'Theme',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppColors.neutral,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                _themeOption(
                  label: 'Light',
                  icon: Icons.wb_sunny_outlined,
                  selected: !_isDarkMode,
                  onTap: () => setState(() => _isDarkMode = false),
                ),
                _themeOption(
                  label: 'Dark',
                  icon: Icons.nightlight_outlined,
                  selected: _isDarkMode,
                  onTap: () => setState(() => _isDarkMode = true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _themeOption({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14.sp,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.black87 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts.first.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
