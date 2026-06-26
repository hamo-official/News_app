import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../widgets/app_bottom_nav.dart';

class _Faq {
  final String q;
  final String a;
  const _Faq(this.q, this.a);
}

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  int? _expanded;

  static const _faqs = [
    _Faq(
      'How do I upgrade to a Premium subscription?',
      'Go to your Profile settings and select \'Manage Subscription\'. From '
          'there you can choose between Monthly and Annual Premium plans, which '
          'include ad-free reading, exclusive newsletters and early podcast access.',
    ),
    _Faq(
      'Can I share my NovaNews account with family?',
      'Our Family Plan allows up to 5 individual profiles on a single account. '
          'Each member gets their own saved articles and personalized feed.',
    ),
    _Faq(
      'How do I turn off push notifications?',
      'Navigate to Settings > Security and authentication, or your device '
          'settings, to fine-tune alerts for specific topics and breaking news.',
    ),
    _Faq(
      'What is the "NovaNews Ethics" pledge?',
      'It is our commitment to transparent, non-partisan reporting. We disclose '
          'funding sources and cite all data used in investigative reports.',
    ),
    _Faq(
      'Is there a student discount available?',
      'Yes! Students with a valid .edu email get 50% off the Annual Premium '
          'plan. Verify your status through the Student Discount portal.',
    ),
  ];

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
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
            _topBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Help Center',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              color: AppColors.onSurface,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Everything you need to know about NovaNews. Find '
                            'answers, manage your account, and more.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              height: 1.5,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Search
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'How can we help?',
                        hintStyle: TextStyle(
                            color: AppColors.outline, fontSize: 15.sp),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: AppColors.outline),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.r),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.r),
                          borderSide:
                              const BorderSide(color: AppColors.navy, width: 1.5),
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    Text('Categories',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface)),
                    SizedBox(height: 14.h),
                    _categoryCard(
                      icon: Icons.memory_rounded,
                      iconBg: AppColors.primaryFixed,
                      iconFg: AppColors.navy,
                      title: 'Technical Support',
                      subtitle:
                          'Browser issues, app crashes, and performance help.',
                    ),
                    SizedBox(height: 12.h),
                    _categoryCard(
                      icon: Icons.person_rounded,
                      iconBg: AppColors.secondaryFixed,
                      iconFg: AppColors.navy,
                      title: 'Account Issues',
                      subtitle:
                          'Manage profile, change password, and security settings.',
                    ),
                    SizedBox(height: 12.h),
                    _categoryCard(
                      icon: Icons.payments_rounded,
                      iconBg: AppColors.tertiaryFixed,
                      iconFg: AppColors.tertiaryBrown,
                      title: 'Billing & Plans',
                      subtitle:
                          'Update payment methods and subscription management.',
                    ),
                    SizedBox(height: 12.h),
                    _categoryCard(
                      icon: Icons.policy_rounded,
                      iconBg: AppColors.surfaceVariant,
                      iconFg: AppColors.onSurfaceVariant,
                      title: 'Content Policy',
                      subtitle:
                          'Our standards, reporting errors, and feedback rules.',
                    ),
                    SizedBox(height: 28.h),
                    Text('Common Actions',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface)),
                    SizedBox(height: 14.h),
                    _actionRow(Icons.lock_reset_rounded, 'Reset Password',
                        () => context.push(AppRouter.changePassword)),
                    SizedBox(height: 10.h),
                    _actionRow(Icons.mail_outline_rounded,
                        'Contact Editorial Team', () => _snack('Opening email...')),
                    SizedBox(height: 10.h),
                    _actionRow(Icons.receipt_long_rounded, 'Download Receipts',
                        () => _snack('Preparing receipts...')),
                    SizedBox(height: 20.h),
                    // Can't find answer card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -16,
                            bottom: -16,
                            child: Transform.rotate(
                              angle: 0.2,
                              child: Icon(Icons.forum_rounded,
                                  size: 110.sp,
                                  color: Colors.white.withValues(alpha: 0.1)),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Can\'t find an answer?',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                'Our support team is available 24/7 to help you '
                                'with anything.',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  height: 1.5,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              ElevatedButton(
                                onPressed: () => _snack('Starting chat...'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.navy,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24.w, vertical: 12.h),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100.r)),
                                  elevation: 0,
                                ),
                                child: Text('Start Chat',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28.h),
                    Text('Popular Questions',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface)),
                    SizedBox(height: 8.h),
                    ...List.generate(_faqs.length, (i) => _faqItem(i)),
                  ],
                ),
              ),
            ),
          ],
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

  Widget _categoryCard({
    required IconData icon,
    required Color iconBg,
    required Color iconFg,
    required String title,
    required String subtitle,
  }) {
    return Container(
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
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, size: 24.sp, color: iconFg),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface)),
                SizedBox(height: 4.h),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.4,
                        color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionRow(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22.sp, color: AppColors.navy),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurface)),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 22.sp, color: AppColors.outline),
          ],
        ),
      ),
    );
  }

  Widget _faqItem(int i) {
    final faq = _faqs[i];
    final isOpen = _expanded == i;
    return Container(
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(color: AppColors.outlineVariant, width: 1)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = isOpen ? null : i),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 18.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      faq.q,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(Icons.expand_more_rounded,
                        size: 24.sp, color: AppColors.outline),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: EdgeInsets.only(bottom: 18.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  faq.a,
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.6,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            crossFadeState: isOpen
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}
