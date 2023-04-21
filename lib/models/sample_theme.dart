import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/bloc/screening_bloc/preferene_bloc.dart';

class SampleTheme extends StatefulWidget {
  Map themes = {
    "assets/images/Themes/first.png": true,
    "assets/images/Themes/second.png": false,
    "assets/images/Themes/third.png": false,
    "assets/images/Themes/fourth.png": false,
    "assets/images/Themes/fifth.png": false,
    "assets/images/Themes/sixth.png": false
  };

  SampleTheme({Key? key}) : super(key: key);

  @override
  State<SampleTheme> createState() => _SampleThemeState();
}

class _SampleThemeState extends State<SampleTheme> {
  late PreferenceBloc bloc;

  late SharedPreferences prefs;

  @override
  void initState() {
    initalize();
    super.initState();
  }

  initalize() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  @override
  void didChangeDependencies() {
    bloc = Provider.of<PreferenceProvider>(context).bloc;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: initalize(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
                width: size.width,
                child: Container(
                    child: Wrap(children: [
                  ...(widget.themes.keys).map((keys) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          bloc.changeMyPref(
                              [keys, prefs.getStringList('myprefs')![1]]);
                          bloc.savePreferences();
                        });
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                        decoration: BoxDecoration(
                          color: (keys == prefs.getStringList('myprefs')![0])
                              ? Colors.blueAccent
                              : Colors.transparent,
                          border: Border.all(
                              width: 0.01,
                              color: (widget.themes[keys] == true)
                                  ? Colors.blueAccent
                                  : Colors.grey),
                          borderRadius:
                              BorderRadius.all(const Radius.circular(2.0)),
                        ),
                        child: Image(
                          image: AssetImage(keys),
                          height: 70,
                          width: 80,
                        ),
                      ),
                    );
                  })
                ])));
          } else {
            return Center(
                child: SpinKitFadingFour(
              color: Color(0xFFffcb47),
            ));
          }
        });
  }
}
