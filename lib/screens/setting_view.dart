import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibret_kifel/services/auth/firebase_auth_provider.dart';

import '../models/animated_toggle.dart';
import '../models/drop_down.dart';
import '../models/real_slider.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../services/auth/bloc/google_sign_in_provider.dart';
import '../utils/dialogs/logout_dialog.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {

  void dataPasser(){
    Map<dynamic, dynamic> myMap =
    { "cardColor" : DropdownItem.selectedValue ,
      "fontSize" :  (SliderWidget.myvalue * 42) + 8,
      "deleteConfirm": AnimatedSwitch.isEnabled,
    };
    Navigator.pop(context,
        myMap
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(5, 36, 30, 20),
              height: 180,
              decoration: const BoxDecoration(
                color: Color(0xFFffcb47),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50)),
              ),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                       dataPasser();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 28,
                      )),
                  Expanded(child: SizedBox()),
                  Text(
                    "Setting",
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
            Expanded(
              child: Container(
                padding:
                    EdgeInsets.only(left: 35, right: 35, bottom: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Font Size",
                      style:
                          TextStyle(fontFamily: "PoppinsRegular", fontSize: 20),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SliderWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        height: 1.0,
                        //   width:Sizes.getTotalWidth(context)*0.2,
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Card Color",
                      style:
                          TextStyle(fontFamily: "PoppinsRegular", fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownItem(),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                      "Confirm before deleting",
                      style:
                          TextStyle(fontFamily: "PoppinsRegular", fontSize: 20),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    AnimatedSwitch(),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                      "Log out",
                      style:
                          TextStyle(fontFamily: "PoppinsRegular", fontSize: 20),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      child: Text('Log out'),
                      onPressed: () async {

                        final shouldLogout = await showLogOutDialog(context);
                        if (shouldLogout) {
                          dataPasser();
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          context.read<AuthBloc>().add(

                                 AuthEventLogOut( emailUser:FirebaseAuthProvider().currentUser),

                              );

                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:   Color(0xFF7175ff),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(13))),
                          elevation: 6,
                          padding: EdgeInsets.all(14)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                      "About",
                      style:
                          TextStyle(fontFamily: "PoppinsRegular", fontSize: 20),
                    )
                    ,
                    Text(
                      "My Notes 1.0.0+1  \nDeveloped by Alexander Alema & Mikyas Worku. \nContact @alexanderkalema to report bugs or for any enquiries.\nMore updates to follow soon!",
                      style: TextStyle(
                        height: 1.8,
                          color:Color(0xFFa0acb8),
                          fontSize: 13,
                          fontFamily: "PoppinsRegular"),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
