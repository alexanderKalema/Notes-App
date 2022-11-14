import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibret_kifel/models/sample_container.dart';
import 'package:nibret_kifel/models/sample_text_field.dart';
//import 'package:path/path.dart';

import '../constants/sizes.dart';
import '../models/sample_button.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utils/dialogs/error_dialog.dart';
import '../utils/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {



  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return

     BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
      if (state is AuthStateForgotPassword) {
        if (state.hasSentEmail) {
          _controller.clear();
          await showPasswordResetSentDialog(context);
        }
        if (state.exception != null) {
          await showErrorDialog(context,
              'We could not process your request. Please make sure that you are a registered user, or if not, register a user now by going back one step.');
        }
      }
    },




     child: Scaffold(

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
                margin: EdgeInsets.only(left:10, top:20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: SmallButton(


                  mychild: Icon(
                    Icons.arrow_back,
                    size: 35,
                    color: Color(0xFF2C2C2C).withOpacity(0.8),
                  ),
                  callback: (){
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
                  children:   [
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                          " Forgot Password",
                          style: TextStyle(
                              color:Color(0xFF2C2C2C),
                              letterSpacing: -1,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              fontFamily: "InterSemiBold"
                          )
                      ),
                    ),
                    Center(
                      child: Image(
                        image: AssetImage("assets/images/forgot_imahe.png"),
                        height: 200,
                      ),
                    ),

                  ],
                ),
              ),
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(60),topRight: Radius.circular(60)),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                      width: Sizes.getTotalWidth(context),


                      child: Column(
                        children: [
                          SizedBox(height: 30,),
                         Text("Enter your email, so we can send you a password reset link.",
                        style: TextStyle(

                          fontFamily: "InterRegular",
                          color:Colors.black.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        )),       SizedBox(height: 20,),
                          SampleTextField(text: "Email",
                            controller: _controller,
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: true,),


                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SampleButton(
                              mychild: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:  [
                                  Text("Send reset link",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "InterBold",
                                        color:Colors.black.withOpacity(0.9),

                                      )),
                                ],
                              ),
                              callback: ()  async {
                                final email = _controller.text;
                                context
                                    .read<AuthBloc>()
                                    .add(AuthEventForgotPassword(email: email));
                              },

                            ),
                          ],
                        ),
                      )
                        ],
                      )
                  )
              )],
          ),
        )]))
    ));
  }
}
