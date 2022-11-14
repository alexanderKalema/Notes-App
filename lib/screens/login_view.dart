import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nibret_kifel/models/sample_container.dart';
import 'package:nibret_kifel/models/sample_text_field.dart';
import 'package:nibret_kifel/utils/dialogs/error_dialog.dart';
//import 'package:path/path.dart';

import '../constants/sizes.dart';
import '../models/sample_button.dart';
import '../services/auth/auth_exceptions.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utils/dialogs/loading_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
      if (state is AuthStateLoggedOut) {
        if (state.exception is UserNotFoundAuthException) {
          await showErrorDialog(
              context,
              'Cannot find a user with the entered credentials!',
          );
        } else if (state.exception is WrongPasswordAuthException) {
          await showErrorDialog(context, 'Wrong credentials');
        } else if (state.exception is GenericAuthException) {
          await showErrorDialog(context, 'Authentication error');
        }
      }
    },






     child: Scaffold(
      body: Container(
        color: Color(0xFFffcb47),
        child: CustomScrollView(slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
                  width: Sizes.getTotalWidth(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 100),
                      Text("Sign in",
                          style: TextStyle(
                              fontSize: 40,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "TailwindRegular")),
                      SizedBox(height: 10),
                      Text("Welcome back, let's input your login information",
                          style: TextStyle(
                              letterSpacing: 0.6,
                              fontWeight: FontWeight.bold,
                              fontFamily: "TailwindSRegular"))
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
                  width: Sizes.getTotalWidth(context),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(50)),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(8, 12),
                          blurRadius: 14,
                          color: Color(0xFFebecf0),
                        )
                      ]),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: (){
                          context.read<AuthBloc>().add(
                            const AuthEventLoginWithGoogle(),
                          );
                        },
                        child: SampleContainer(
                            mychild: Container(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              FaIcon(FontAwesomeIcons.google , color: Color(0xFFffcb47),),
                              SizedBox(width: 15),
                              Text("Sign in with",
                                  style: TextStyle(
                                      letterSpacing: 0.7,
                                      fontSize: 16,
                                      //fontWeight: FontWeight.w700,
                                      fontFamily: "TailwindSRegular")),
                              Text(" Google",
                                  style: TextStyle(
                                      letterSpacing: 0.7,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "TailwindSRegular")),
                              Expanded(child: Container()),
                              const Icon(Icons.arrow_forward)
                            ],
                          ),
                        )),
                      ),
                      SizedBox(height: 30),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Row(children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Container(
                                  height: 1.0,
                                  //   width:Sizes.getTotalWidth(context)*0.2,
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ),
                            ),
                            const Text("Or Sign in with Email",
                                style: TextStyle(
                                    letterSpacing: 0.6,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "NeofontRoman")),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Container(
                                  height: 1.0,
                                  // width:Sizes.getTotalWidth(context)*0.2,
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ),
                            ),
                          ])),
                      const SizedBox(
                        height: 20,
                      ),
                      SampleTextField(
                        text: "Email",
                        controller: _email,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: true,
                      ),
                    SampleTextField(text: "Password",
                      controller: _password,
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: true,
                    ),
                      SizedBox(height: 30),
                      SampleButton(
                        mychild: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Sign In",
                                style: TextStyle(
                                  //fontSize: 40,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "TailwindRegular",
                                  color: Colors.black.withOpacity(0.9),
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.black.withOpacity(0.9),
                            ),
                          ],
                        ),
                        callback: () async {
                          final email = _email.text;
                          final password = _password.text;
                          context.read<AuthBloc>().add(
                                AuthEventLogIn(
                                  email,
                                  password,
                                ),
                             );

                        },
                      ),
                      Center(
                        child:SmallButton(
                            mychild: Text(
                              "Forgot password?",
                              style: TextStyle(color: Color(0xFFffcb47)),
                            ),
                            callback: () {


                              context.read<AuthBloc>().add(
                                const AuthEventForgotPassword());

                            })
                      ),


                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("New Here?",
                                  style: TextStyle(
                                      letterSpacing: 0.6,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "NeofontRoman")),
                              SizedBox(
                                width: 10,
                              ),
                              SmallButton(
                                background: Color(0xFFffcb47).withOpacity(0.15),
                                  mychild: Text(
                                    "Register",
                                    style: TextStyle(color: Color(0xFFffcb47)),
                                  ),
                                  callback: () {
                                    context.read<AuthBloc>().add(
                                          const AuthEventShouldRegister(),
                                        );
                                  })
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ),
          )
        ]),
      ),
    ));
  }
}
