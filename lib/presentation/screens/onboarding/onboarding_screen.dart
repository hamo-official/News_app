import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const String seenKey = 'seen_onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(OnboardingScreen.seenKey, true);
    if (!mounted) return;
    context.go(AppRouter.login);
  }

  void _next() {
    if (_page == 2) {
      _finish();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _page = i),
        children: [
          _BreakingNewsPage(onNext: _next, onSkip: _finish),
          _TrustedStoriesPage(
              page: _page, onNext: _next, onSkip: _finish),
          _PersonalizedFeedPage(page: _page, onNext: _next),
        ],
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int page;
  final Color activeColor;
  final Color inactiveColor;

  const _DotIndicator({
    required this.page,
    this.activeColor = AppColors.primary,
    this.inactiveColor = const Color(0xFFD9E2F2),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final isActive = i == page;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: isActive ? 22.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}

class _BreakingNewsPage extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const _BreakingNewsPage({required this.onNext, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0A1628),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF0E2A4A), Color(0xFF0A1628)],
                    ),
                  ),
                  child: Center(
                    child: Icon(Icons.newspaper_rounded,
                        size: 96.sp, color: Colors.white24),
                  ),
                ),
                Positioned(
                  top: 56.h,
                  left: 20.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'LIVE NOW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.fromLTRB(28.w, 28.h, 28.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stay Updated with\nBreaking News',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Experience journalism redefined. Personalized, '
                    'real-time insights for the modern professional.',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 14.sp,
                      height: 1.4,
                    ),
                  ),
                  const Spacer(),
                  _DotIndicator(
                    page: 0,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white24,
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        elevation: 0,
                      ),
                      onPressed: onNext,
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Center(
                    child: TextButton(
                      onPressed: onSkip,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14.sp,
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
    );
  }
}

class _TrustedStoriesPage extends StatelessWidget {
  final int page;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const _TrustedStoriesPage({
    required this.page,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(28.w, 16.h, 28.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'NovaNews',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextButton(
                  onPressed: onSkip,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.neutral,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Center(
                  child: Icon(Icons.menu_book_rounded,
                      size: 80.sp, color: AppColors.primary.withValues(alpha: 0.3)),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Curation Excellence',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Read Trusted Stories Daily with Precision.',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'In an era of noise, we curate signals. Experience '
              'journalism redefined through expert sourcing, rigorous '
              'fact-checking, and editorial integrity that respects your '
              'intelligence.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 20.h),
            _DotIndicator(page: page),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  elevation: 0,
                ),
                onPressed: onNext,
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonalizedFeedPage extends StatelessWidget {
  final int page;
  final VoidCallback onNext;

  const _PersonalizedFeedPage({required this.page, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(28.w, 16.h, 28.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'NovaNews',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, size: 14.sp, color: AppColors.tertiary),
                      SizedBox(width: 4.w),
                      Text(
                        'REAL-TIME +12 Updates',
                        style: TextStyle(
                          color: AppColors.tertiary,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.neutral,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(Icons.auto_awesome,
                                color: Colors.white, size: 20.sp),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.divider,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  width: 120.w,
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.divider,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'THE FINAL STEP',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Personalized News Feed for You.',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Experience a revolutionary way to digest information. '
                      'NovaNews utilizes advanced neural patterns to curate '
                      'high-signal intelligence specifically for your '
                      'professional trajectory.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13.sp,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _featureRow(
                      icon: Icons.auto_awesome,
                      title: 'Curated by AI',
                      subtitle: 'Sophisticated filtering for high-value insights',
                    ),
                    SizedBox(height: 12.h),
                    _featureRow(
                      icon: Icons.flash_on,
                      title: 'Ultra-Fast',
                      subtitle: 'Intelligence delivered at the speed of thought',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            _DotIndicator(page: page),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  elevation: 0,
                ),
                onPressed: onNext,
                child: Text(
                  'Get Started  →',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Center(
              child: Text(
                'Join the global community of leaders.\n'
                'By continuing, you agree to our Terms & Privacy.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
