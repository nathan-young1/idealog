import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/customDecoration/boxDecoration.dart';
import 'package:idealog/customDecoration/colors.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/global/extension.dart';
import 'package:idealog/idea/ideaDetails/ui/ideaDetails.dart';
import 'package:idealog/sqlite-db/sqlite.dart';

class AddToExistingIdea extends StatefulWidget {
  final Idea idea;

  AddToExistingIdea({Key? key, required this.idea}) : super(key: key);

  @override
  _AddToExistingIdeaState createState() => _AddToExistingIdeaState();
}

class _AddToExistingIdeaState extends State<AddToExistingIdea> {
  final TextEditingController newTask = TextEditingController();

  FocusNode newTaskFocus = FocusNode();

  Set<String> newTasks = Set<String>();

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
                         child: Text(widget.idea.ideaTitle,style: TextStyle(fontSize: 40,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis),
                       ),
                     ),
                   ),
                ],
              ),
            ),
             Expanded(
               child: SingleChildScrollView(
                 child: Column(
                   children: [
                     Text('Existing Tasks',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500)),
                     Column(
                       children: [
                         ...widget.idea.uncompletedTasks.map((task) => Text(task.toAString)).toList(),
                         ...widget.idea.completedTasks.map((task) => Text(task.toAString)).toList()
                       ],
                     ),
                     Text('New Tasks',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500)),
            Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Icon(Icons.info,color: Colors.grey,size: 28),
                      Text(' Press ',style: TextStyle(fontSize: 22)),
                      Container(
                        width: 85,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey,
                        ),
                        child: Center(child: Text('Enter',style: TextStyle(fontSize: 21,color: Colors.white))),
                      ),
                      Text(' to add task.',style: TextStyle(fontSize: 22))
            ],),
                     Column(
                       children: newTasks.map((newTask) => ListTile(title: Text(newTask))).toList(),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(12.0),
                       child: TextField(
                         controller: newTask,
                         focusNode: newTaskFocus,
                         maxLength: 150,
                        onSubmitted: (task){
                          newTaskFocus.requestFocus();
                          if(task != ''){
                          setState(() => newTasks.add(task));
                          newTask.text = '';
                          }
                        },
                         decoration: underlineAndFilled.copyWith(
                           labelText: 'New Task',
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             ),
           ]),
           bottomNavigationBar: GestureDetector(
               onTap: () async {
                 newTasks.forEach((task) => widget.idea.addNewTask(task.codeUnits));
                 await Sqlite.updateDb(widget.idea.uniqueId, idea: widget.idea);
                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>IdeaDetail(idea: widget.idea)));},
               child: Container(
                 height: 50,
                 color: lightModeBottomNavColor,
                 child: Center(
                   child: Text('Save')
                   ),
               ),
             ),
         )
      ),
    );
  }
}