import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Notes_App/models/sample_text_field.dart';
import 'package:provider/provider.dart';
import '../constants/Theme.dart';
import '../constants/langs.dart';
import '../constants/sizes.dart';
import '../models/sample_button.dart';
import '../services/auth/auth_exceptions.dart';
import '../services/bloc/auth_bloc/auth_bloc.dart';
import '../services/bloc/auth_bloc/auth_event.dart';
import '../services/bloc/auth_bloc/auth_state.dart';
import '../services/bloc/screening_bloc/preferene_bloc.dart';
import '../utils/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _firstname;
  late final TextEditingController _lastname;
  static String fnamee = "";
  static String lnamee = "";

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _firstname = TextEditingController();
    _lastname = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _firstname.dispose();
    _lastname.dispose();
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
          if (state is AuthStateRegistering) {
            if (state.exception is WeakPasswordAuthException) {
              await showErrorDialog(
                context: context,
                color: Themes[myList[0]]['button'],
                title: langs[myList[1]]![40],
                bcontent: langs[myList[1]]![46],
                fcontent: langs[myList[1]]![41],
                lcontent: langs[myList[1]]![42],
              );
            } else if (state.exception is EmailAlreadyInUseAuthException) {
              await showErrorDialog(
                context: context,
                color: Themes[myList[0]]['button'],
                title: langs[myList[1]]![40],
                bcontent: langs[myList[1]]![47],
                fcontent: langs[myList[1]]![41],
                lcontent: langs[myList[1]]![42],
              );
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(
                context: context,
                color: Themes[myList[0]]['button'],
                title: langs[myList[1]]![40],
                bcontent: langs[myList[1]]![48],
                fcontent: langs[myList[1]]![41],
                lcontent: langs[myList[1]]![42],
              );
            } else if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(
                context: context,
                color: Themes[myList[0]]['button'],
                title: langs[myList[1]]![40],
                bcontent: langs[myList[1]]![49],
                fcontent: langs[myList[1]]![41],
                lcontent: langs[myList[1]]![42],
              );
            }
          }
        },
        child: StreamBuilder(
            stream: bloc.mypref,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final choosenTheme = (snapshot.data as List<String>)[0];
                final String choosenLang = (snapshot.data as List)[1] ?? '';

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
                                  Text(langs[choosenLang]![8],
                                      style: TextStyle(
                                          fontSize: 40,
                                          letterSpacing: 1.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "TailwindRegular")),
                                  SizedBox(height: 10),
                                  Text(langs[choosenLang]![9],
                                      style: TextStyle(
                                          letterSpacing: 0.6,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "TailwindSRegular"))
                                ],
                              ),
                            ),
                            Expanded(
                                child: Container(
                              padding: const EdgeInsets.fromLTRB(30, 5, 30, 20),
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
                                  SizedBox(height: 30),
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Column(
                                        children: [
                                          Row(children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0),
                                                child: Container(
                                                  height: 1.0,
                                                  //   width:Sizes.getTotalWidth(context)*0.2,
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                ),
                                              ),
                                            ),
                                            Text(langs[choosenLang]![10],
                                                style: TextStyle(
                                                    letterSpacing: 0.6,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily:
                                                        "NeofontRoman")),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0),
                                                child: Container(
                                                  height: 1.0,
                                                  // width:Sizes.getTotalWidth(context)*0.2,
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                ),
                                              ),
                                            ),
                                          ]),
                                          SizedBox(height: 24),
                                          SampleTextField(
                                            text: langs[choosenLang]![11],
                                            controller: _firstname,
                                          ),
                                          SampleTextField(
                                            text: langs[choosenLang]![12],
                                            controller: _lastname,
                                          ),
                                          SizedBox(height: 11),
                                          Row(children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0),
                                                child: Container(
                                                  height: 1.0,
                                                  //   width:Sizes.getTotalWidth(context)*0.2,
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ],
                                      )),
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
                                    obscureText: true,
                                    controller: _password,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                  ),
                                  const SizedBox(height: 30),
                                  SampleButton(
                                    mycolor: (choosenTheme == 'assets/images/Themes/fifth.png')? Themes[choosenTheme]["secondary"] :Themes[choosenTheme]["button"],
                                    mychild: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(langs[choosenLang]![8],
                                            style: TextStyle(
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
                                      fnamee = _firstname.text;
                                      lnamee = _lastname.text;
                                      context.read<AuthBloc>().add(
                                            AuthEventRegister(
                                              email,
                                              password,
                                            ),
                                          );
                                    },
                                  ),
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
                                          Text(langs[choosenLang]![13],
                                              style: TextStyle(
                                                  letterSpacing: 0.6,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "NeofontRoman")),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SmallButton(
                                            mychild: Text(
                                                langs[choosenLang]![0],
                                                style: TextStyle(
                                                    color: Themes[choosenTheme]
                                                        ["button"])),
                                            callback: () {
                                              context.read<AuthBloc>().add(
                                                    AuthEventLogOut(),
                                                  );
                                            },
                                          )
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
