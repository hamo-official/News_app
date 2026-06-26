import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../widgets/app_bottom_nav.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _twoFactor = true;
  bool _biometric = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _twoFactor = prefs.getBool('security_2fa') ?? true;
      _biometric = prefs.getBool('security_biometric') ?? false;
    });
  }

  Future<void> _save(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

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
                    Text(
                      'Security',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: AppColors.navy,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Manage your account security, active sessions, and '
                      'authentication methods.',
                      style: TextStyle(
                        fontSize: 15.sp,
                        height: 1.5,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Authentication
                    _whiteCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Authentication',
                              style: _cardTitleStyle()),
                          SizedBox(height: 16.h),
                          _toggleRow(
                            icon: Icons.vibration_rounded,
                            title: 'Two-Factor Authentication',
                            subtitle:
                                'Add an extra layer of security to your account.',
                            value: _twoFactor,
                            onChanged: (v) {
                              setState(() => _twoFactor = v);
                              _save('security_2fa', v);
                            },
                          ),
                          SizedBox(height: 12.h),
                          _toggleRow(
                            icon: Icons.fingerprint_rounded,
                            title: 'Biometric Authentication',
                            subtitle:
                                'Use FaceID or Fingerprint for faster, secure access.',
                            value: _biometric,
                            onChanged: (v) {
                              setState(() => _biometric = v);
                              _save('security_biometric', v);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Active Sessions
                    _whiteCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text('Active Sessions',
                                    style: _cardTitleStyle()),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    _snack('Logged out all other devices'),
                                child: Text(
                                  'Log out all',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.navy,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          _sessionRow(
                            icon: Icons.desktop_windows_rounded,
                            device: 'MacBook Pro 16"',
                            badge: 'Current Device',
                            badgeBg: AppColors.secondaryFixed,
                            badgeFg: AppColors.onSecondaryFixed,
                            meta: 'Chrome • London, UK • Active Now',
                          ),
                          SizedBox(height: 12.h),
                          _sessionRow(
                            icon: Icons.smartphone_rounded,
                            device: 'iPhone 15 Pro',
                            badge: 'Trusted Device',
                            badgeBg: AppColors.surfaceHigh,
                            badgeFg: AppColors.onSurfaceVariant,
                            meta: 'NovaNews App • New York, USA • 2 hours ago',
                          ),
                          SizedBox(height: 12.h),
                          _sessionRow(
                            icon: Icons.tablet_mac_rounded,
                            device: 'iPad Air',
                            badge: 'Trusted Device',
                            badgeBg: AppColors.surfaceHigh,
                            badgeFg: AppColors.onSurfaceVariant,
                            meta: 'Safari • San Francisco, USA • May 12, 2024',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Security health card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.navy.withValues(alpha: 0.25),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.verified_user_rounded,
                                  size: 36.sp, color: Colors.white),
                              SizedBox(width: 14.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Secure',
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Last check: 5 mins ago',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Your account security is optimal. We recommend '
                            'changing your password every 90 days.',
                            style: TextStyle(
                              fontSize: 14.sp,
                              height: 1.5,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          SizedBox(height: 18.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () =>
                                  context.push(AppRouter.changePassword),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.navy,
                                padding:
                                    EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12.r)),
                                elevation: 0,
                              ),
                              child: Text('Change Password',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Security tips
                    _whiteCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lightbulb_outline_rounded,
                                  size: 22.sp, color: AppColors.navy),
                              SizedBox(width: 8.w),
                              Text('Security Tips', style: _cardTitleStyle()),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          _tip('Enable Two-Factor Authentication for all '
                              'sensitive operations.'),
                          SizedBox(height: 10.h),
                          _tip('Use a dedicated password manager to generate '
                              'complex, unique passwords.'),
                          SizedBox(height: 10.h),
                          _tip('Monitor your active sessions and log out of '
                              'devices you no longer use.'),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Help link (dashed)
                    DottedBorderBox(
                      child: Column(
                        children: [
                          Text(
                            'Need help with your security?',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          GestureDetector(
                            onTap: () => context.push(AppRouter.helpCenter),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Visit Support Center',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.navy,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Icon(Icons.open_in_new_rounded,
                                    size: 14.sp, color: AppColors.navy),
                              ],
                            ),
                          ),
                        ],
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

  TextStyle _cardTitleStyle() => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      );

  Widget _whiteCard({required Widget child}) => Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0A0F172A),
                blurRadius: 24,
                offset: Offset(0, 8)),
          ],
        ),
        child: child,
      );

  Widget _toggleRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 20.sp, color: AppColors.navy),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface)),
                SizedBox(height: 2.h),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 12.sp,
                        height: 1.4,
                        color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.navy,
          ),
        ],
      ),
    );
  }

  Widget _sessionRow({
    required IconData icon,
    required String device,
    required String badge,
    required Color badgeBg,
    required Color badgeFg,
    required String meta,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28.sp, color: AppColors.slate),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(device,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface)),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Text(
                        badge.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: badgeFg,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(meta,
                    style: TextStyle(
                        fontSize: 12.sp, color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          Icon(Icons.more_vert_rounded,
              size: 20.sp, color: AppColors.outline),
        ],
      ),
    );
  }

  Widget _tip(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_rounded, size: 16.sp, color: AppColors.navy),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(text,
              style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.5,
                  color: AppColors.onSurfaceVariant)),
        ),
      ],
    );
  }
}

/// Dashed-border container used for the "Need help?" callout.
class DottedBorderBox extends StatelessWidget {
  final Widget child;
  const DottedBorderBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRectPainter(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        child: Center(child: child),
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.outlineVariant
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const radius = 20.0;
    final rrect = RRect.fromRectAndRadius(
        Offset.zero & size, const Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    for (final metric in path.computeMetrics()) {
      double dist = 0;
      while (dist < metric.length) {
        canvas.drawPath(
          metric.extractPath(dist, dist + dashWidth),
          paint,
        );
        dist += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
