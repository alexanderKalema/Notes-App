import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibret_kifel/screens/regisrer_view.dart';
import '../constants/sizes.dart';
import '../models/sample_button.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../services/crud/note_service.dart';

class VerifyEmailView extends StatefulWidget {

  VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {

  late final NotesService _notesService;

@override
  void initState() {
   _notesService = NotesService();
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  Future<void> setting (String fname ,String lname ) async{
  String currentId = await AuthService.firebase().currentUser!.id;

    await _notesService.createUser(firstName: fname, lastName: lname, id: currentId);
    print("from verify $currentId");

  }

  @override
  Widget build(BuildContext context) {




      return
        FutureBuilder(



          future: setting(RegisterViewState.fnamee,RegisterViewState.lnamee),
          builder: (context, snapshot) {

          return Scaffold(

              body: Container(
                  color: Color(0xFFffcb47),
                  child: CustomScrollView(

                      slivers: [

                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 40,),
                              Container(
                                margin: EdgeInsets.only(left: 10, top: 20),

                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    size: 45,
                                    color: Color(0xFF2C2C2C).withOpacity(0.9),
                                  ),
                                  onPressed: () {
                                    context.read<AuthBloc>().add(
                                      AuthEventLogOut(),
                                    );
                                  },
                                ),
                              ),
                              Container(

                                padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
                                width: Sizes.getTotalWidth(context),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                      "Almost There, ${RegisterViewState.fnamee}!",
                                      style: TextStyle(
                                          fontSize: 35,
                                          letterSpacing: 1.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "TailwindRegular"
                                      ),
                                    ),



                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(60),
                                            topRight: Radius.circular(60)),
                                        color: Colors.white,
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 30, 20, 20),
                                      width: Sizes.getTotalWidth(context),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 140,),
                                          Icon(
                                            Icons.email,
                                            color: Color(0xFFffcb47),
                                            size: 100,),

                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              "Verify your email address",
                                              style: TextStyle(
                                                // letterSpacing: 1,
                                                fontSize: 27,
                                                  letterSpacing: 0.6,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "TailwindSRegular"),
                                            ),
                                          ),
                                          Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),

                                              child: Text(
                                                "We've sent you an email verification. Please open it  ",
                                                style: TextStyle(

                                                    height: 1.8,
                                                    color:Color(0xFFa0acb8),
                                                    fontSize: 13,
                                                    fontFamily: "PoppinsRegular")

                                              )),
                                          Container(
                                              child: Center(
                                                child: Text(
                                                  "to verify your account (Check spam folder).",
                                                  style: TextStyle(

                                                      height: 1.8,
                                                      color:Color(0xFFa0acb8),
                                                      fontSize: 13,
                                                      fontFamily: "PoppinsRegular")

                                                ),
                                              )),


                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .end,
                                                children: [
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          top: 50, bottom: 5),

                                                      child: Text(
                                                        "If you haven't received a verification email, press the",
                                                        style: TextStyle(
                                                            height: 1.8,
                                                            color:Color(0xFFa0acb8),
                                                            fontSize: 13,
                                                            fontFamily: "PoppinsRegular"
                                                        ),

                                                      )),

             Container(
                                                            margin: EdgeInsets.only(
                                                                bottom: 10),

                                                            child: Center(
                                                              child: Text(
                                                                "button below.",
                                                                style: TextStyle(
                                                                    height: 1.8,
                                                                    color:Color(0xFFa0acb8),
                                                                    fontSize: 13,
                                                                    fontFamily: "PoppinsRegular"),

                                                              ),
                                                            )
                                                  ),
                                                  LeveledButton(
                                                      text: "SEND AGAIN",
                                                      callback: () {
                                                        context.read<AuthBloc>()
                                                            .add(
                                                          const AuthEventSendEmailVerification(),
                                                        );
                                                      }),
                                                  SizedBox(height: 80,)
                                                ],
                                              ),
                                            ),
                                          ),


                                        ],
                                      )
                                  )
                              )
                            ],
                          ),)
                      ])
              ));
        }
      );



  }
}
