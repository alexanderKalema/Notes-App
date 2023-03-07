import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Notes_App/screens/create_update_note_view.dart';
import 'package:Notes_App/screens/intro_slider_view.dart';
import 'package:Notes_App/screens/launcher_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Notes_App/screens/setting_view.dart';
import 'package:Notes_App/services/auth/auth_service.dart';
import 'package:Notes_App/services/bloc/auth_bloc/auth_bloc.dart';
import 'package:Notes_App/services/bloc/screening_bloc/screening_bloc.dart'
    as second;
import 'package:Notes_App/services/bloc/screening_bloc/preferene_bloc.dart';
import 'package:provider/provider.dart';
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
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(AuthService.firebase()),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(AuthService.googleLogin()),
          ),
          BlocProvider<second.ScreeningBloc>(
              create: (context) => second.ScreeningBloc()),
        ],
        child: Builder(builder: (context) {
          return ChangeNotifierProvider<PreferenceProvider>(
              create: (BuildContext context) => PreferenceProvider(),
              child: Consumer<PreferenceProvider>(
                  builder: (context, provider, child) {
                return MaterialApp(
                  home: HomePage(),
                  routes: {
                    createOrUpdateNoteRoute: (context) =>
                        const CreateUpdateNoteView(),
                    settingRoute: (context) => const SettingView(),
                  },
                );
              }));
        }));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<second.ScreeningBloc>().add(second.CheckFirstRunEvent());

    return BlocBuilder<second.ScreeningBloc, second.ScreeningState>(
      builder: (context, state) {
        if (state.authState == second.AuthState.firstRun) {
          return IntroSliderView();
        } else {
          return LauncherScreen();
        }
      },
    );
  }
}
