import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/presentation/screens/auth/forget_password_screen.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(AppRouter.home);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.tertiary,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 242, 243),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 48.h),
                  Center(
                    child: Column(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'NovaNews',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 57, 136),
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "INTELLIGENCE IN MOTION",
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Access your personalized briefing.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 40.h),
                            _label(' Work Email'),
                            SizedBox(height: 8.h),
                            _field(
                              controller: _emailCtrl,
                              hint: 'name@company.com',
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => (v == null || !v.contains('@'))
                                  ? 'Enter a valid email'
                                  : null,
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _label('Password'),
                                TextButton(
                                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen(),)); },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        0,
                                        64,
                                        153,
                                      ),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            _field(
                              controller: _passwordCtrl,
                              hint: '••••••••',
                              obscure: _obscure,
                              suffix: IconButton(
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.textSecondary,
                                  size: 20.sp,
                                ),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                              validator: (v) => (v == null || v.length < 6)
                                  ? 'Password must be at least 6 characters'
                                  : null,
                            ),
                            SizedBox(height: 20.h),
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 45.h,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        0,
                                        57,
                                        136,
                                      ),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          14.r,
                                        ),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: state is AuthLoading
                                        ? null
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context.read<AuthCubit>().signIn(
                                                email: _emailCtrl.text.trim(),
                                                password: _passwordCtrl.text
                                                    .trim(),
                                              );
                                            }
                                          },
                                    child: state is AuthLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            'Login  ->',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                            Container(
                              padding: EdgeInsets.all(25),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: const Color.fromARGB(
                                        255,
                                        233,
                                        228,
                                        228,
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      "OR CONTINUE WITH",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: const Color.fromARGB(
                                          255,
                                          131,
                                          128,
                                          128,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Divider(
                                      color: const Color.fromARGB(
                                        255,
                                        233,
                                        228,
                                        228,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      // Google login
                                    },
                                    child: Text("Google"),
                                  ),
                                ),

                                SizedBox(width: 20),

                                Expanded(
                                  child: OutlinedButton(
                                    style: ButtonStyle(),
                                    onPressed: () {
                                      // LinkedIn login
                                    },
                                    child: Text("LinkedIn"),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        context.push(AppRouter.register),
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 45),
                  Text(
                    " @ 2024 NovaNews Media Group. All rights reserved,\n                  Privacy Policy . Terms of Service",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
  );

  Widget _field({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.tertiary, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }
}
