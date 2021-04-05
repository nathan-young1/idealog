import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/customDecoration/colors.dart';
import 'package:idealog/idea/ui/addToExisting.dart';
import 'package:idealog/sqlite-db/sqlite.dart';

class DetailAppBar extends StatelessWidget {
  DetailAppBar({required this.idea});

  final Idea idea;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: lightModeBottomNavColor,
      padding: EdgeInsets.only(top: 15,left: 20,right: 10),
      child: Column(
        children: [
          _IdeaAppBarButtons(idea: idea),
          Expanded(child: Padding(
            padding: EdgeInsets.only(left: 15,right: 15),
            child: Center(
              child: Text(idea.ideaTitle,style: TextStyle(fontSize: 40,fontWeight: FontWeight.w600))),
          )),
        ],
      ),
    );
  }
}

class _IdeaAppBarButtons extends StatelessWidget {
  final Idea idea;
  const _IdeaAppBarButtons({required this.idea});

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
         IconButton(icon: Icon(Icons.add,size: 36), onPressed: (){
           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddToExistingIdea(idea: idea)));
         }),
         SizedBox(width: 15),
         IconButton(icon: Icon(Icons.delete_sweep_rounded,size: 36),onPressed: ()async{
             await Sqlite.deleteFromDB(uniqueId: '${idea.uniqueId}');
             Navigator.pop(context);
             })
      ],
    )
    ]);
  }
}