import 'dart:ui';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/global/enums.dart';
import 'package:idealog/global/extension.dart';
import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/customDecoration/boxDecoration.dart';
import 'package:idealog/customDecoration/colors.dart';
import 'package:idealog/idea/ui/addToExisting.dart';
import 'package:idealog/sqlite-db/sqlite.dart';

class IdeaDetail extends StatefulWidget {
  final Idea detail;
  TextEditingController? description;
  IdeaDetail({required this.detail}){
    description = TextEditingController(text: detail.moreDetails);
  }

  @override
  _IdeaDetailState createState() => _IdeaDetailState();
}

class _IdeaDetailState extends State<IdeaDetail> {
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
                       _IdeaDetailTab(detail: widget.detail),
                       Expanded(child: Padding(
                         padding: EdgeInsets.only(left: 15,right: 15),
                         child: Center(
                           child: Text(widget.detail.ideaTitle,style: TextStyle(fontSize: 40,fontWeight: FontWeight.w600))),
                       )),
                     ],
                   ),
                 ),
               ),
               Expanded(
                 flex: 1,
                 child: TextField(
                   controller: widget.description,
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
                  _TasksList(detail: widget.detail,tasks: Tasks.UNCOMPLETED),
                   //if(detail.tasks!.completedTasks.length == 0)
                  _TasksList(detail: widget.detail, tasks: Tasks.COMPLETED)
                   
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

class _TasksList extends StatefulWidget {
  const _TasksList({
    Key? key,
    required this.detail,
    required this.tasks
  }) : super(key: key);

  final Idea detail;
  final Tasks tasks;

  @override
  __TasksListState createState() => __TasksListState();
}

class __TasksListState extends State<_TasksList> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
        Text((widget.tasks == Tasks.UNCOMPLETED)?'Uncompleted Tasks':'Completed Tasks',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600)),
        Column(
           children:  (widget.tasks == Tasks.UNCOMPLETED)
           ?widget.detail.tasks!.uncompletedTasks.map((uncompletedTask) => ListTile(
             leading: Checkbox(value: false, onChanged: (bool? value){
               widget.detail.tasks!.completeTask(uncompletedTask);
               setState(() {  });
               }),
             title: Text(uncompletedTask.toAString),
             trailing: IconButton(icon: Icon(Icons.close),onPressed: () async {
               widget.detail.tasks!.deleteTask(uncompletedTask);
                await Sqlite.updateDb(widget.detail.uniqueId, idea: widget.detail);}))).toList()
           :widget.detail.tasks!.completedTasks.map((completedTask) => ListTile(
             leading: Checkbox(value: true, onChanged: (bool? value){
            widget.detail.tasks!.uncheckCompletedTask(completedTask);
             setState(() {  });}),
             title: Text(completedTask.toAString),
             trailing: IconButton(icon: Icon(Icons.close),onPressed: ()=>widget.detail.tasks!.deleteTask(completedTask)))).toList(),
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