import '../../../data/models/user_profile_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserProfileModel? profile;
  AuthAuthenticated({this.profile});
}

class AuthUnauthenticated extends AuthState {}

class AuthEmailConfirmationRequired extends AuthState {}

class PasswordChangeSuccess extends AuthState {
  final UserProfileModel? profile;
  PasswordChangeSuccess({this.profile});
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
