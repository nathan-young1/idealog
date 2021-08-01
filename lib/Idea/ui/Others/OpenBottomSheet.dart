import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/Others/TaskBottomSheet.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';

class OpenBottomSheet extends StatelessWidget {

  OpenBottomSheet(this.addBottomSheetTaskToList);
  final Function(Task task) addBottomSheetTaskToList;
  final TextEditingController taskField = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () async { 
        // close the keyboard if open , before opening bottom sheet
        FocusScope.of(context).unfocus();
        await showModalBottomSheet(
                enableDrag: false,
                isScrollControlled: true,
                isDismissible: false,
                context: context,
                builder: (BuildContext context) =>
                          AddTaskBottomSheet(addBottomSheetTaskToList, taskField: taskField)
                );
                },
                
      child: Container(
        decoration: elevatedBoxDecoration,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(  
                padding: EdgeInsets.only(left: 20),
                height: 50,
                color: Colors.white,
                child: Align(
                  alignment: Alignment(-1, 0),
                  child: Text('New Task', style: poppins.copyWith(fontSize: 20)))
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 50,
                color: LightPink,
                child: Icon(Icons.add,size: 35, color: Colors.white),
              ),
            )
          ],
        )
      ),
    );
  }
}
