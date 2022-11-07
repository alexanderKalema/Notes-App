import 'package:flutter/material.dart';
import 'package:nibret_kifel/screens/login_view.dart';
import 'package:nibret_kifel/screens/regisrer_view.dart';
//import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibret_kifel/screens/verify_email_view.dart';
import 'package:nibret_kifel/screens/forgot_password_view.dart';
import 'package:nibret_kifel/services/auth/auth_service.dart';
import 'package:nibret_kifel/services/auth/bloc/auth_bloc.dart';
import 'package:nibret_kifel/services/auth/bloc/auth_event.dart';
import 'package:nibret_kifel/services/auth/bloc/auth_state.dart';
import 'package:nibret_kifel/services/auth/firebase_auth_provider.dart';

void main() {
  runApp(MaterialApp(
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(AuthService.firebase()),
      child: const HomePage(),
    ),
    // routes: {
    //   createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    // },
  ),
  );
}
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // if (state.isLoading) {
        //   LoadingScreen().show(
        //     context: context,
        //     text: state.loadingText ?? 'Please wait a moment',
        //   );
        // } else {
        //   LoadingScreen().hide();
        // }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          //return const NotesView();
          return Text("hgjgh");
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          //return const ForgotPasswordView();
          return Text("");
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Text("hjhj");
        }


      },
    );
  }
}
