import 'dart:isolate';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:idealog/customAppBar/appBar.dart';
import 'package:idealog/customInputDecoration/inputDecoration.dart';
import 'package:idealog/global/strings.dart';
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
  bool setDeadline = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight*1.2),
              child: CustomAppBar(title: 'ADD IDEA')),
        body: SingleChildScrollView(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.only(left: 15,right: 15),
              child: Column(
                children: [
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
                  CheckboxListTile(
                    title: Text('Set Deadline'),
                    value: setDeadline,
                    onChanged: (bool? value)=>setState(()=>setDeadline=value!)),
                  Visibility(
                    visible: setDeadline,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Deadline:'),
                        Container(
                          width: 200,
                          child: DateTimePicker(
                            dateHintText: 'Deadline',
                            dateLabelText: 'Deadline',
                            controller: deadline,
                            dateMask: 'd MMM, yyyy',
                            decoration: underlineAndFilled.copyWith(
                                suffixIcon: Icon(Icons.date_range),
                                labelText: 'dd-mm-year'
                              ),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                initialDate: DateTime.now(),
                              ),
                        ),
                      ],
                    ),
                  ),
                  Text('Add Tasks required for idea'),
                  Row(children: [
                    Icon(Icons.info),
                    Text('Press '),
                    Container(
                      color: Colors.grey,
                      child: Text('Enter'),
                    ),
                    Text('to add task.')
                  ],),
                  _allTasks(),
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
                    decoration: addTasks.copyWith(
                      labelText: 'Task',
                      suffixIcon: IconButton(icon: Icon(Icons.cancel),
                      onPressed: () => taskField.text = '')
                    ),
                  ),
                  ElevatedButton(onPressed: ()=>Navigator.pushReplacementNamed(context, addNewSchedulePage), child: Text('Next Page'))
                ],
              ),
            ),),
        ),
          bottomNavigationBar: Container(
            height: 50,
            color: Colors.green,
            child: Center(
              child: ElevatedButton(
                onPressed: () async => await addToDbAndSetAlarmIdea(
                ideaTitle: ideaTitle.text,
                deadlineInString: deadline.text,
                moreDetails: moreDetails.text,
                tasks: tasks),
                child: Text('Save')),
            ),),
      ),
    );
  }

  Widget _allTasks() {
    return Column(
      children: [
        for(String task in tasks) 
        Row(children: [
          Icon(Icons.circle),
          Container(child: Text(task)),
          IconButton(
          icon: Icon(Icons.cancel),
          onPressed: (){
            setState(() =>tasks.remove(task));
            })
          ])]
    );
}
}
