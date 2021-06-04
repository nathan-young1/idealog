import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Databases/idealog-db/idealog_Db_Moor.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/idea/ideaDetails/ui/ideaDetails.dart';
import 'package:idealog/idea/listPage/ui/newIdea.dart' show Info;

class AddToExistingIdea extends StatefulWidget {
  final IdeaModel idea;

  AddToExistingIdea({Key? key, required this.idea}) : super(key: key);

  @override
  _AddToExistingIdeaState createState() => _AddToExistingIdeaState();
}

class _AddToExistingIdeaState extends State<AddToExistingIdea> {
  final TextEditingController newTask = TextEditingController();

  FocusNode newTaskFocus = FocusNode();

  Set<String> newTasks = <String>{};

  void addNewTask(){
    if(newTask.text != ''){
      setState(() => newTasks.add(newTask.text));
      newTask.text = '';
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

                      TextFormField(
                          controller: newTask,
                          focusNode: newTaskFocus,
                          onFieldSubmitted: (_){
                            newTaskFocus.requestFocus();
                            addNewTask();
                          },
                          style: TextStyle(fontSize: 18),
                          decoration: underlineAndFilled.copyWith(
                            labelText: 'Task',
                            suffixIcon: IconButton(icon: Icon(Icons.check,color: LightPink.withOpacity(0.7),size: 30),
                            onPressed: () => addNewTask())
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
        bottomNavigationBar: GestureDetector(
            onTap: () async {
              newTasks.forEach((task) => widget.idea.addNewTask(task.codeUnits));
              await IdealogDb.instance.updateDb(updatedEntry: widget.idea);
              await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>IdeaDetail(idea: widget.idea)));
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