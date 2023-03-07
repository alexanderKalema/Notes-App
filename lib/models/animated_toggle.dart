import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Notes_App/services/bloc/screening_bloc/preferene_bloc.dart';
import 'package:provider/provider.dart';
import '../constants/langs.dart';

class AnimatedSwitch extends StatefulWidget {
  Color myColor;
  static var isEnabled = true;

  AnimatedSwitch({required this.myColor});

  @override
  AnimatedSwitchState createState() => AnimatedSwitchState();
}

class AnimatedSwitchState extends State<AnimatedSwitch> {
  final animationDuration = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    final PreferenceBloc bloc = Provider.of<PreferenceProvider>(context).bloc;
    handleChange() async {
      AnimatedSwitch.isEnabled = !AnimatedSwitch.isEnabled;
      var temp = (await bloc.loadSettingPreferences())[0];
      bloc.changeSettingPref([temp, "${AnimatedSwitch.isEnabled}"]);
      bloc.saveSettingPreferences();
    }

    return StreamBuilder(
        stream: bloc.mypref,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final String choosenLang = (snapshot.data as List)[1] ?? '';
            return Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFd9d9d9),
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  width: 80,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          handleChange();
                        });
                      },
                      child: AnimatedContainer(
                          duration: animationDuration,
                          child: Padding(
                              padding: EdgeInsets.all(2),
                              child: AnimatedAlign(
                                duration: animationDuration,
                                alignment: AnimatedSwitch.isEnabled
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: AnimatedContainer(
                                  height: 30,
                                  width: 40,
                                  duration: animationDuration,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: AnimatedSwitch.isEnabled
                                        ? widget.myColor
                                        : Colors.white,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade400,
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              )))),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                    (AnimatedSwitch.isEnabled)
                        ? langs[choosenLang]![32]
                        : langs[choosenLang]![33],
                    style: TextStyle(
                        color: Color(0xFFa0acb8),
                        fontSize: 13,
                        fontFamily: "PoppinsRegular")),
              ],
            );
          } else {
            return const Center(
                child: SpinKitFadingFour(
              color: Colors.black87,
            ));
          }
        });
  }
}
