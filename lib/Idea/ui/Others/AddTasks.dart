import 'dart:math';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Databases/idealog-db/idealog_Db.dart';
import 'package:idealog/Idea/ui/DetailPage/Detail.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'CreateIdea.dart' show Info;
import 'package:idealog/global/extension.dart';

class AddToExistingIdea extends StatefulWidget {
  final Idea idea;

  AddToExistingIdea({Key? key, required this.idea}) : super(key: key);

  @override
  _AddToExistingIdeaState createState() => _AddToExistingIdeaState();
}

class _AddToExistingIdeaState extends State<AddToExistingIdea> {
  final TextEditingController newTask = TextEditingController();

  FocusNode newTaskFocus = FocusNode();

  Set<String> newTasks = <String>{};
  GlobalKey<FormState> formKey = GlobalKey();

  void addNewTask(){
    if(newTask.text.isNotEmpty){
      setState(() {
          newTasks.add(newTask.text.trim());
        });
      newTask.clear();
      }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
            Container(
             height: 250,
             padding: EdgeInsets.only(top: 15,left: 20,right: 10),
             color: LightGray,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 IconButton(icon: Icon(FeatherIcons.arrowLeft),
                 iconSize: 37,
                 onPressed: ()=>Navigator.pop(context)),
                  Expanded(
                    child: Center(
                      child: Container(
                        child: Text(widget.idea.ideaTitle,style: Overpass.copyWith(fontSize: 35,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
               ],
             ),
           ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,right: 15),
                  child: Column(
                    children: [
                      SizedBox(height: 60),
                      Text('Add a new task',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500)),
                      SizedBox(height: 20),

                      Info(),
                      SizedBox(height: 10),

                      NewTasks(),
                      SizedBox(height: 20),

                      Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                            controller: newTask,
                            focusNode: newTaskFocus,
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            maxLength: 350,
                            validator: (value){
                              if({...widget.idea.completedTasks.map((e) => e.task.toAString),...widget.idea.uncompletedTasks.map((e) => e.task.toAString)}
                              .contains(newTask.text))
                              return "Task already exists";
                            },
                            onFieldSubmitted: (_){
                              if(formKey.currentState!.validate()){
                              newTaskFocus.requestFocus();
                              addNewTask();
                              }
                            },
                            style: TextStyle(fontSize: 18),
                            decoration: underlineAndFilled.copyWith(
                              labelText: 'Task',
                              suffixIcon: IconButton(icon: Icon(Icons.check,color: LightPink.withOpacity(0.7),size: 30),
                              onPressed: (){
                                if(formKey.currentState!.validate()){
                                newTaskFocus.requestFocus();
                                addNewTask();
                                }
                              }
                            ),
                          ),
                      ),)
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
        bottomNavigationBar: GestureDetector(
            onTap: () async {
              int orderIndex = 0;
              int lastUncompletedOrderIndex = widget.idea.uncompletedTasks.map((e) => e.orderIndex).fold(0, (previousValue, currentValue) => max(previousValue, currentValue));
              
              for(var task in newTasks) { 
                Task taskObject = Task(task: task.codeUnits, orderIndex: orderIndex);
                widget.idea.addNewTask(taskObject);
                await IdealogDb.instance.addTask(taskRow: taskObject, ideaId: widget.idea.uniqueId!,lastUncompletedRowIndex: lastUncompletedOrderIndex);
                orderIndex++;
              }

              await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> IdeaDetail(idea: widget.idea)));
              },
            child: Container(
              height: 65,
              color: DarkBlue,
              child: Center(
                child: Text('Save',style: Overpass.copyWith(fontSize: 32,color: Colors.white))
                ),
            ),
          ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget NewTasks() {
    return Column(
      children: [
        for(String task in newTasks) 
        Row(
          children: [
          Icon(Icons.circle,color: Colors.grey,size: 20),
          SizedBox(width: 25),
          Expanded(child: Container(child: Text(task))),
          IconButton(
          icon: Icon(CommunityMaterialIcons.close,color: Colors.grey),
          onPressed: (){
            setState(() =>newTasks.remove(task));
            })
          ])]
    );
}
}