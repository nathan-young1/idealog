import 'package:flutter/material.dart';

/// This class holds the phone size info.
class PhoneSizeInfo {
  PhoneSizeInfo._();
  static var instance = PhoneSizeInfo._();
  
  static late final double height;
  static late final double width;

  void initialize(BuildContext context){
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
  }
}