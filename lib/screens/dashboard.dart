import 'package:flutter/material.dart';
import 'package:nibret_kifel/models/sample_container.dart';
import 'package:nibret_kifel/models/sample_text_field.dart';

import '../constants/sizes.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

       body: Container(

         color: Color(0xFFffcb47),
         child: Column(
           children: [
             Container(
               padding: const EdgeInsets.all(20),
               width: Sizes.getTotalWidth(context),

               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children:  const [
                   SizedBox(height: 50),
                   Text("Register "),
                   Text(
                       "Welcome, let's introduce yourself before we began"),
                 ],
               ),
             ),
             Expanded(
               child: Container(
                 width: Sizes.getTotalWidth(context),
                 decoration: const BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
                     boxShadow: [
                       BoxShadow(
                         offset: Offset(8, 12),
                         blurRadius: 14,
                         color: Color(0xFFebecf0),
                       )
                     ]),

                 child: Column(
                   children: [
                     SampleContainer( chooser:true, row:
                         Row(
                       children: [
                         Icon(Icons.accessibility),
                         Expanded(child: Container()),
                         Text("Register with Google"),
                         Expanded(child: Container()),
                         Icon(
                           Icons.arrow_forward
                         )
                       ],
                     )
                     ),
                     SizedBox(
                       height: 10,
                     ),

                     Text("Or Register with email"),
                     SizedBox(
                       height: 10,
                     ),
                     SampleTextField(text: "Full Name",),
                     SizedBox(
                       height: 10,
                     ),
                     SampleTextField(text: "Email",),
                     SizedBox(
                       height: 10,
                     ),
                     SampleTextField(text: "Password",),


                   ],

                 ),
             )
             )],
       ),
       ),
    );
  }
}
