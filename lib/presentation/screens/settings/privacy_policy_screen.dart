import 'package:flutter/material.dart';
import '../../widgets/app_bottom_nav.dart';
import 'settings_scaffold.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsScaffold(
      bottomNavigationBar: AppBottomNav(currentIndex: 3),
      title: 'Privacy Policy',
      subtitle: 'Last updated June 2026',
      children: [
        LegalSection(
          heading: '1. Information We Collect',
          body:
              'We collect the information you provide when you create an account, '
              'such as your name and email address, along with your reading '
              'preferences and the articles you save. This helps us personalize '
              'your news experience.',
        ),
        LegalSection(
          heading: '2. How We Use Your Data',
          body:
              'Your data is used to curate a personalized feed, improve our '
              'recommendation engine, and keep your account secure. We never sell '
              'your personal information to third parties.',
        ),
        LegalSection(
          heading: '3. Data Storage & Security',
          body:
              'All data is stored securely using industry-standard encryption. '
              'Authentication and account data are managed through our trusted '
              'backend provider with row-level security enabled.',
        ),
        LegalSection(
          heading: '4. Your Rights',
          body:
              'You can access, update, or delete your personal data at any time '
              'from the Settings screen. You may also request a full export or '
              'permanent deletion of your account.',
        ),
        LegalSection(
          heading: '5. Contact Us',
          body:
              'If you have any questions about this Privacy Policy, reach out to '
              'us at privacy@novanews.pro.',
        ),
      ],
    );
  }
}
