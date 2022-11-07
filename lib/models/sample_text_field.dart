import "package:flutter/material.dart";
import 'package:nibret_kifel/models/sample_container.dart';

class SampleTextField extends StatelessWidget {


  final Widget? mychild;
  final String? text;
  final TextEditingController? controller;
  final bool? enableSuggestions;
  final bool? autocorrect;
  final bool? obscureText;
  final bool? keyboardType;


  const SampleTextField({
     this.mychild, this.text,this.enableSuggestions,this.autocorrect,this.obscureText,  this.keyboardType, this.controller
  });

  @override
  Widget build(BuildContext context) {

    TextInputType chooser;
    if(keyboardType ?? false){chooser = TextInputType.emailAddress;}
    else {chooser = TextInputType.text;}
    return SampleContainer(
      mychild: Container(
          padding: EdgeInsets.fromLTRB(25,20,20,20),
          child: TextFormField(
            controller: controller,

          enableSuggestions: enableSuggestions ?? false,
          autocorrect: autocorrect??false,
          obscureText: obscureText ??false,
          keyboardType: chooser,
          //  autofillHints: [AutofillHints.email],
            //onEditingComplete: ()=>TextInput.finishAutofillContext(),
            decoration: InputDecoration(


            hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w100,
                fontFamily: "NeofontRoman",
                color: Colors.grey.withOpacity(0.5),
            ),
    border: InputBorder.none,
    //contentPadding: EdgeInsets.fromLTRB(10, 40, 0, 40),
              hintText: text,
          ),
    ),
        ),
      );
  }
}
