import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  CustomAppBar({required this.title});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
            padding: EdgeInsets.all(30.w),
            child: Icon(Icons.arrow_back_ios,size: 35.r,),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 30.w),
            child: Text(title!),
          ),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
    );
  }
}