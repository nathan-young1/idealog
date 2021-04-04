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
    return Container(
       child: Scaffold(
         body: Column(children: [
          IconButton(icon: Icon(Icons.arrow_back_ios),
          iconSize: 32,
          onPressed: ()=>Navigator.pop(context)),
           Container(
             child: Text(idea.ideaTitle),
           ),
           Text('Existing Tasks'),
           ListView(
             children: [
               ...idea.tasks!.uncompletedTasks.map((task) => Text(task.toAString)).toList(),
               ...idea.tasks!.completedTasks.map((task) => Text(task.toAString)).toList()
             ],
           ),
           Text('New Tasks'),
           ListView(
             children: newTasks.map((newTask) => Text(newTask)).toList(),
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
    );
  }
}