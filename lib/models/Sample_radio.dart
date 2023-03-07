import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/bloc/screening_bloc/preferene_bloc.dart';

class SampleRadio extends StatefulWidget {
  bool? isLanguage;

  SampleRadio({this.isLanguage});

  @override
  createState() {
    return new SampleRadioState();
  }
}

class SampleRadioState extends State<SampleRadio> {
  late PreferenceBloc bloc;
  late SharedPreferences prefs;

  List<RadioModel> sampleData = <RadioModel>[];

  // final userId = AuthService.firebase().currentUser!.id;

  @override
  void didChangeDependencies() {
    bloc = Provider.of<PreferenceProvider>(context).bloc;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    if (this.widget.isLanguage == null) {
      sampleData.add(RadioModel(true, "assets/images/Themes/first.png"));
      sampleData.add(RadioModel(false, "assets/images/Themes/second.png"));
      sampleData.add(RadioModel(false, "assets/images/Themes/third.png"));
      sampleData.add(RadioModel(false, "assets/images/Themes/fourth.png"));
      sampleData.add(RadioModel(false, "assets/images/Themes/fifth.png"));
      sampleData.add(RadioModel(false, "assets/images/Themes/sixth.png"));
    } else {
      sampleData.add(RadioModel(false, 'Affan Oromo'));
      sampleData.add(RadioModel(false, 'Tigrigna'));
      sampleData.add(RadioModel(false, 'Amharic'));
      sampleData.add(RadioModel(true, 'English'));
    }
    initalize();

    super.initState();
  }

  initalize() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getStringList('myprefs')?.isEmpty ?? true) {
      bloc.changeMyPref(["assets/images/Themes/first.png", "English"]);
      bloc.savePreferences();
      bloc.changeSettingPref(["Use default", "true"]);
      bloc.saveSettingPreferences();
//      print("no problemo");

      //   await prefs.setStringList(
      //       'myprefs', ["assets/images/Themes/first.png", "English"]);
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Text(
                  (this.widget.isLanguage ?? false)
                      ? "Choose Language"
                      : "Select Theme",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "TailwindRegular")),
              SizedBox(
                height: 50,
              ),
              SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(children: <Widget>[
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: sampleData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          splashColor: Colors.blueAccent,
                          onTap: () {
                            setState(() {
                              sampleData.forEach((element) {
                                element.isSelected = false;
                                sampleData[index].isSelected = true;
                              });

                              if (sampleData[index].textOrImage.contains("/")) {
                                bloc.changeMyPref([
                                  sampleData[index].textOrImage,
                                  prefs.getStringList('myprefs')![1]
                                ]);
                                bloc.savePreferences();

                                // prefs.setStringList('myprefs', [
                                //   sampleData[index].textOrImage,
                                //   prefs.getStringList('myprefs')![1]
                                // ]);
                                //

                                // print(
                                //     'from first if ${prefs.getStringList('myprefs')}');
                              } else {
                                bloc.changeMyPref([
                                  prefs.getStringList('myprefs')![0],
                                  sampleData[index].textOrImage
                                ]);
                                bloc.savePreferences();

                                // prefs.setStringList('myprefs', [
                                //   prefs.getStringList('myprefs')![0],
                                //   sampleData[index].textOrImage
                                // ]);
                              }
                            });
                          },
                          child: new RadioItem(
                              sampleData[index], this.widget.isLanguage),
                        );
                      },
                    )
                  ])),
            ]),
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  bool? isLanguage;

  RadioItem(this._item, this.isLanguage);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            padding: (isLanguage ?? false)
                ? EdgeInsets.all(10)
                : EdgeInsets.symmetric(horizontal: 5, vertical: 20),
            decoration: BoxDecoration(
              color: _item.isSelected ? Colors.blueAccent : Colors.transparent,
              border: Border.all(
                  width: (isLanguage ?? false) ? 1 : 0.01,
                  color: _item.isSelected ? Colors.blueAccent : Colors.grey),
              borderRadius: BorderRadius.all((isLanguage ?? false)
                  ? const Radius.circular(25.0)
                  : const Radius.circular(2.0)),
            ),
            child: (isLanguage ?? false)
                ? Center(
                    child: Text(_item.textOrImage,
                        style: TextStyle(
                          color: _item.isSelected ? Colors.white : Colors.black,
                          //fontWeight: FontWeight.bold,

                          fontSize: 30.0,
                          fontFamily: "PoppinsRegular",
                        )),
                  )
                : Image(
                    image: AssetImage(_item.textOrImage),
                    height: 200,
                  ),
          ),
        ),
      ],
    );
  }
}

class RadioModel {
  bool isSelected;
  final String textOrImage;

  RadioModel(this.isSelected, this.textOrImage);
}
