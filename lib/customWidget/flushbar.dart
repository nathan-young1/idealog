import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/animatedListTile.dart';

void tasksDoesNotExistForThisPageFlushBar({required BuildContext context,required TaskPage pageCalledFrom}){
  
  Flushbar(
    icon: Icon(Icons.info, color: Colors.white),
    messageText: Text(
      /// find out if this flush bar was called from either completed page or high priority page.
      (pageCalledFrom == TaskPage.HIGH_PRIORITY)
        ?"No high priority task exists."
        :"No task has been completed yet."
        , style: TextStyle(fontSize: 16, color: Colors.white)),
    animationDuration: Duration(seconds: 1),
    duration: Duration(seconds: 2),
    isDismissible: true,
  )..show(context);
}