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

/// get height in relation with the screen height.
double percentHeight(double percentHeight){
  /// get the percentage in ratio 0 - 1;
  double heightPercentInRatioTo1 = percentHeight / 100;
  return PhoneSizeInfo.height * heightPercentInRatioTo1;
}

/// get width in relation with the screen width.
double percentWidth(double percentWidth){
  /// get the percentage in ratio 0 - 1;
  double widthPercentInRatioTo1 = percentWidth / 100;
  return PhoneSizeInfo.width * widthPercentInRatioTo1;
}