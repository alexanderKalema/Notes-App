part of 'screening_bloc.dart';

abstract class ScreeningEvent {}

class LoginWithEmailAndPasswordEvent extends ScreeningEvent {
  String email;
  String password;

  LoginWithEmailAndPasswordEvent({required this.email, required this.password});
}

class SignupWithEmailAndPasswordEvent extends ScreeningEvent {
  String emailAddress;
  String password;
  File? image;
  String? firstName;
  String? lastName;

  SignupWithEmailAndPasswordEvent(
      {required this.emailAddress,
      required this.password,
      this.image,
      this.firstName = 'Anonymous',
      this.lastName = 'User'});
}

class LogoutEvent extends ScreeningEvent {
  LogoutEvent();
}

class FinishedOnBoardingEvent extends ScreeningEvent {}

class CheckFirstRunEvent extends ScreeningEvent {}
