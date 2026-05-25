import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile_model.dart';

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  User? get currentUser => _client.auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.user;
  }

  Future<({User? user, bool needsConfirmation})> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: fullName != null ? {'full_name': fullName} : null,
    );

    if (response.user == null) {
      throw Exception('Sign up failed. Please try again.');
    }

    // If no session, try signing in immediately.
    // This works when email confirmation is disabled in Supabase.
    if (response.session == null) {
      try {
        final signIn = await _client.auth.signInWithPassword(
          email: email,
          password: password,
        );
        if (signIn.session != null) {
          await _upsertProfile(signIn.user!, email, fullName);
          return (user: signIn.user, needsConfirmation: false);
        }
      } catch (_) {}
      // sign-in failed → email confirmation is required
      return (user: response.user, needsConfirmation: true);
    }

    await _upsertProfile(response.user!, email, fullName);
    return (user: response.user, needsConfirmation: false);
  }

  Future<void> _upsertProfile(User user, String email, String? fullName) async {
    try {
      await _client.from('profiles').upsert({
        'id': user.id,
        'email': email,
        'full_name': fullName ?? '',
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {}
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> ensureProfile(User user) async {
    try {
      await _client.from('profiles').upsert({
        'id': user.id,
        'email': user.email ?? '',
        'full_name': user.userMetadata?['full_name'] as String? ?? '',
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {}
  }

  Future<UserProfileModel?> getProfile() async {
    final user = currentUser;
    if (user == null) return null;

    final response = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) return null;
    return UserProfileModel.fromJson(response);
  }

  Future<UserProfileModel> updateProfile({required String fullName}) async {
    final user = currentUser!;
    final data = {
      'id': user.id,
      'email': user.email ?? '',
      'full_name': fullName,
      'updated_at': DateTime.now().toIso8601String(),
    };
    await _client.from('profiles').upsert(data);
    return UserProfileModel.fromJson(data);
  }
}
