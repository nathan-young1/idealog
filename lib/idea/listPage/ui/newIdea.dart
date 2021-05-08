import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/customAppBar/appBar.dart';
import 'package:idealog/customDecoration/boxDecoration.dart';
import 'package:idealog/customDecoration/colors.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/idea/ideaDetails/code/ideaManager.dart';

class NewIdea extends StatefulWidget {
  @override
  _NewIdeaState createState() => _NewIdeaState();
}

class _NewIdeaState extends State<NewIdea> {
  Set<String> tasks = Set<String>();
  TextEditingController taskField = TextEditingController();
  TextEditingController deadline = TextEditingController();
  TextEditingController ideaTitle = TextEditingController();
  TextEditingController moreDetails = TextEditingController();
  FocusNode taskFieldFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: SingleChildScrollView(
            child: Form(
              child: Padding(
                padding: const EdgeInsets.only(left: 20,right: 15),
                child: Column(
                  children: [
                    CustomAppBar(title: 'ADD IDEA'),
                    TextFormField(
                      controller: ideaTitle,
                      maxLength: 50,
                      decoration: underlineAndFilled.copyWith(
                        labelText: 'Idea title',
                        prefixIcon: Icon(Icons.text_fields)
                      )
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: moreDetails,
                      maxLines: null,
                      maxLength: 300,
                      minLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: underlineAndFilled.copyWith(
                        labelText: 'More details on idea...'
                      ),
                    ),
                    SizedBox(height: 25),
                    Text('Tasks required for idea',style: TextStyle(fontSize: 25)),
                    SizedBox(height: 15),
                    Row(children: [
                      SizedBox(width: 20),
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
                    SizedBox(height: 15),
                    _AllTasks(),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(offset: Offset(0, 0),blurRadius: 15,color: Colors.black45)
                        ]
                      ),
                      child: TextFormField(
                        controller: taskField,
                        focusNode: taskFieldFocus,
                        onFieldSubmitted: (newTask){
                          taskFieldFocus.requestFocus();
                          if(newTask != ''){
                          setState(() => tasks.add(newTask));
                          taskField.text = '';
                          }
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Task',
                          contentPadding: EdgeInsets.only(right: 0,left: 15,top: 5),
                          suffixIcon: Container(
                            color: Colors.teal,
                            child: IconButton(icon: Icon(Icons.check,color: Colors.white,size: 30),
                            onPressed: () => taskFieldFocus.unfocus()),
                          )
                        ),
                      ),
                    ),
                    SizedBox(height: 50)
                  ],
                ),
              ),),
          ),
        ),
          bottomNavigationBar: GestureDetector(
            onTap: () async => await IdeaManager.addToDbAndSetAlarmIdea(
                  context: context,
                  ideaTitle: ideaTitle.text,
                  moreDetails: moreDetails.text,
                  tasks: tasks),
            child: Container(
              height: 65,
              color: DarkBlue,
              child: Center(
                child: Text('Save',style: Overpass.copyWith(fontSize: 32,color: Colors.white)),
              )),
          ),
      ),
    );
  }

  Widget _AllTasks() {
    return Column(
      children: [
        for(String task in tasks) 
        Row(
          children: [
          Icon(Icons.circle,color: Colors.grey),
          SizedBox(width: 25),
          Expanded(child: Container(child: Text(task))),
          IconButton(
          icon: Icon(CommunityMaterialIcons.close,color: Colors.grey),
          onPressed: (){
            setState(() =>tasks.remove(task));
            })
          ])]
    );
}
}
