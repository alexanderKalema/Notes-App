import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

class PreferenceBloc {
  final _prefs = BehaviorSubject<List<String>>();
  final _settingPrefs = BehaviorSubject<List<String>>();

//Getters
  Stream<List<dynamic>> get mypref => _prefs.stream;
  Stream<List<dynamic>> get settingpref => _settingPrefs.stream;

//Setters
  Function(List<String> mylist) get changeMyPref => _prefs.sink.add;
  Function(List<String> mylist) get changeSettingPref => _settingPrefs.sink.add;

  savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('myprefs', _prefs.value);
    // print("  imp ${_prefs.value}");
  }

  saveSettingPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('settingPrefs', _settingPrefs.value);
    print("this is again important ${_settingPrefs.value}");
  }

  loadSettingPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final myList =
        prefs.getStringList('settingPrefs') ?? ["Use default", "true"];
    changeSettingPref(myList);
    print(" again  ${_settingPrefs.value}");

    return myList;
  }

  loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final myList = prefs.getStringList('myprefs') ?? [];
    changeMyPref(myList);
    return myList;
// double colorIndex = prefs.get('colorIndex');

// if (darkMode != null){
// (darkMode == false) ? changeBrightness(Brightness.light) : changeBrightness(Brightness.dark);
// } else {
// changeBrightness(Brightness.light);
// }
//
// if (colorIndex != null){
// changePrimaryColor(indexToPrimaryColor(colorIndex));
// } else {
// changePrimaryColor(ColorModel(color: Colors.blue,index: 0.0, name: 'Blue'));
// }
  }

  dispose() {
    _prefs.close();
  }
}

class PreferenceProvider with ChangeNotifier {
  late PreferenceBloc _bloc;

  PreferenceProvider() {
    _bloc = PreferenceBloc();
    _bloc.loadPreferences();
    _bloc.loadSettingPreferences();
  }

  PreferenceBloc get bloc => _bloc;
}
