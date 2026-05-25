import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/user_profile_model.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepo;

  AuthCubit(this._authRepo) : super(AuthInitial());

  Future<void> checkAuth() async {
    if (_authRepo.isLoggedIn) {
      try {
        final profile = await _authRepo.getProfile();
        emit(AuthAuthenticated(profile: profile));
      } catch (_) {
        emit(AuthAuthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final user =
          await _authRepo.signIn(email: email, password: password);
      if (user == null) {
        emit(AuthError('Sign in failed. Please try again.'));
        return;
      }
      await _authRepo.ensureProfile(user);
      UserProfileModel? profile;
      try {
        profile = await _authRepo.getProfile();
      } catch (_) {}
      emit(AuthAuthenticated(profile: profile));
    } catch (e) {
      emit(AuthError(_parseError(e.toString())));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    emit(AuthLoading());
    try {
      final result = await _authRepo.signUp(
          email: email, password: password, fullName: fullName);
      if (result.needsConfirmation) {
        emit(AuthEmailConfirmationRequired());
      } else {
        UserProfileModel? profile;
        try {
          profile = await _authRepo.getProfile();
        } catch (_) {}
        emit(AuthAuthenticated(profile: profile));
      }
    } catch (e) {
      emit(AuthError(_parseError(e.toString())));
    }
  }

  Future<void> signOut() async {
    await _authRepo.signOut();
    emit(AuthUnauthenticated());
  }

  Future<void> updateProfile({required String fullName}) async {
    emit(AuthLoading());
    try {
      final profile = await _authRepo.updateProfile(fullName: fullName);
      emit(AuthAuthenticated(profile: profile));
    } catch (e) {
      emit(AuthError(_parseError(e.toString())));
    }
  }

  String _parseError(String error) {
    if (error.contains('Invalid login credentials') ||
        error.contains('invalid_credentials')) {
      return 'Invalid email or password.';
    }
    if (error.contains('Email not confirmed')) {
      return 'Please confirm your email before signing in.';
    }
    if (error.contains('User already registered') ||
        error.contains('already registered')) {
      return 'An account with this email already exists.';
    }
    if (error.contains('network') || error.contains('SocketException')) {
      return 'Network error. Check your internet connection.';
    }
    // Surface the raw message so it\'s easier to debug unknown errors
    return error.replaceAll('Exception: ', '').replaceAll('AuthException: ', '');
  }
}
