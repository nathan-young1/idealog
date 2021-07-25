import 'package:flutter/material.dart';
import 'package:idealog/Databases/idealog-db/idealog_config.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';

// ignore: must_be_immutable
class AddTaskBottomSheet extends StatelessWidget {

  AddTaskBottomSheet(this.idea);
  final Idea idea;

  final TextEditingController taskField = TextEditingController();
  final FocusNode taskFieldFocus = FocusNode();
  int dropDownPriority = Priority_Medium;

  void _AddTaskToList(){
    if(taskField.text != ''){
      // Just create the task with priority and task then use the uncompletedTasks length as the order index.
      Task newTask = Task.test()
                      ..orderIndex = idea.uncompletedTasks.length
                      ..priority = dropDownPriority
                      ..task = taskField.text;

      idea.addNewTask(newTask);
      
      // Clear the keyboard
      taskField.clear();
      }
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                GestureDetector(
                  onTap: ()=> Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      border: Border.all(color: DarkRed, width: 2),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Icon(Icons.close, size: 25, color: DarkRed),
                  ),
                ),
        
                Text('New Task',style: overpass.copyWith(fontSize: 25)),
        
                ElevatedButton.icon(onPressed: ()=> _AddTaskToList(),
                 icon: Icon(Icons.add), label: Text('Add',style: TextStyle(fontSize: 20)),
                 style: ButtonStyle(
                   backgroundColor: MaterialStateProperty.resolveWith((states) => DarkBlue)
                 ),
                 )
              ],),
            ),
        
            Text('Set Priority', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
            StatefulBuilder(
              builder: (context, _setState) {
                
                return DropdownButton<int>(
                  value: dropDownPriority,
                  items: [
                    DropdownMenuItem(child: Text("High"),value: Priority_High),
                    DropdownMenuItem(child: Text("Medium"),value: Priority_Medium),
                    DropdownMenuItem(child: Text("Low"),value: Priority_Low)
                  ],
                  onChanged: (int? value)=> _setState(()=> dropDownPriority = value!));
              }
            ),
            
            SizedBox(height: 30),
            Text('Task:', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                BoxShadow(offset: Offset(0,0),blurRadius: 10,color: Colors.black.withOpacity(0.2))
              ]
              ),
              width: MediaQuery.of(context).size.width * 0.8,
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
                  minLines: 2,
                  maxLines: null,
                  style: TextStyle(fontSize: 18),
                  decoration: underlineAndFilled.copyWith(
                    hintText: 'Task',
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none
                    ),
                    focusedBorder: InputBorder.none,
                    
                  ),
                ),
              ),
            ),
            SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}
