import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:idealog/customAppBar/appBar.dart';
import 'package:idealog/customDecoration/boxDecoration.dart';
import 'package:idealog/customDecoration/colors.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/idea/code/ideaManager.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class NewIdea extends StatefulWidget {
  @override
  _NewIdeaState createState() => _NewIdeaState();
}

class _NewIdeaState extends State<NewIdea> {
  List<String> tasks = [];
  TextEditingController taskField = TextEditingController();
  TextEditingController deadline = TextEditingController();
  TextEditingController ideaTitle = TextEditingController();
  TextEditingController moreDetails = TextEditingController();
  FocusNode taskFieldFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: lightModeBackgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Form(
              child: Padding(
                padding: const EdgeInsets.only(left: 20,right: 15),
                child: Column(
                  children: [
                    CustomAppBar(title: 'ADD IDEA'),
                    TextFormField(
                      controller: ideaTitle,
                      decoration: underlineAndFilled.copyWith(
                        labelText: 'Idea title',
                        prefixIcon: Icon(Icons.text_fields)
                      )
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: moreDetails,
                      maxLines: null,
                      minLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: underlineAndFilled.copyWith(
                        labelText: 'More details on idea...'
                      ),
                    ),
                    SizedBox(height: 25),
                    Text('Tasks required for idea',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700)),
                    SizedBox(height: 15),
                    Row(children: [
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
                    SizedBox(height: 15),
                    _allTasks(),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: taskField,
                      focusNode: taskFieldFocus,
                      onFieldSubmitted: (newTask){
                        taskFieldFocus.requestFocus();
                        if(newTask != ''){
                        setState(() => tasks.add(newTask));
                        taskField.text = '';
                        }
                      },
                      decoration: underlineAndFilled.copyWith(
                        labelText: 'Task',
                        suffixIcon: IconButton(icon: Icon(Icons.cancel),
                        onPressed: () => taskField.text = '')
                      ),
                    ),
                  ],
                ),
              ),),
          ),
            bottomNavigationBar: GestureDetector(
              onTap: () async => await addToDbAndSetAlarmIdea(
                    context: context,
                    ideaTitle: ideaTitle.text,
                    moreDetails: moreDetails.text,
                    tasks: tasks),
              child: Container(
                height: 50,
                color: lightModeBottomNavColor.withOpacity(1),
                child: Center(
                  child: Text('Save',style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.w700)),
                )),
            ),
        ),
      ),
    );
  }

  Widget _allTasks() {
    return Column(
      children: [
        for(String task in tasks) 
        Row(children: [
          Icon(Icons.circle),
          Expanded(child: Container(child: Text(task))),
          IconButton(
          icon: Icon(Icons.cancel),
          onPressed: (){
            setState(() =>tasks.remove(task));
            })
          ])]
    );
}
}
