import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/auth_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthCubit>().state;
    final name =
        state is AuthAuthenticated ? state.profile?.fullName ?? '' : '';
    _nameCtrl = TextEditingController(text: name);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(AppRouter.login);
        } else if (state is AuthAuthenticated && _isEditing) {
          setState(() => _isEditing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: AppColors.primary,
            ),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.tertiary,
            ),
          );
        }
      },
      builder: (context, state) {
        final profile = state is AuthAuthenticated ? state.profile : null;
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.neutral,
          appBar: AppBar(
            backgroundColor: AppColors.neutral,
            elevation: 0,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary, size: 20),
            ),
            title: Text(
              'Profile',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.primary, strokeWidth: 2),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar + name + email
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 88.w,
                                height: 88.w,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    _initials(
                                        profile?.fullName ?? profile?.email ?? 'U'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                profile?.fullName?.isNotEmpty == true
                                    ? profile!.fullName!
                                    : 'Not set',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                profile?.email ?? '',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32.h),
                        _sectionLabel('Personal Information'),
                        SizedBox(height: 12.h),
                        _groupedCard(
                          children: [
                            _infoTile(
                              icon: Icons.person_outline,
                              label: 'Full Name',
                              isEditing: _isEditing,
                              controller: _nameCtrl,
                              value: profile?.fullName?.isNotEmpty == true
                                  ? profile!.fullName!
                                  : 'Not set',
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Enter your name'
                                  : null,
                            ),
                            _divider(),
                            _infoTile(
                              icon: Icons.cake_outlined,
                              label: 'Age',
                              isEditing: false,
                              value: 'Not set',
                            ),
                            _divider(),
                            _infoTile(
                              icon: Icons.public_outlined,
                              label: 'Country',
                              isEditing: false,
                              value: 'Not set',
                            ),
                            _divider(),
                            _infoTile(
                              icon: Icons.mail_outline,
                              label: 'Email',
                              isEditing: false,
                              value: profile?.email ?? '',
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        _sectionLabel('Account'),
                        SizedBox(height: 12.h),
                        _groupedCard(
                          children: [
                            _actionTile(
                              icon: Icons.edit_outlined,
                              label: _isEditing ? 'Save Profile' : 'Edit Profile',
                              onTap: () {
                                if (_isEditing) {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().updateProfile(
                                          fullName: _nameCtrl.text.trim(),
                                        );
                                  }
                                } else {
                                  setState(() => _isEditing = true);
                                }
                              },
                            ),
                            _divider(),
                            _actionTile(
                              icon: Icons.lock_outline,
                              label: 'Change Password',
                              onTap: () =>
                                  context.push(AppRouter.changePassword),
                            ),
                            _divider(),
                            _actionTile(
                              icon: Icons.logout,
                              label: 'Logout',
                              color: AppColors.tertiary,
                              showChevron: false,
                              onTap: () =>
                                  context.read<AuthCubit>().signOut(),
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
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

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    required bool isEditing,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: AppColors.primary),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                if (isEditing && controller != null)
                  TextFormField(
                    controller: controller,
                    validator: validator,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                  )
                else
                  Text(
                    value,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = AppColors.textPrimary,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          children: [
            Icon(icon, size: 20.sp,
                color: color == AppColors.textPrimary ? AppColors.primary : color),
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
            if (showChevron)
              Icon(Icons.chevron_right, size: 20.sp,
                  color: AppColors.textSecondary),
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
