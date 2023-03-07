import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Notes_App/screens/register_view.dart';
import 'package:provider/provider.dart';
import '../constants/Theme.dart';
import '../constants/langs.dart';
import '../constants/sizes.dart';
import '../models/sample_button.dart';
import '../services/auth/auth_service.dart';
import '../services/bloc/auth_bloc/auth_bloc.dart';
import '../services/bloc/auth_bloc/auth_event.dart';
import '../services/crud/db_service.dart';
import '../services/bloc/screening_bloc/preferene_bloc.dart';

class VerifyEmailView extends StatefulWidget {
  VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  late final DBService _notesService;

  @override
  void initState() {
    _notesService = DBService();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> setting(String fname, String lname) async {
    String currentId = await AuthService.firebase().currentUser!.id;

    await _notesService.createUser(
        firstName: fname, lastName: lname, id: currentId);
    //  print("from verify $currentId");
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PreferenceProvider>(context).bloc;

    return FutureBuilder(
        future: setting(RegisterViewState.fnamee, RegisterViewState.lnamee),
        builder: (context, snapshot) {
          return StreamBuilder(
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
                                        color:
                                            Color(0xFF2C2C2C).withOpacity(0.9),
                                      ),
                                      onPressed: () {
                                        context.read<AuthBloc>().add(
                                              AuthEventLogOut(),
                                            );
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 30, 30, 20),
                                    width: Sizes.getTotalWidth(context),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        Text(
                                          " ${langs[choosenLang]![17]} , ${RegisterViewState.fnamee}!",
                                          style: TextStyle(
                                              fontSize: 35,
                                              letterSpacing: 1.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "TailwindRegular"),
                                        ),
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
                                              SizedBox(
                                                height: 140,
                                              ),
                                              Icon(
                                                Icons.email,
                                                color: Themes[choosenTheme]
                                                    ["button"],
                                                size: 100,
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                  langs[choosenLang]![18],
                                                  style: TextStyle(
                                                      // letterSpacing: 1,
                                                      fontSize: 27,
                                                      letterSpacing: 0.6,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          "TailwindSRegular"),
                                                ),
                                              ),
                                              Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 5),
                                                  child: Text(
                                                      langs[choosenLang]![19],
                                                      style: TextStyle(
                                                          height: 1.8,
                                                          color:
                                                              Color(0xFFa0acb8),
                                                          fontSize: 13,
                                                          fontFamily:
                                                              "PoppinsRegular"))),
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 50,
                                                                  bottom: 5),
                                                          child: Text(
                                                            langs[choosenLang]![
                                                                20],
                                                            style: TextStyle(
                                                                height: 1.8,
                                                                color: Color(
                                                                    0xFFa0acb8),
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    "PoppinsRegular"),
                                                          )),
                                                      LeveledButton(
                                                          text: langs[
                                                              choosenLang]![21],
                                                          callback: () {
                                                            context
                                                                .read<
                                                                    AuthBloc>()
                                                                .add(
                                                                  const AuthEventSendEmailVerification(),
                                                                );
                                                          }),
                                                      SizedBox(
                                                        height: 80,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )))
                                ],
                              ),
                            )
                          ])));
                } else {
                  return Scaffold(
                    body: Center(
                        child: SpinKitFadingFour(
                      color: Colors.grey,
                    )),
                  );
                }
              });
        });
  }
}
