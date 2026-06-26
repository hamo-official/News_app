import 'package:go_router/go_router.dart';
import '../../data/models/news_model.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/news_detail/news_detail_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/profile/change_password_screen.dart';
import '../../presentation/screens/profile/edit_profile_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/profile/setting_screenn.dart';
import '../../presentation/screens/settings/about_app_screen.dart';
import '../../presentation/screens/settings/contact_support_screen.dart';
import '../../presentation/screens/settings/help_center_screen.dart';
import '../../presentation/screens/settings/privacy_policy_screen.dart';
import '../../presentation/screens/settings/reading_preferences_screen.dart';
import '../../presentation/screens/settings/security_screen.dart';
import '../../presentation/screens/settings/terms_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String newsDetail = '/news-detail';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String changePassword = '/change-password';
  static const String readingPreferences = '/settings/reading-preferences';
  static const String security = '/settings/security';
  static const String helpCenter = '/settings/help-center';
  static const String contactSupport = '/settings/contact-support';
  static const String privacyPolicy = '/settings/privacy-policy';
  static const String terms = '/settings/terms';
  static const String about = '/settings/about';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: newsDetail,
        builder: (context, state) {
          final news = state.extra as NewsModel;
          return NewsDetailScreen(news: news);
        },
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: readingPreferences,
        builder: (context, state) => const ReadingPreferencesScreen(),
      ),
      GoRoute(
        path: security,
        builder: (context, state) => const SecurityScreen(),
      ),
      GoRoute(
        path: helpCenter,
        builder: (context, state) => const HelpCenterScreen(),
      ),
      GoRoute(
        path: contactSupport,
        builder: (context, state) => const ContactSupportScreen(),
      ),
      GoRoute(
        path: privacyPolicy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: terms,
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: about,
        builder: (context, state) => const AboutAppScreen(),
      ),
    ],
  );
}
