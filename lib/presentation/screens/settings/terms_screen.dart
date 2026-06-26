import 'package:flutter/material.dart';
import '../../widgets/app_bottom_nav.dart';
import 'settings_scaffold.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsScaffold(
      bottomNavigationBar: AppBottomNav(currentIndex: 3),
      title: 'Terms & Conditions',
      subtitle: 'Please read these terms carefully before using NovaNews.',
      children: [
        LegalSection(
          heading: '1. Acceptance of Terms',
          body:
              'By accessing or using NovaNews, you agree to be bound by these '
              'Terms & Conditions and our Privacy Policy. If you do not agree, '
              'please discontinue use of the app.',
        ),
        LegalSection(
          heading: '2. Use of the Service',
          body:
              'NovaNews grants you a personal, non-transferable license to access '
              'news content for individual, non-commercial use. You agree not to '
              'redistribute content without permission.',
        ),
        LegalSection(
          heading: '3. Accounts',
          body:
              'You are responsible for maintaining the confidentiality of your '
              'account credentials and for all activity that occurs under your '
              'account.',
        ),
        LegalSection(
          heading: '4. Content & Accuracy',
          body:
              'While we strive for accurate, timely reporting, NovaNews is not '
              'liable for errors or omissions. Content is provided on an '
              '"as is" basis.',
        ),
        LegalSection(
          heading: '5. Changes to Terms',
          body:
              'We may update these terms from time to time. Continued use of the '
              'app after changes constitutes acceptance of the revised terms.',
        ),
      ],
    );
  }
}
