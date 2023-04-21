import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Notes_App/constants/Theme.dart';
import 'package:Notes_App/models/sample_container.dart';
import 'package:Notes_App/models/sample_text_field.dart';
import 'package:Notes_App/utils/dialogs/error_dialog.dart';
import 'package:provider/provider.dart';
import '../constants/langs.dart';
import '../constants/sizes.dart';
import '../models/sample_button.dart';
import '../services/auth/auth_exceptions.dart';
import '../services/bloc/auth_bloc/auth_bloc.dart';
import '../services/bloc/auth_bloc/auth_event.dart';
import '../services/bloc/auth_bloc/auth_state.dart';
import '../services/bloc/screening_bloc/preferene_bloc.dart';

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
    final bloc = Provider.of<PreferenceProvider>(context).bloc;
    var myList = [];
    bloc.mypref.listen((event) {
      myList = event;
    });
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthStateLoggedOut) {
            if (state.exception is UserNotFoundAuthException) {
              await showErrorDialog(
                  context: context,
                  color: Themes[myList[0]]['button'],
                  title: langs[myList[1]]![40],
                  bcontent: langs[myList[1]]![43],
                  fcontent: langs[myList[1]]![41],
                  lcontent: langs[myList[1]]![42]);
            } else if (state.exception is WrongPasswordAuthException) {
              await showErrorDialog(
                  context: context,
                  color: Themes[myList[0]]['button'],
                  title: langs[myList[1]]![40],
                  bcontent: langs[myList[1]]![44],
                  fcontent: langs[myList[1]]![41],
                  lcontent: langs[myList[1]]![42]);
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(
                  context: context,
                  color: Themes[myList[0]]['button'],
                  title: langs[myList[1]]![40],
                  bcontent: langs[myList[1]]![45],
                  fcontent: langs[myList[1]]![41],
                  lcontent: langs[myList[1]]![42]);
            }
          }
        },
        child: StreamBuilder(
            stream: bloc.mypref,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final choosenTheme = (snapshot.data as List)[0] ?? '';
                final String choosenLang = (snapshot.data as List)[1] ?? '';
                print(choosenLang);
                return Scaffold(
                  body: Container(
                    color: Themes[choosenTheme]["primary"],
                    child: CustomScrollView(slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 30, 30, 20),
                              width: Sizes.getTotalWidth(context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 100),
                                  Text(langs[choosenLang]![0],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 40,
                                          letterSpacing: 1.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "TailwindRegular")),
                                  SizedBox(height: 10),
                                  Text(langs[choosenLang]![1],
                                      style: TextStyle(
                                          letterSpacing: 0.6,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "TailwindSRegular"))
                                ],
                              ),
                            ),
                            Expanded(
                                child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 30, 30, 20),
                              width: Sizes.getTotalWidth(context),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50)),
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
                                    onTap: () {
                                      context.read<AuthBloc>().add(
                                            const AuthEventLoginWithGoogle(),
                                          );
                                    },
                                    child: SampleContainer(
                                        mychild: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 25),
                                      child: Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.google,
                                            color: Themes[choosenTheme]
                                                ["button"],
                                          ),
                                          SizedBox(width: 15),
                                          Text(langs[choosenLang]![2],
                                              style: TextStyle(
                                                  letterSpacing: 0.7,
                                                  fontSize: 16,
                                                  //fontWeight: FontWeight.w700,
                                                  fontFamily:
                                                      "TailwindSRegular")),
                                          Expanded(child: Container()),
                                          const Icon(Icons.arrow_forward)
                                        ],
                                      ),
                                    )),
                                  ),
                                  SizedBox(height: 30),
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Row(children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Container(
                                              height: 1.0,
                                              //   width:Sizes.getTotalWidth(context)*0.2,
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                            ),
                                          ),
                                        ),
                                        Text(langs[choosenLang]![3],
                                            style: TextStyle(
                                                letterSpacing: 0.6,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "NeofontRoman")),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Container(
                                              height: 1.0,
                                              // width:Sizes.getTotalWidth(context)*0.2,
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                            ),
                                          ),
                                        ),
                                      ])),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SampleTextField(
                                    text: langs[choosenLang]![4],
                                    controller: _email,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    keyboardType: true,
                                  ),
                                  SampleTextField(
                                    text: langs[choosenLang]![5],
                                    controller: _password,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    obscureText: true,
                                  ),
                                  SizedBox(height: 30),
                                  SampleButton(
                                    mycolor: (choosenTheme == 'assets/images/Themes/fifth.png')? Themes[choosenTheme]["secondary"] :Themes[choosenTheme]["button"],
                                    mychild: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(langs[choosenLang]![0],
                                            style: TextStyle(
                                              //fontSize: 40,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "TailwindRegular",
                                              color:
                                                  Colors.black.withOpacity(0.9),
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
                                      child: SmallButton(
                                          mychild: Text(
                                            langs[choosenLang]![6],
                                            style: TextStyle(
                                                color: Themes[choosenTheme]
                                                    ["button"]),
                                          ),
                                          callback: () {
                                            context.read<AuthBloc>().add(
                                                const AuthEventForgotPassword());
                                          })),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: FractionalOffset.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(langs[choosenLang]![7],
                                              style: TextStyle(
                                                  letterSpacing: 0.6,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "NeofontRoman")),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SmallButton(
                                              background: Themes[choosenTheme]
                                                      ["button"]
                                                  .withOpacity(0.15),
                                              mychild: Text(
                                                langs[choosenLang]![8],
                                                style: TextStyle(
                                                    color: Themes[choosenTheme]
                                                        ["button"]),
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
                );
              } else {
                return Scaffold(
                  body: Center(
                      child: SpinKitFadingFour(
                    color: Colors.grey,
                  )),
                );
              }
            }));
  }
}
