import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/presentation/screens/auth/login_screen.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
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
        } else if (state is AuthEmailConfirmationRequired) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text('Check your email'),
              content: const Text(
                'We sent a confirmation link to your email address. '
                'Please confirm it, then sign in.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go(AppRouter.login);
                  },
                  child: const Text('Go to Sign In'),
                ),
              ],
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
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 25,
          actions: [
            TextButton(
              onPressed: () {},
              child: Text(
                'Log\nin',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
          automaticallyImplyLeading: false,
          elevation: 1,
          title: Row(
            children: [
              Text(
                'NovaNews',
                style: TextStyle(fontSize: 20, color: AppColors.primary),
              ),
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>LoginScreen(), ));
                    },
                    child: Text(
                      'Already have an \naccount? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 0, 51, 218),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 50),
            ],
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 240, 241, 243),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 32.h),

                  SizedBox(height: 32.h),
                  Text(
                    'Join the lnner Circle',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Experience journalism refined for the \n             modern executive',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Container(
                    margin: EdgeInsets.all(3),
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 32.h),
                        _label('Full Name'),
                        SizedBox(height: 8.h),
                        _field(
                          prefixIcon: Icon(Icons.person_outline),
                          controller: _nameCtrl,
                          hint: 'Alexande Nova',
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Enter your name'
                              : null,
                        ),
                        SizedBox(height: 20.h),
                        _label('Work Email'),
                        SizedBox(height: 8.h),
                        _field(
                          prefixIcon: Icon(Icons.mail_outline),
                          controller: _emailCtrl,
                          hint: 'alex@company.com',
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => (v == null || !v.contains('@'))
                              ? 'Enter a valid email'
                              : null,
                        ),
                        SizedBox(height: 20.h),
                        _label('Password'),
                        SizedBox(height: 8.h),
                        _field(
                          prefixIcon: Icon(Icons.lock_outline),
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
                        _label("Confirm"),
                        SizedBox(height: 8.h),
                        _field(
                          prefixIcon: Icon(Icons.health_and_safety_rounded),
                          controller: _passwordCtrl,
                          hint: '••••••••',
                        ),
                        SizedBox(height: 32.h),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.check_box_outline_blank),
                            ),
                            Text(
                              "i agree to the terms of the service and privacy \n policy inculuding the use of cookies.  ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return SizedBox(
                              width: double.infinity,
                              height: 52.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    0,
                                    52,
                                    126,
                                  ),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: state is AuthLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<AuthCubit>().signUp(
                                            email: _emailCtrl.text.trim(),
                                            password: _passwordCtrl.text.trim(),
                                            fullName: _nameCtrl.text.trim(),
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
                                        'Create Account',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 25.h),
                        Row(
                          children: [
                            Expanded(child: Divider(thickness: 1)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("OR CONTINUE WITH"),
                            ),
                            Expanded(child: Divider(thickness: 1)),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    Icon(Icons.generating_tokens_outlined),
                                    Text("Google"),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(width: 12),

                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    Icon(Icons.apple),
                                    SizedBox(width: 10),
                                    Text("Apple"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Knowledge is the only bridge to an informed future",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 50),
                  Divider(
                    thickness: 1,
                    color: const Color.fromARGB(255, 226, 223, 223),
                    height: 1,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "@ 2024 NovaNews Editorial Group. all rights reserved.",
                    style: TextStyle(fontSize: 12),
                  ),
               SizedBox(height: 5),
                  Text(
                    " Global Support      Press inuiries      System Status",
                    style: TextStyle(fontSize: 12))],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
    ),
  );

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required Widget prefixIcon,
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
        prefixIcon: prefixIcon,
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
