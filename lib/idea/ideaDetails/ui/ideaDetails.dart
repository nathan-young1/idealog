import 'dart:ui';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/global/extension.dart';
import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/customDecoration/boxDecoration.dart';
import 'package:idealog/customDecoration/colors.dart';
import 'package:idealog/idea/ui/addToExisting.dart';
import 'package:idealog/sqlite-db/sqlite.dart';

class IdeaDetail extends StatelessWidget {
  final Idea detail;
  TextEditingController? description;
  IdeaDetail({required this.detail}){
    description = TextEditingController(text: detail.moreDetails);
  }

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
                       _IdeaDetailTab(detail: detail),
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
                 flex: 1,
                 child: TextField(
                   controller: description,
                   enabled: false,
                   decoration: underlineAndFilled.copyWith(
                     labelText: 'Description'
                   ),
                 )),
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
  final Idea detail;
  const _IdeaDetailTab({
    Key? key,
    required this.detail
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
         IconButton(icon: Icon(Icons.add,size: 35), onPressed: (){
           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddToExistingIdea(idea: detail)));
         }),
         SizedBox(width: 15),
         IconButton(icon: Icon(Icons.delete_sweep_outlined),onPressed: ()async{
             await Sqlite.deleteFromDB(uniqueId: '${detail.uniqueId}');
             Navigator.pop(context);
             })
      ],
    )
             ],
           );
  }
}