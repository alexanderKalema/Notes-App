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
  final IconButton? icon;


  const SampleTextField({
     this.mychild, this.text,this.enableSuggestions,this.autocorrect,this.obscureText,  this.keyboardType, this.controller
  ,this.icon});

  @override
  Widget build(BuildContext context) {

    TextInputType chooser;
    if(keyboardType ?? false){chooser = TextInputType.emailAddress;}
    else {chooser = TextInputType.text;}
    return SampleContainer(
      mychild: Container(
          padding: EdgeInsets.fromLTRB(25,20,20,20),
          child: TextField(

            controller: controller,

          enableSuggestions: enableSuggestions ?? false,
          autocorrect: autocorrect??false,
          obscureText: obscureText ??false,
          keyboardType: chooser,
          //  autofillHints: [AutofillHints.email],
            //onEditingComplete: ()=>TextInput.finishAutofillContext(),
            decoration: InputDecoration(

           suffixIcon: icon,
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
class TextFieldForEditing extends StatelessWidget {

  TextEditingController controller;

   TextFieldForEditing({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        fontFamily: "NeofontRoman",
        //color: Colors.grey.withOpacity(0.5),
      ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w100,
          fontFamily: "NeofontRoman",
          color: Colors.grey.withOpacity(0.5),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        //contentPadding: EdgeInsets.fromLTRB(10, 40, 0, 40),
        hintText: "Title goes here",
      ),
    );
  }
}

