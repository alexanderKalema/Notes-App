import "package:flutter/material.dart";
import 'package:nibret_kifel/models/sample_container.dart';

class SampleTextField extends StatelessWidget {


  final Widget? child;
  final String? text;

  const SampleTextField({
     this.child, this.text
  });

  @override
  Widget build(BuildContext context) {
    return SampleContainer(
      chooser: false,
      child:  TextFormField(

      //  autofillHints: [AutofillHints.email],
        //onEditingComplete: ()=>TextInput.finishAutofillContext(),
        decoration: InputDecoration(
        hintStyle: TextStyle(fontSize: 17),
    hintText: text,

    border: InputBorder.none,
    contentPadding: EdgeInsets.fromLTRB(10, 40, 0, 40),
      ),
    ));
  }
}
