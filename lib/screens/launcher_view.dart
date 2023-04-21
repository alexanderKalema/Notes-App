import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Notes_App/screens/intro_slider_view.dart';
import 'package:Notes_App/screens/login_view.dart';
import 'package:Notes_App/screens/notes_view.dart';
import '../services/bloc/screening_bloc/screening_bloc.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({Key? key}) : super(key: key);

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ScreeningBloc>().add(CheckFirstRunEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: BlocBuilder<ScreeningBloc, ScreeningState>(
        builder: (context, state) {
          switch (state.authState) {
            case AuthState.firstRun:
              return IntroSliderView();
            case AuthState.authenticated:
              return NotesView();
            case AuthState.unauthenticated:
              return LoginView();
            default:
              return const Scaffold(
                body: Center(
                    child: SpinKitFadingFour(
                  color: Colors.grey,
                )),
              );
          }
        },
      ),
    );
  }
}
