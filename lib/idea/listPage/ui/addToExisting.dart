import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
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
      child: Scaffold(
        body: Column(
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
              child: Column(
                children: [
                  SizedBox(height: 60),
                  Text('Add a new task',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500)),
                SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Icon(Icons.info,color: Colors.grey,size: 28),
                      Text(' Press ',style: TextStyle(fontSize: 20)),
                      Container(
                        width: 85,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: LightGray,
                        ),
                        child: Center(child: Text('Enter',style: TextStyle(fontSize: 20))),
                      ),
                      Text(' to add task.',style: TextStyle(fontSize: 20))
                    ],),
                  Column(
                    children: newTasks.map((newTask) => ListTile(leading: Icon(Icons.circle,color: Colors.grey,size: 20),
                    title: Text(newTask),
                    trailing: IconButton(
                    icon: Icon(CommunityMaterialIcons.close,color: Colors.grey),
                    onPressed: (){
                      setState(() =>newTasks.remove(newTask));
                      }),)).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(offset: Offset(0, 0),blurRadius: 15,color: Colors.black45)
                        ]
                      ),
                      child: TextFormField(
                        controller: newTask,
                        focusNode: newTaskFocus,
                        onFieldSubmitted: (task){
                          newTaskFocus.requestFocus();
                          if(task != ''){
                          setState(() => newTasks.add(task));
                          newTask.text = '';
                          }
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Task',
                          contentPadding: EdgeInsets.only(right: 0,left: 15,top: 5),
                          suffixIcon: Container(
                            color: LightPink,
                            child: IconButton(icon: Icon(Icons.check,color: Colors.white,size: 30),
                            onPressed: () => newTaskFocus.unfocus()),
                          )
                        ),
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
}