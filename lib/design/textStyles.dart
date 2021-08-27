import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final TextStyle dosis = TextStyle(fontFamily: "Dosis");

class AppFontWeight{
  static final TextStyle light = dosis.copyWith(fontWeight: FontWeight.w300);
  static final TextStyle reqular = dosis.copyWith(fontWeight: FontWeight.w400);
  static final TextStyle medium  = dosis.copyWith(fontWeight: FontWeight.w500);
  static final TextStyle semibold = dosis.copyWith(fontWeight: FontWeight.w600);
}

class AppFontSize{
  static final double small = 17.sp;
  static final double normal = 22.sp;
  static final double medium = 25.sp;
  static final double fontSize_15 = 15.sp;
  static final double fontSize_16 = 16.sp;
  static final double fontSize_18 = 18.sp;
  static final double fontSize_20 = 20.sp;
  static final double fontSize_23 = 23.sp;
  static final double fontSize_26 = 26.sp;
  static final double fontSize_28 = 28.sp;

  // for the idea listPage or the productivity page.
  static final double large = 30.sp;
}