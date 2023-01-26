import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nibret_kifel/screens/create_update_note_view.dart';
import 'package:nibret_kifel/screens/login_view.dart';
import 'package:nibret_kifel/screens/notes_list_view.dart';
import 'package:nibret_kifel/screens/notes_view.dart';
import 'package:nibret_kifel/screens/regisrer_view.dart';
//import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibret_kifel/screens/setting_view.dart';
import 'package:nibret_kifel/screens/verify_email_view.dart';
import 'package:nibret_kifel/screens/forgot_password_view.dart';
import 'package:nibret_kifel/services/auth/auth_service.dart';
import 'package:nibret_kifel/services/auth/bloc/auth_bloc.dart';
import 'package:nibret_kifel/services/auth/bloc/auth_event.dart';
import 'package:nibret_kifel/services/auth/bloc/auth_state.dart';
import 'package:nibret_kifel/services/auth/firebase_auth_provider.dart';
import 'package:nibret_kifel/utils/dialogs/loading_dialog.dart';
import 'package:path/path.dart';

import 'constants/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderApp());
}

class ProviderApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    /// Define your Provider here, above MaterialApp
    return
      MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(AuthService.firebase()),
            ),
            BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(AuthService.googleLogin()),
            ),
            BlocProvider<ListCubit>(
              create: (context) => ListCubit(),
            )
          ],
          child:  Builder(
            builder: (context) {

              return MaterialApp(

                  home:  HomePage(),
                routes: {
                  createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
                  settingRoute : (context) => const SettingView(),
                },
              );
            }
          ));

  }
}










class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment...',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return  NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return  VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return  LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: Center(
                child: SpinKitFadingFour(
                  color: Color(0xFFffcb47),
                )),
          );
        }


      },
    );
  }
}
