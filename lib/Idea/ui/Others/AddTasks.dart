import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/Idea/ui/DetailPage/Detail.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:page_transition/page_transition.dart';
import 'CreateIdea.dart';
import 'ListOfTasksToAdd.dart';
import 'OpenBottomSheet.dart';

class AddTasksToExistingIdea extends StatefulWidget {
  final Idea idea;

  AddTasksToExistingIdea({Key? key, required this.idea}) : super(key: key);

  @override
  _AddTasksToExistingIdeaState createState() => _AddTasksToExistingIdeaState();
}

class _AddTasksToExistingIdeaState extends State<AddTasksToExistingIdea> {
  final TextEditingController newTask = TextEditingController();
  List<Task> allNewTasks = [];
  FocusNode newTaskFocus = FocusNode();

  late Function(Task task) addBottomSheetTaskToList;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    // Initialize the function.
    addBottomSheetTaskToList = (Task task)=> setState(() => allNewTasks.add(task));
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
                   onPressed: ()=> Navigator.pop(context)),
                    Expanded(
                      child: Center(
                        child: Container(
                          child: Text(widget.idea.ideaTitle,style: dosis.copyWith(fontSize: 35,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis),
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
    
                        HowToAddTaskInfo(),
                        SizedBox(height: 10),
    
                        ListOfTasksToAdd(tasks: allNewTasks),
                        SizedBox(height: 20),

                        OpenBottomSheet(addBottomSheetTaskToList, idea: widget.idea)
                      ],
                    ),
                  ),
                ),
              )
            ]),
          ),
          bottomNavigationBar: GestureDetector(
              onTap: () async {
                await IdeaManager.addNewTasksToExistingIdea(idea: widget.idea, newTasks: allNewTasks); 
                await Navigator.of(context).pushReplacement(PageTransition(child: IdeaDetail(idea: widget.idea), type: PageTransitionType.leftToRightWithFade));
                },
              child: Container(
                height: 65,
                color: DarkBlue,
                child: Center(
                  child: Text('Save',style: dosis.copyWith(fontSize: 32,color: Colors.white))
                  ),
              ),
            ),
        ),
      );
  }
}