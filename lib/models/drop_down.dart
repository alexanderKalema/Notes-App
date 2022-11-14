import 'package:flutter/material.dart';



class DropdownItem extends StatefulWidget {

  static String selectedValue = "default";
  const DropdownItem({Key? key}) : super(key: key);

  @override
  State<DropdownItem> createState() => DropdownItemState();
}
class DropdownItemState extends State<DropdownItem> {

  final _dropdownFormKey = GlobalKey<FormState>();


  List<String> items = ['Use default', "Generate randomly"];

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Use default"),value: "default"),
      DropdownMenuItem(child: Text("Generate randomly"),value: "random"),

    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Form(

        key: _dropdownFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [



            DropdownButtonFormField(

                decoration: InputDecoration(


             contentPadding: EdgeInsets.all(20),
                    hintText: "Use default",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFffcb47), width: 2),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  border: OutlineInputBorder(

                    borderSide: BorderSide(color:Color(0xFFffcb47), width: 2),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value == null ? "Select a card" : null,
                dropdownColor: Color(0xFFffcb47),
                value: DropdownItem.selectedValue,


                onChanged: (String? newValue) {
                  setState(() {
                    DropdownItem.selectedValue = newValue!;
                  });
                },
                items: dropdownItems),
            SizedBox(height: 10,),


          ],
        ));
  }}