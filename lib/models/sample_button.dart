import "package:flutter/material.dart";
import 'package:nibret_kifel/models/sample_container.dart';

class SampleButton extends StatelessWidget {

  final Widget mychild;
  final VoidCallback? callback;

  SampleButton({required this.mychild, this.callback});

  @override
  Widget build(BuildContext context) {

    return SampleContainer(
        mycolor: Color(0xFFffcb47) ,
        mychild: TextButton(
      style: ButtonStyle(
    overlayColor:  MaterialStateProperty.all<Color>(Colors.orangeAccent.withOpacity(0.4)),
        backgroundColor:   MaterialStateProperty.all<Color>(Color(0xFFffcb47)),
        textStyle: MaterialStateProperty.resolveWith((states) {
          // If the button is pressed, return size 40, otherwise 20
          if (states.contains(MaterialState.pressed)) {
            return TextStyle(fontSize: 30);
          }
          return TextStyle(fontSize: 20);
        }),

          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),)),),
      onPressed: callback,
      child: mychild,
    ));
  }
}

class SmallButton extends StatelessWidget {
  Widget mychild;
  final VoidCallback? callback;

  SmallButton({required this.mychild, this.callback});

  @override
  Widget build(BuildContext context) {
    return TextButton(

        style: ButtonStyle(
            overlayColor:  MaterialStateProperty.all<Color>(Colors.orangeAccent.withOpacity(0.4)),
          backgroundColor: MaterialStateColor.resolveWith(
                  (states) {
        if (states.contains(MaterialState.pressed)) {
    return Color(0xFFffcb47);
    }
    return Color(0xFFffcb47).withOpacity(0.15);
                  }
  ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18.0),
    //side: BorderSide(color: Colors.red)

        ))),
        onPressed: callback,
        child: mychild);
  }
}


class LeveledButton extends StatelessWidget {
  String text;
  final VoidCallback? callback;

  LeveledButton({required this.text, this.callback});

  @override
  Widget build(BuildContext context) {
    return
      Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
      TextButton(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: TextStyle(
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
            fontFamily: "InterSemiBold",
            color: Colors.white,
            fontSize: 15),
      ),
    ),
    style: ButtonStyle(
    backgroundColor:
    MaterialStateProperty.all<Color>(Color(0xFFffcb47)),
    ),
    onPressed: callback,
    )]
      ));

  }
}
