import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/auth_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String _newPassword = '';

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool get _has8 => _newPassword.length >= 8;
  bool get _hasSpecialOrNum =>
      _newPassword.contains(RegExp(r'[0-9!@#$%^&*(),.?":{}|<>_\-]'));

  // 0 = none, 1 = weak, 2 = moderate, 3 = strong
  int get _strength {
    if (_newPassword.isEmpty) return 0;
    if (_newPassword.length < 6) return 1;
    if (_newPassword.length < 10) return 2;
    return 3;
  }

  ({String label, Color color, double fraction}) get _strengthMeta {
    switch (_strength) {
      case 1:
        return (label: 'Weak', color: AppColors.errorRed, fraction: 0.33);
      case 2:
        return (
          label: 'Moderate',
          color: const Color(0xFFC77700),
          fraction: 0.66
        );
      case 3:
        return (label: 'Strong', color: AppColors.brightBlue, fraction: 1.0);
      default:
        return (label: '', color: Colors.transparent, fraction: 0.0);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r)),
        child: Padding(
          padding: EdgeInsets.all(28.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: const BoxDecoration(
                  color: AppColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.lock_open_rounded,
                    size: 32.sp, color: AppColors.navy),
              ),
              SizedBox(height: 20.h),
              Text(
                'Password Updated',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Your security settings have been successfully updated.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.5,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.r)),
                    elevation: 0,
                  ),
                  child: Text('Dismiss',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is PasswordChangeSuccess) {
          _showSuccessDialog();
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorRed,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        bottomNavigationBar: const AppBottomNav(currentIndex: 3),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _topBar(context),
              Expanded(
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Change Password',
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                                color: AppColors.navy,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Ensure your account stays secure by using a '
                              'strong, unique password.',
                              style: TextStyle(
                                fontSize: 15.sp,
                                height: 1.5,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 28.h),
                            _label('Current Password'),
                            SizedBox(height: 8.h),
                            _passwordField(
                              controller: _currentCtrl,
                              obscure: _obscureCurrent,
                              onToggle: () => setState(
                                  () => _obscureCurrent = !_obscureCurrent),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Enter your current password'
                                  : null,
                            ),
                            SizedBox(height: 20.h),
                            _label('New Password'),
                            SizedBox(height: 8.h),
                            _passwordField(
                              controller: _newCtrl,
                              obscure: _obscureNew,
                              onToggle: () =>
                                  setState(() => _obscureNew = !_obscureNew),
                              onChanged: (v) =>
                                  setState(() => _newPassword = v),
                              validator: (v) {
                                if (v == null || v.length < 8) {
                                  return 'At least 8 characters required';
                                }
                                if (!_hasSpecialOrNum) {
                                  return 'Add a number or special character';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 12.h),
                            _strengthIndicator(),
                            SizedBox(height: 20.h),
                            _label('Confirm New Password'),
                            SizedBox(height: 8.h),
                            _passwordField(
                              controller: _confirmCtrl,
                              obscure: _obscureConfirm,
                              onToggle: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm),
                              validator: (v) => (v != _newCtrl.text)
                                  ? 'Passwords do not match'
                                  : null,
                            ),
                            SizedBox(height: 32.h),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!
                                            .validate()) {
                                          context
                                              .read<AuthCubit>()
                                              .changePassword(
                                                currentPassword:
                                                    _currentCtrl.text,
                                                newPassword: _newCtrl.text,
                                              );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.navy,
                                  foregroundColor: Colors.white,
                                  padding:
                                      EdgeInsets.symmetric(vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100.r)),
                                  elevation: 0,
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        width: 20.w,
                                        height: 20.w,
                                        child:
                                            const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        'Update Password',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed:
                                    isLoading ? null : () => context.pop(),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.slate,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Container(
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
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.navy),
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
    );
  }

  Widget _label(String text) => Padding(
        padding: EdgeInsets.only(left: 4.w),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );

  Widget _strengthIndicator() {
    final meta = _strengthMeta;
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),
                  child: LinearProgressIndicator(
                    value: meta.fraction,
                    minHeight: 4.h,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation(meta.color),
                  ),
                ),
              ),
              if (meta.label.isNotEmpty) ...[
                SizedBox(width: 10.w),
                Text(
                  meta.label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: meta.color,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 10.h),
          _checkItem('At least 8 characters', _has8),
          SizedBox(height: 4.h),
          _checkItem('Includes a special character or number', _hasSpecialOrNum),
        ],
      ),
    );
  }

  Widget _checkItem(String text, bool done) {
    return Row(
      children: [
        Icon(
          done ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
          size: 16.sp,
          color: done ? AppColors.brightBlue : AppColors.outline,
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            color: done ? AppColors.onSurface : AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      onChanged: onChanged,
      style: TextStyle(
          color: AppColors.onSurface, fontSize: 15.sp),
      decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle: TextStyle(
            color: AppColors.outlineVariant, fontSize: 16.sp, letterSpacing: 2),
        suffixIcon: IconButton(
          icon: Icon(
            obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.outline,
            size: 20.sp,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: AppColors.surfaceLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: AppColors.navy, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
    );
  }
}
