import "package:flutter/material.dart";
import "../constants/sizes.dart";

class SampleContainer extends StatelessWidget {



  Widget? mychild;
  Color? mycolor;


  SampleContainer({this.mychild , this.mycolor});


  @override
  Widget build(BuildContext context) {

    return Container(

      margin: EdgeInsets.only(bottom: 10),
      height: Sizes.getTotalHeight(context) * 0.085,
      width: Sizes.getTotalWidth(context) * 0.9,
      decoration:  BoxDecoration(
        color: mycolor?? Color.fromRGBO(242,243,247,1),
        borderRadius:  BorderRadius.all(Radius.circular(20)),

          ),
      child: mychild,
    );
  }
}
