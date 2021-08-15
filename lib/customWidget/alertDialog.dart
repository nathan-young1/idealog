import 'package:flutter/material.dart';
import 'package:idealog/design/colors.dart';

enum DeleteDialog{Idea,Task,Multi_Select_Task}

AlertDialog progressAlertDialog = AlertDialog(
  title: Row(children: [
    CircularProgressIndicator(),
    SizedBox(width: 25),
    Text('Saving Data')
  ],),
);

Future<bool> showDeleteDialog({required BuildContext context}) async {
  AlertDialog deleteDialog = AlertDialog(
    title: Container(color: LightPink, child: Center(child: Text("Delete", style: TextStyle(fontSize: 18)))),
    content: Text("Do you want to delete this idea ?", style: TextStyle(fontSize: 22)),
    actions: [
      GestureDetector(
        onTap: ()=> Navigator.pop(context, false),
        child: Container(
          height: 40,
          width: 50,
          decoration: BoxDecoration(
            border: Border.all(width: 2),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Text('no')
        ),
      ),
      GestureDetector(
        onTap: ()=> Navigator.pop(context, true),
        child: Container(
          height: 40,
          width: 50,
          decoration: BoxDecoration(
            color: LightPink,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Text('yes', style: TextStyle(fontSize: 14, color: Colors.white))
        ),
      )
    ],
  );

  await showDialog(context: context, builder: (context)=> deleteDialog, barrierDismissible: true);
  return false;
}