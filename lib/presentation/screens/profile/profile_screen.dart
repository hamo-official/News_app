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
        final profile =
            state is AuthAuthenticated ? state.profile : null;

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
              'My Profile',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
            actions: [
              if (state is! AuthLoading)
                TextButton(
                  onPressed: () {
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
                  child: Text(
                    _isEditing ? 'Save' : 'Edit',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          body: state is AuthLoading
              ? const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.primary, strokeWidth: 2),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Avatar
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
                        SizedBox(height: 8.h),
                        Text(
                          profile?.email ?? '',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        // Full name tile
                        _profileTile(
                          label: 'Full Name',
                          value: profile?.fullName ?? 'Not set',
                          isEditing: _isEditing,
                          controller: _nameCtrl,
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Enter your name'
                              : null,
                        ),
                        SizedBox(height: 16.h),
                        // Email tile (read-only)
                        _profileTile(
                          label: 'Email',
                          value: profile?.email ?? '',
                          isEditing: false,
                        ),
                        SizedBox(height: 40.h),
                        // Sign out
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.tertiary,
                              side: const BorderSide(
                                  color: AppColors.tertiary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                            onPressed: () =>
                                context.read<AuthCubit>().signOut(),
                            child: Text(
                              'Sign Out',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _profileTile({
    required String label,
    required String value,
    required bool isEditing,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
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
          SizedBox(height: 6.h),
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
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
