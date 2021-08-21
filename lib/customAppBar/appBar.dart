import 'package:flutter/material.dart';
import 'package:idealog/design/textStyles.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  CustomAppBar({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only(top: 15,bottom: 15),
          child: Row(
            children: [
            IconButton(icon: Icon(Icons.arrow_back,color: Colors.black87),
            iconSize: 32,
            onPressed: ()=>Navigator.pop(context)),
            SizedBox(width: 8),
            Text(title!,
            style: dosis.copyWith(fontSize: 28)),
          ],),
        );
  }
}