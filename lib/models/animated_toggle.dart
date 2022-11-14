import 'package:flutter/material.dart';

class AnimatedSwitch extends StatefulWidget {
  static var isEnabled = true;
  @override
  AnimatedSwitchState createState() => AnimatedSwitchState();
}

class AnimatedSwitchState extends State<AnimatedSwitch> {

  final animationDuration = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
    Container(
    decoration: BoxDecoration(
    color: Color(0xFFd9d9d9),
    borderRadius: BorderRadius.all(Radius.circular(40))
    ),

    width: 80,
    child:GestureDetector(
            onTap: () {
              setState(() {
                AnimatedSwitch. isEnabled = !AnimatedSwitch.isEnabled;
              });
            },
            child: AnimatedContainer(
                duration: animationDuration,
                child: Padding(
                    padding: EdgeInsets.all(2),
                    child: AnimatedAlign(
                      duration: animationDuration,
                      alignment:
                      AnimatedSwitch.isEnabled ? Alignment.centerRight : Alignment. centerLeft,
                      child: AnimatedContainer(
                        height: 30,
                        width: 40,
                        duration: animationDuration,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: AnimatedSwitch.isEnabled ?  Color(0xFF7175ff): Colors.white ,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              spreadRadius: 2,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    )))),),
        SizedBox(width: 10,),
        Text( (AnimatedSwitch.isEnabled)? "Yes" :"No" ,
            style: TextStyle(

                color:Color(0xFFa0acb8),
                fontSize: 13,
                fontFamily: "PoppinsRegular")
        ),
      ],
    );
  }
}
