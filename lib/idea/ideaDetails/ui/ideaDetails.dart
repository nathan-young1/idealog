import 'dart:ui';
import 'package:idealog/global/extension.dart';
import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/customDecoration/boxDecoration.dart';
import 'package:idealog/customDecoration/colors.dart';
import 'package:idealog/sqlite-db/sqlite.dart';

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
               Expanded(
                 flex: 1,
                 child: Container(
                   color: lightModeBottomNavColor,
                   padding: EdgeInsets.only(top: 15,left: 20,right: 10),
                   child: Column(
                     children: [
                       _IdeaDetailTab(uniqueId: detail.uniqueId),
                       Expanded(child: Padding(
                         padding: EdgeInsets.only(left: 15,right: 15),
                         child: Center(
                           child: Text(detail.ideaTitle,style: TextStyle(fontSize: 40,fontWeight: FontWeight.w600))),
                       )),
                     ],
                   ),
                 ),
               ),
               Expanded(
                 flex: 2,
                 child: ListView(
                   padding: EdgeInsets.only(top: 30,left: 20,right: 10),
                   children: [
                  _TasksList(detail: detail,tasks: Tasks.UNCOMPLETED),
                   if(detail.tasks!.completedTasks.length == 0)
                  _TasksList(detail: detail, tasks: Tasks.COMPLETED)
                   
                   ],
                 ),
               )
             ]),
         )
      ),
    );
  }
}

enum Tasks{COMPLETED,UNCOMPLETED}

class _TasksList extends StatelessWidget {
  const _TasksList({
    Key? key,
    required this.detail,
    required this.tasks
  }) : super(key: key);

  final Idea detail;
  final Tasks tasks;

  @override
  Widget build(BuildContext context) {
    return Column(
    children: [
    Text((tasks == Tasks.UNCOMPLETED)?'Uncompleted Tasks':'Completed Tasks',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600)),
    Column(
       children:  (tasks == Tasks.UNCOMPLETED)
       ?detail.tasks!.uncompletedTasks.map((uncompleteTask) => Text(uncompleteTask.toAString)).toList()
       :detail.tasks!.completedTasks.map((completedTasks) => Text(completedTasks.toAString)).toList(),
     ),
       ],
     );
  }
}

class _IdeaDetailTab extends StatelessWidget {
  final int uniqueId;
  const _IdeaDetailTab({
    Key? key,
    required this.uniqueId
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
           onSelected: (_) async{
             await Sqlite.deleteFromDB(uniqueId: '$uniqueId');
             Navigator.pop(context);
             },
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