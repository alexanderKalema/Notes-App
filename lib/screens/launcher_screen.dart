import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Notes_App/screens/register_view.dart';
import 'package:Notes_App/screens/verify_email_view.dart';
import 'package:provider/provider.dart';
import '../constants/Theme.dart';
import '../constants/langs.dart';
import '../services/bloc/auth_bloc/auth_bloc.dart';
import '../services/bloc/auth_bloc/auth_event.dart';
import '../services/bloc/auth_bloc/auth_state.dart';
import '../services/bloc/screening_bloc/preferene_bloc.dart';
import '../utils/dialogs/loading_dialog.dart';
import 'forgot_password_view.dart';
import 'login_view.dart';
import 'notes_view.dart';

class LauncherScreen extends StatelessWidget {
  const LauncherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PreferenceProvider>(context).bloc;
    var myList = [];
    bloc.mypref.listen((event) {
      myList = event;
    });
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
      if (state.isLoading) {
        LoadingScreen().show(
          context: context,
          text: langs[myList[1]]![53],
          color: Themes[myList[0]]['button'],
        );
      } else {
        LoadingScreen().hide();
      }
    }, builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return NotesView();
      } else if (state is AuthStateNeedsVerification) {
        return VerifyEmailView();
      } else if (state is AuthStateLoggedOut) {
        return LoginView();
      } else if (state is AuthStateForgotPassword) {
        return const ForgotPasswordView();
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else {
        return const Scaffold(
          body: Center(
              child: SpinKitFadingFour(
            color: Colors.grey,
          )),
        );
      }
    });
  }
}
