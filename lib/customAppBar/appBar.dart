import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  CustomAppBar({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only(top: 20,bottom: 20),
          child: Row(children: [
            IconButton(icon: Icon(Icons.arrow_back_ios),
            iconSize: 32.r,
            onPressed: ()=>Navigator.pop(context)),
            SizedBox(width: 10),
            Text(title!,style: TextStyle(fontSize: 24,fontWeight: FontWeight.w700),)
          ],),
        );
  }
}