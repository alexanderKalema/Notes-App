import "package:flutter/material.dart";
import "../constants/sizes.dart";

class SampleContainer extends StatelessWidget {



  bool chooser;
  Widget? child;
  Row? row;


  SampleContainer({this.child,  this.row , required this.chooser});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.getTotalHeight(context) * 0.1,
      width: Sizes.getTotalWidth(context) * 0.8,
      decoration: const BoxDecoration(
          color: const Color.fromRGBO(242,243,247,1),
          borderRadius:  BorderRadius.all(Radius.circular(29)),

          ),
      child: chooser? row : child,
    );
  }
}
