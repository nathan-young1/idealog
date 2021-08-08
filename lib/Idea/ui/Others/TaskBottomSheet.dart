import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LengthLimitingTextInputFormatter;
import 'package:idealog/Databases/idealog-db/idealog_config.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';

// The priority is stored outside here because show bottom modal always rebuilds the entire class.
int dropDownPriority = Priority_Medium;

// ignore: must_be_immutable
class AddTaskBottomSheet extends StatelessWidget {

  AddTaskBottomSheet(this.addBottomSheetTaskToList,{required this.taskField, required this.formKey, List<String>? preExistingTasks_Lowercase}){
    // if the preExistingTasks were given, then add to alreadyAddedTasks list tracker.
      alreadyAddedTasks = preExistingTasks_Lowercase ?? [];
  }

  Function(Task task) addBottomSheetTaskToList;
  /// Use this list to track the task(String) that has been added already, or exists in idea object.
  late List<String> alreadyAddedTasks;

  final GlobalKey<FormState> formKey;
  final TextEditingController taskField;
  final FocusNode taskFieldFocus = FocusNode();

  void _addTaskToList(){
    if(taskField.text != '' && formKey.currentState!.validate()){
      
      Task newTask = Task()
                      ..priority = dropDownPriority
                      ..task = taskField.text;

      // Calls closure function that adds task to parent.   
      addBottomSheetTaskToList(newTask);

      // Track the added task(String).
      alreadyAddedTasks.add(newTask.task.trim().toLowerCase());
      
      // Clear the keyboard
      taskField.clear();
      }
  }

  void closeBottomSheet(BuildContext context){
    Navigator.pop(context);
    // Clear the keyboard
    taskField.clear();
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  GestureDetector(
                    onTap: ()=> closeBottomSheet(context),
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(color: DarkRed, width: 2),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Icon(Icons.close, size: 24, color: DarkRed),
                    ),
                  ),
                    
                  Text('New Task',style: overpass.copyWith(fontSize: 25)),
                    
                  ElevatedButton.icon(onPressed: ()=> _addTaskToList(),
                   icon: Icon(Icons.add), label: Text('Add',style: TextStyle(fontSize: 20)),
                   style: ButtonStyle(
                     backgroundColor: MaterialStateProperty.resolveWith((states) => DarkBlue)
                   ),
                   )
                ],),
              ),
          
              Text('Set Priority', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
              SizedBox(height: 10),
              StatefulBuilder(
                builder: (context, _setState) {
                  
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: elevatedBoxDecoration.copyWith(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: dropDownPriority,
                        items: [
                          DropdownMenuItem(child: Text("High"),value: Priority_High),
                          DropdownMenuItem(child: Text("Medium"),value: Priority_Medium),
                          DropdownMenuItem(child: Text("Low"),value: Priority_Low)
                        ],
                        onChanged: (int? value)=> _setState(()=> dropDownPriority = value!)),
                    ),
                  );
                }
              ),
              
              SizedBox(height: 30),
              Text('Task:', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
              SizedBox(height: 10),
              Container(
                decoration: elevatedBoxDecoration,
                child: Focus(
                  onFocusChange: (hasFocus){
                    // if keyboard is open and textfield does not have focus give it focus,
                    // so that dropmenu does not close the keyboard.
                    if(!hasFocus && MediaQuery.of(context).viewInsets.bottom > 0)
                    taskFieldFocus.requestFocus();
                    
                  },
                  child: TextFormField(
                    controller: taskField,
                    focusNode: taskFieldFocus,
                    keyboardType: TextInputType.text,
                     inputFormatters:[
                      LengthLimitingTextInputFormatter(500),
                    ],
                    validator: (value){
                      if(alreadyAddedTasks.contains(value!.trim().toLowerCase())) return 'Task already exists';
                      return null;
                    },
                    minLines: 3,
                    maxLines: null,
                    style: TextStyle(fontSize: 18),
                    decoration: formTextField.copyWith(hintText: 'Task')
                  ),
                ),
              ),
              SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}
