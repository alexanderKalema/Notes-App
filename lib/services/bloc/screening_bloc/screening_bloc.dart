import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:Notes_App/services/auth/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'screening_event.dart';
part 'screening_state.dart';

class ScreeningBloc extends Bloc<ScreeningEvent, ScreeningState> {
  AuthUser? user;
  late SharedPreferences prefs;
  late bool finishedOnBoarding;

  ScreeningBloc({this.user}) : super(const ScreeningState.unauthenticated()) {
    on<CheckFirstRunEvent>((event, emit) async {
      prefs = await SharedPreferences.getInstance();
      finishedOnBoarding = prefs.getBool('finishedOnBoarding') ?? false;
      if (!finishedOnBoarding) {
        emit(const ScreeningState.onboarding());
      } else {
        emit(const ScreeningState.unauthenticated());
      }
    });
    on<FinishedOnBoardingEvent>((event, emit) async {
      await prefs.setBool('finishedOnBoarding', true);
      emit(const ScreeningState.unauthenticated());
    });
  }
}
