part of 'screening_bloc.dart';

enum AuthState { firstRun, authenticated, unauthenticated }

class ScreeningState {
  final AuthState authState;
  final AuthUser? user;
  final String? message;

  const ScreeningState._(this.authState, {this.user, this.message});

  const ScreeningState.authenticated(AuthUser user)
      : this._(AuthState.authenticated, user: user);

  const ScreeningState.unauthenticated({String? message})
      : this._(AuthState.unauthenticated,
            message: message ?? 'Unauthenticated');

  const ScreeningState.onboarding() : this._(AuthState.firstRun);
}
