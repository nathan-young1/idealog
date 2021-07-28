import 'dart:math';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Databases/idealog-db/idealog_Db.dart';
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/Idea/ui/DetailPage/Detail.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';
import 'CreateIdea.dart' show AddTaskButton, Info, ListOfTasks;

class AddToExistingIdea extends StatefulWidget {
  final Idea idea;

  AddToExistingIdea({Key? key, required this.idea}) : super(key: key);

  @override
  _AddToExistingIdeaState createState() => _AddToExistingIdeaState();
}

class _AddToExistingIdeaState extends State<AddToExistingIdea> {
  final TextEditingController newTask = TextEditingController();
  ValueNotifier<List<Task>> allNewTasks = ValueNotifier([]);
  FocusNode newTaskFocus = FocusNode();

  late Function(Task task) addBottomSheetTaskToList;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {

    addBottomSheetTaskToList = (Task task){
       allNewTasks.value.add(task);
       setState(() {});
    };
    super.initState();
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
                          child: Text(widget.idea.ideaTitle,style: overpass.copyWith(fontSize: 35,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis),
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
    
                        ListOfTasks(),
                        SizedBox(height: 20),

                        AddTaskButton(addBottomSheetTaskToList)
                      ],
                    ),
                  ),
                ),
              )
            ]),
          ),
          bottomNavigationBar: GestureDetector(
              onTap: () async {
                await IdeaManager.addNewTasksToExistingIdea(idea: widget.idea, newTasks: allNewTasks.value);
                await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> IdeaDetail(idea: widget.idea)));
                },
              child: Container(
                height: 65,
                color: DarkBlue,
                child: Center(
                  child: Text('Save',style: overpass.copyWith(fontSize: 32,color: Colors.white))
                  ),
              ),
            ),
        ),
      );
  }


  // ignore: non_constant_identifier_names
  Widget ListOfTasks(){
    return ValueListenableBuilder(
      valueListenable: allNewTasks,
      builder: (context, List<Task> tasks, _) => Column(
          children: tasks.reversed.map((taskRow) =>
            Row(
              children: [
                Icon(Icons.circle,color: Colors.grey,size: 20),
                SizedBox(width: 25),
                Expanded(child: Container(child: Text(taskRow.task))),
                IconButton(
                icon: Icon(CommunityMaterialIcons.close,color: Colors.grey),
                onPressed: (){ 
                  allNewTasks.value.remove(taskRow); 
                  setState(() {});})
              ])
              ).toList()),
    );
  }
}