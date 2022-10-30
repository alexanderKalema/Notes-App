import 'package:flutter/material.dart';

class Sizes{

  static getTotalWidth(BuildContext context){
    return MediaQuery. of(context). size. width;
  }

  static getTotalHeight(BuildContext context){
    return MediaQuery. of(context). size. height;
  }
}