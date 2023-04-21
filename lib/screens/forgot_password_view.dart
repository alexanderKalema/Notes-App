import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Notes_App/models/sample_text_field.dart';
import 'package:provider/provider.dart';
import '../constants/Theme.dart';
import '../constants/langs.dart';
import '../constants/sizes.dart';
import '../models/sample_button.dart';
import '../services/bloc/auth_bloc/auth_bloc.dart';
import '../services/bloc/auth_bloc/auth_event.dart';
import '../services/bloc/auth_bloc/auth_state.dart';
import '../services/bloc/screening_bloc/preferene_bloc.dart';
import '../utils/dialogs/error_dialog.dart';
import '../utils/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
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
          if (state is AuthStateForgotPassword) {
            if (state.hasSentEmail) {
              _controller.clear();
              await showPasswordResetSentDialog(
                context: context,
                color: Themes[myList[0]]['button'],
                title: langs[myList[1]]![51],
                bcontent: langs[myList[1]]![52],
                fcontent: langs[myList[1]]![41],
              );
            }
            if (state.exception != null) {
              await showErrorDialog(
                  context: context,
                  color: Themes[myList[0]]['button'],
                  title: langs[myList[1]]![40],
                  bcontent: langs[myList[1]]![50],
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

                return Scaffold(
                    body: Container(
                        color: Themes[choosenTheme]["primary"],
                        child: CustomScrollView(slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10, top: 20),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                      size: 45,
                                      color: Color(0xFF2C2C2C).withOpacity(0.9),
                                    ),
                                    onPressed: () {
                                      context.read<AuthBloc>().add(
                                            AuthEventLogOut(),
                                          );
                                    },
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 30, 30, 20),
                                  width: Sizes.getTotalWidth(context),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Center(
                                        child: Text(langs[choosenLang]![14],
                                            style: TextStyle(
                                                fontSize: 35,
                                                letterSpacing: 1.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "TailwindRegular")),
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(60),
                                              topRight: Radius.circular(60)),
                                          color: Colors.white,
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 30, 20, 20),
                                        width: Sizes.getTotalWidth(context),
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Image(
                                                image: AssetImage(
                                                    "assets/images/forgot_image.png"),
                                                height: 200,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Text(langs[choosenLang]![15],
                                                style: TextStyle(
                                                    letterSpacing: 0.6,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        "TailwindSRegular")),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            SampleTextField(
                                              text: langs[choosenLang]![4],
                                              controller: _controller,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              keyboardType: true,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  SampleButton(
                                                    mycolor:
                                                        Themes[choosenTheme]
                                                            ["button"],
                                                    mychild: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                            langs[choosenLang]![
                                                                16],
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  "TailwindRegular",
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.9),
                                                            )),
                                                      ],
                                                    ),
                                                    callback: () async {
                                                      final email =
                                                          _controller.text;
                                                      context.read<AuthBloc>().add(
                                                          AuthEventForgotPassword(
                                                              email: email));
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )))
                              ],
                            ),
                          )
                        ])));
              } else {
                return Center(
                    child: SpinKitFadingFour(
                  color: Colors.grey,
                ));
              }
            }));
  }
}
