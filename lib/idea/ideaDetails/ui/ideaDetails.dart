import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/customDecoration/boxDecoration.dart';
import 'package:idealog/customDecoration/colors.dart';

class IdeaDetail extends StatelessWidget {
  final Idea detail;
  IdeaDetail({required this.detail});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: lightModeBackgroundColor,
         child: Scaffold(
           backgroundColor: Colors.transparent,
           body: Column(
             children: [
               Container(
                 height: 200,
                 color: lightModeBottomNavColor,
                 padding: EdgeInsets.only(top: 15,left: 20,right: 10),
                 child: Column(
                   children: [
                     _IdeaDetailTab(),
                     Expanded(child: Center(child: Text(detail.ideaTitle,style: TextStyle(fontSize: 40,fontWeight: FontWeight.w600)))),
                   ],
                 ),
               ),
             ]),
         )
      ),
    );
  }
}

class _IdeaDetailTab extends StatelessWidget {
  const _IdeaDetailTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
     IconButton(icon: Icon(Icons.arrow_back_ios),
     iconSize: 32,
     onPressed: ()=>Navigator.pop(context)),
     Row(
       children: [
         IconButton(icon: Icon(Icons.add,size: 35), onPressed: (){}),
         SizedBox(width: 15),
         PopupMenuButton<int>(
           iconSize: 35,
           padding: EdgeInsets.zero,
           itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
           PopupMenuItem<int>( 
             value: 0,
             child:  Container(
               child: Row(
                 children: [
                 Icon(Icons.delete_sweep,size: 30),
                 SizedBox(width: 10),
                 Text('Delete',style: TextStyle(fontSize: 18))
               ],),
             ),
           )],
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
         )
      ],
    )
             ],
           );
  }
}