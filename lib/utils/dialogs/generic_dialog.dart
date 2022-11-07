import 'package:flutter/material.dart';

import '../../constants/sizes.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  IconData? icon,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();

  return showDialog<T>(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 25,vertical: 40),
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),

          //this right here
          child: Container(
            height: Sizes.getTotalHeight(context) * 0.35,
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(icon,
                      size: 80,
                      color: Color(0xFFffcb47) ,
                    ),
                  ),
                  SizedBox(height:10),
                  Text(
                    title,
                    style: TextStyle(
                        color: Color(0xFF3f5368),
                        fontSize: 19,
                        fontWeight: FontWeight.w200,
                        fontFamily: "PoppinsSemiBold"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    content,
                    style: TextStyle(
                        color:Color(0xFFa0acb8),
                        fontSize: 16,
                        fontFamily: "PoppinsRegular"),
                  ),



                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ...(options.keys).map((optionTitle) {
                            final value = options[optionTitle];
                            return Container(
                              height:Sizes.getTotalHeight(context) * 0.081,
                              width: Sizes.getTotalWidth(context) * 0.375,
                              //padding: EdgeInsets.all(20),
                              margin: EdgeInsets.only(right: 10),
                              child: TextButton(

                                  style: ButtonStyle(
                                      textStyle: MaterialStateProperty.resolveWith((states) {
                                        return const TextStyle(
                                            color:Color(0xFFa0acb8),
                                            fontSize: 19,
                                            fontFamily: "PoppinsRegular");
                                      }),
                                      overlayColor: MaterialStateProperty.all<Color>(
                            (optionTitle =="yes" || optionTitle =="Ok")? Color(0xFFffcb47):Colors.grey.withOpacity(0.1),),
                                      foregroundColor:  MaterialStateProperty.resolveWith((states) =>
                                      (optionTitle =="yes" || optionTitle =="Ok")? Colors.white:Colors.grey.withOpacity(0.5)
                                      ),
                                      backgroundColor:
                                          MaterialStateColor.resolveWith((states) {

                                        return (optionTitle =="yes" || optionTitle =="Ok")? Color(0xFFffcb47).withOpacity(0.9):Colors.grey.withOpacity(0.1);
                                      }),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        //side: BorderSide(color: Colors.red)
                                      ))),
                                  onPressed: () {
                                    if (value != null) {
                                      Navigator.of(context).pop(value);
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Text(optionTitle)),
                            );
                          })
                        ],
                      ),
                    ),
                  )




                ],
              ),
            ),
          ),
        );
      });
}
