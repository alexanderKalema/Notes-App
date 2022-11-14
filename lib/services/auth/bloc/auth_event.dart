import 'package:flutter/foundation.dart' show immutable;
import 'package:nibret_kifel/services/auth/auth_user.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;


   const AuthEventLogIn(this.email, this.password);
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;

  const AuthEventRegister(this.email, this.password,);
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;

  const AuthEventForgotPassword({this.email});
}

class AuthEventLogOut extends AuthEvent {

  AuthUser? emailUser;
   AuthEventLogOut( {this. emailUser});
}

class AuthEventLoginWithGoogle extends AuthEvent{
  const AuthEventLoginWithGoogle();
}
