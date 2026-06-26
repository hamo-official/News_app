import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/ai_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_bottom_nav.dart';

class _Category {
  final String name;
  final IconData icon;
  const _Category(this.name, this.icon);
}

class ReadingPreferencesScreen extends StatefulWidget {
  const ReadingPreferencesScreen({super.key});

  @override
  State<ReadingPreferencesScreen> createState() =>
      _ReadingPreferencesScreenState();
}

class _ReadingPreferencesScreenState extends State<ReadingPreferencesScreen> {
  static const _categories = [
    _Category('Technology', Icons.memory_rounded),
    _Category('Business', Icons.payments_outlined),
    _Category('Sports', Icons.sports_basketball_rounded),
    _Category('Health', Icons.medical_services_outlined),
    _Category('Science', Icons.science_outlined),
    _Category('Politics', Icons.account_balance_outlined),
    _Category('Entertainment', Icons.movie_outlined),
    _Category('Education', Icons.school_outlined),
    _Category('AI & Innovation', Icons.auto_awesome_rounded),
    _Category('Startups', Icons.rocket_launch_outlined),
    _Category('World News', Icons.public_rounded),
    _Category('Local News', Icons.location_on_outlined),
  ];

  // Defaults mirror the Stitch design's pre-selected topics.
  final Set<String> _selected = {
    'Technology',
    'Business',
    'Science',
    'AI & Innovation',
    'Startups',
    'World News',
  };

  String? _aiProfile;
  bool _isGenerating = false;
  bool _isSaving = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('preferred_categories');
    final profile = prefs.getString('news_preference_profile');
    setState(() {
      if (saved != null && saved.isNotEmpty) {
        _selected
          ..clear()
          ..addAll(saved);
      }
      if (profile != null && profile.isNotEmpty) _aiProfile = profile;
      _loaded = true;
    });
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('preferred_categories', _selected.toList());
    if (_aiProfile != null) {
      await prefs.setString('news_preference_profile', _aiProfile!);
    }
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferences saved!'),
        backgroundColor: AppColors.navy,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _generateProfile() async {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one topic first.')),
      );
      return;
    }
    final topics = _selected.join(', ');

    // Graceful fallback when no API key is configured.
    if (AIConfig.geminiApiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      setState(() {
        _aiProfile =
            'You gravitate toward $topics. We\'ll prioritise high-impact, '
            'well-sourced stories in these areas and filter out the noise so '
            'your feed stays sharp and relevant.\n\n'
            '(Add a Gemini API key in lib/core/ai_config.dart to generate this '
            'with AI.)';
      });
      return;
    }

    setState(() => _isGenerating = true);
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: AIConfig.geminiApiKey,
      );
      final prompt =
          'A news reader follows these topics: $topics.\n'
          'Write a concise, insightful 2-3 sentence reader profile describing '
          'what they care about and how their news feed should be personalised. '
          'Write in second person ("You...").';
      final res = await model.generateContent([Content.text(prompt)]);
      setState(() {
        _aiProfile = res.text?.trim();
        _isGenerating = false;
      });
    } catch (e) {
      setState(() => _isGenerating = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not generate profile: $e'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSaving ? null : _save,
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        icon: _isSaving
            ? SizedBox(
                width: 18.w,
                height: 18.w,
                child: const CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.check_rounded),
        label: Text('Save Preferences',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 90.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PERSONALIZATION',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.0,
                        color: AppColors.navy,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Reading Preferences',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Select the topics you care about most. We\'ll curate your '
                      'personal news feed based on these choices for a truly '
                      'tailored experience.',
                      style: TextStyle(
                        fontSize: 15.sp,
                        height: 1.6,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Category bento grid
                    if (_loaded)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _categories.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14.w,
                          mainAxisSpacing: 14.h,
                          mainAxisExtent: 92.h,
                        ),
                        itemBuilder: (context, i) {
                          final cat = _categories[i];
                          final isSel = _selected.contains(cat.name);
                          return GestureDetector(
                            onTap: () => setState(() {
                              isSel
                                  ? _selected.remove(cat.name)
                                  : _selected.add(cat.name);
                            }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              decoration: BoxDecoration(
                                color: isSel
                                    ? AppColors.navy
                                    : AppColors.surfaceLow,
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                  color: isSel
                                      ? AppColors.navy
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: isSel
                                    ? [
                                        BoxShadow(
                                          color: AppColors.navy
                                              .withValues(alpha: 0.25),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    cat.icon,
                                    size: 28.sp,
                                    color: isSel
                                        ? Colors.white
                                        : AppColors.onSurfaceVariant,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    cat.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isSel
                                          ? Colors.white
                                          : AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    SizedBox(height: 24.h),
                    _buildAiCard(),
                    SizedBox(height: 24.h),
                    _buildCuratedCard(),
                    SizedBox(height: 16.h),
                    _buildWhyCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.navy.withValues(alpha: 0.2)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A0F172A),
              blurRadius: 24,
              offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded,
                  size: 20.sp, color: AppColors.navy),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'AI Preference Profile',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            'Let Gemini analyze your topics and craft a personalized reader profile.',
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.5,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (_aiProfile != null) ...[
            SizedBox(height: 14.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.secondaryFixed.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                _aiProfile!,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.6,
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ],
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isGenerating ? null : _generateProfile,
              icon: _isGenerating
                  ? SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: const CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.navy),
                    )
                  : Icon(Icons.auto_awesome_rounded,
                      size: 18.sp, color: AppColors.navy),
              label: Text(
                _isGenerating
                    ? 'Generating...'
                    : _aiProfile == null
                        ? 'Generate My Profile'
                        : 'Regenerate',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.navy),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCuratedCard() {
    return Container(
      width: double.infinity,
      height: 150.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF0B1C30), Color(0xFF00327D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Icon(Icons.public_rounded,
                size: 120.sp, color: Colors.white.withValues(alpha: 0.08)),
          ),
          Padding(
            padding: EdgeInsets.all(18.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Curated for You',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Our AI analyzes thousands of sources to bring you the signal '
                  'through the noise.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.5,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhyCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why customize?',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          SizedBox(height: 14.h),
          _whyItem(Icons.auto_awesome_rounded,
              'Prioritize high-impact stories in the industries you follow.'),
          SizedBox(height: 12.h),
          _whyItem(Icons.notifications_active_outlined,
              'Get breaking news alerts tailored specifically to your interests.'),
          SizedBox(height: 12.h),
          _whyItem(Icons.filter_list_rounded,
              'Reduce news fatigue by filtering out non-relevant content.'),
        ],
      ),
    );
  }

  Widget _whyItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.sp, color: AppColors.navy),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.5,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
