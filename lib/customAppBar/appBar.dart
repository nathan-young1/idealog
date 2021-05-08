import 'package:flutter/material.dart';
import 'package:idealog/design/textStyles.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  CustomAppBar({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only(top: 30,bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            IconButton(icon: Icon(Icons.arrow_back),
            iconSize: 35,
            onPressed: ()=>Navigator.pop(context)),
            SizedBox(width: 10),
            Text(title!,style: Overpass.copyWith(fontSize: 30,fontWeight: FontWeight.w500))
          ],),
        );
  }
}