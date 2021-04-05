import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/customDecoration/colors.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/global/extension.dart';

class AddToExistingIdea extends StatelessWidget {
  final Idea idea;
  final TextEditingController newTask = TextEditingController();
  List<String> newTasks = [];
  AddToExistingIdea({Key? key, required this.idea}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
         child: Scaffold(
           body: Column(
             children: [
            Container(
              height: 200,
              padding: EdgeInsets.only(top: 15,left: 20,right: 10),
              color: lightModeBottomNavColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(icon: Icon(Icons.arrow_back_ios),
                  iconSize: 32,
                  onPressed: ()=>Navigator.pop(context)),
                   Expanded(
                     child: Center(
                       child: Container(
                         child: Text(idea.ideaTitle,style: TextStyle(fontSize: 40,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis),
                       ),
                     ),
                   ),
                ],
              ),
            ),
             Text('Existing Tasks',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500)),
             Expanded(
               child: ListView(
                 children: [
                   ...idea.tasks!.uncompletedTasks.map((task) => Text(task.toAString)).toList(),
                   ...idea.tasks!.completedTasks.map((task) => Text(task.toAString)).toList()
                 ],
               ),
             ),
             Text('New Tasks',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500)),
             Expanded(
               child: ListView(
                 children: newTasks.map((newTask) => Text(newTask)).toList(),
               ),
             ),
             TextField(
               controller: newTask,
               decoration: underlineAndFilled.copyWith(
                 labelText: 'New Task',
               ),
             ),
             Container(
               height: 50,
               color: lightModeBottomNavColor,
               child: Center(
                 child: Text('Save')
                 ),
             )
           ])
         )
      ),
    );
  }
}