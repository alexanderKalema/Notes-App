import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/bloc/screening_bloc/preferene_bloc.dart';

class DropdownItem extends StatefulWidget {
  Map<String, String> myList;
  Color myColor;

  DropdownItem({super.key, required this.myList, required this.myColor});

  @override
  State<DropdownItem> createState() => DropdownItemState();
}

class DropdownItemState extends State<DropdownItem> {
  late SharedPreferences prefs;
  late PreferenceBloc bloc;
  String color = 'Use default';
  String lang = 'English';

  @override
  void didChangeDependencies() {
    bloc = Provider.of<PreferenceProvider>(context).bloc;
    super.didChangeDependencies();
  }

  final _dropdownFormKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      ...(this.widget.myList.keys).map((key) {
        return DropdownMenuItem(
            child: Text(key), value: this.widget.myList[key]);
      })
    ];
    return menuItems;
  }

  @override
  void initState() {
    initalize();
    super.initState();
  }

  Future<void> initalize() async {
    prefs = await SharedPreferences.getInstance();
    if (widget.myList.length == 2) {
      this.widget.myList.forEach((key, value) {
        if (value == prefs.getStringList('settingPrefs')![0]) {
          print(
              "when i came here${key} ${prefs.getStringList('settingPrefs')![0]}");
          color = value;
        }
      });
    } else {
      this.widget.myList.forEach((key, value) {
        if (value == prefs.getStringList('myprefs')![1]) {
          lang = key;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final PreferenceBloc bloc = Provider.of<PreferenceProvider>(context).bloc;
    handleChange(String? newValue) async {
      print("almost finished ${newValue}");
      if (this.widget.myList.length == 2) {
        var temp = (await bloc.loadSettingPreferences())[1];

        bloc.changeSettingPref([newValue!, temp]);
        bloc.saveSettingPreferences();
      } else {
        var temp = (await bloc.loadPreferences())[0];
        bloc.changeMyPref([temp, newValue!]);
        bloc.savePreferences();
      }
    }

    return FutureBuilder(
        future: initalize(),
        builder: (context, snapshot) {
          return Form(
              key: _dropdownFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButtonFormField(
                    items: dropdownItems,
                    borderRadius: BorderRadius.circular(40),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: widget.myColor, width: 2),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: widget.myColor, width: 2),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) =>
                        value == null ? "Select a card" : null,
                    dropdownColor: widget.myColor,
                    value: (widget.myList.length == 2) ? color : lang,
                    onChanged: (String? newValue) {
                      setState(() {
                        print(prefs.getStringList('myprefs')![1]);

                        handleChange(newValue);
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ));
        });
  }
}
