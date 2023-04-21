import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Notes_App/services/auth/firebase_auth_provider.dart';
import 'package:provider/provider.dart';
import '../constants/Theme.dart';
import '../constants/langs.dart';
import '../models/animated_toggle.dart';
import '../models/drop_down.dart';
import '../models/sample_theme.dart';
import '../services/bloc/auth_bloc/auth_bloc.dart';
import '../services/bloc/auth_bloc/auth_event.dart';
import '../services/bloc/screening_bloc/preferene_bloc.dart';
import '../utils/dialogs/logout_dialog.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  late PreferenceBloc bloc;

  void didChangeDependencies() {
    bloc = Provider.of<PreferenceProvider>(context).bloc;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PreferenceProvider>(context).bloc;
    var myList = [];
    bloc.mypref.listen((event) {
      myList = event;
    });
    return StreamBuilder(
        stream: bloc.mypref,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final choosenTheme = (snapshot.data as List)[0] ?? '';
            final String choosenLang = (snapshot.data as List)[1] ?? '';

            return Scaffold(
              body: Container(
                  color: Colors.white,
                  child: CustomScrollView(slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(5, 36, 30, 20),
                            height: 180,
                            decoration: BoxDecoration(
                              color: Themes[choosenTheme]["primary"],
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(50),
                                  bottomLeft: Radius.circular(50)),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      size: 28,
                                    )),
                                Expanded(child: SizedBox()),
                                Text(
                                  langs[choosenLang]![25],
                                  style: TextStyle(
                                      letterSpacing: 1.3,
                                      fontSize: 34,
                                      fontFamily: "TailwindSRegular",
                                      fontWeight: FontWeight.w900),
                                ),
                                Expanded(child: SizedBox()),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 35, right: 35, bottom: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 35,
                                ),
                                Text(
                                  langs[choosenLang]![26],
                                  style: TextStyle(
                                      fontFamily: "PoppinsRegular",
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                DropdownItem(
                                    myColor:(choosenTheme == 'assets/images/Themes/fifth.png')? Themes[choosenTheme]["secondary"] :Themes[choosenTheme]["button"],
                                    myList: {
                                      langs[choosenLang]![27]: "Use default",
                                      langs[choosenLang]![28]:
                                          "Generate randomly"
                                    }),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Container(
                                    height: 1.0,
                                    //   width:Sizes.getTotalWidth(context)*0.2,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  langs[choosenLang]![29],
                                  style: TextStyle(
                                      fontFamily: "PoppinsRegular",
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                DropdownItem(
                                    myColor:(choosenTheme == 'assets/images/Themes/fifth.png')? Themes[choosenTheme]["secondary"] :Themes[choosenTheme]["button"],
                                    myList: {
                                      'English': 'English',
                                      "Tigrigna": 'Tigrigna',
                                      'Amharic': 'Amharic',
                                      'Afaan Oromo': 'Afaan Oromo'
                                    }),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Container(
                                    height: 1.0,
                                    //   width:Sizes.getTotalWidth(context)*0.2,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  langs[choosenLang]![30],
                                  style: TextStyle(
                                      fontFamily: "PoppinsRegular",
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SampleTheme(),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Container(
                                    height: 1.0,
                                    //   width:Sizes.getTotalWidth(context)*0.2,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  langs[choosenLang]![31],
                                  style: TextStyle(
                                      fontFamily: "PoppinsRegular",
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                AnimatedSwitch(
                                  myColor: Themes[choosenTheme]["button"],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Container(
                                    height: 1.0,
                                    //   width:Sizes.getTotalWidth(context)*0.2,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  langs[choosenLang]![34],
                                  style: TextStyle(
                                      fontFamily: "PoppinsRegular",
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                ElevatedButton(
                                  child: Text(langs[choosenLang]![34]),
                                  onPressed: () async {
                                    final shouldLogout = await showLogOutDialog(
                                      context,
                                      Themes[choosenTheme]["button"],
                                      langs[choosenLang]![34],
                                      langs[choosenLang]![39],
                                      langs[choosenLang]![34],
                                      langs[choosenLang]![33],
                                    );
                                    if (shouldLogout) {
                                      context.read<AuthBloc>().add(
                                            AuthEventLogOut(
                                                emailUser:
                                                    FirebaseAuthProvider()
                                                        .currentUser),
                                          );
                                      Navigator.pop(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Themes[choosenTheme]
                                          ["button"],
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(13))),
                                      elevation: 6,
                                      padding: EdgeInsets.all(14)),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Container(
                                    height: 1.0,
                                    //   width:Sizes.getTotalWidth(context)*0.2,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  langs[choosenLang]![35],
                                  style: TextStyle(
                                      fontFamily: "PoppinsRegular",
                                      fontSize: 20),
                                ),
                                Text(
                                  langs[choosenLang]![36],
                                  style: TextStyle(
                                      height: 1.8,
                                      color: Color(0xFFa0acb8),
                                      fontSize: 13,
                                      fontFamily: "PoppinsRegular"),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ])),
            );
          } else {
            return Scaffold(
              body: Center(
                  child: SpinKitFadingFour(
                color: Colors.grey,
              )),
            );
          }
        });
  }
}
