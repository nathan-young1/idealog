import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/animatedListTile.dart';
import 'package:idealog/design/textStyles.dart';

void tasksDoesNotExistForThisPageFlushBar({required BuildContext context,required TaskPage pageCalledFrom}){
  
  Flushbar(
    icon: Icon(Icons.info, color: Colors.white),
    messageText: Text(
      /// find out if this flush bar was called from either completed page or high priority page.
      (pageCalledFrom == TaskPage.HIGH_PRIORITY)
        ?"No high priority task exists."
        :"No task has been completed yet."
        , style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_16, color: Colors.white)),
    animationDuration: Duration(seconds: 1),
    duration: Duration(seconds: 2),
    isDismissible: true,
  )..show(context);
}

/// Shows a snack bar to notify user of change in task list.
void notifyUserOfChangeInTaskList({required bool taskWasCompleted,required BuildContext context, TaskPage? pageCalledFrom})=> Flushbar(
            messageText: Text(
            /// check the page this was called from to determine the message to show.
            (taskWasCompleted)
              ? (pageCalledFrom == TaskPage.COMPLETED) ?"1 task was unchecked" :"1 task was completed"
              : "1 task was removed",
            style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_20, color: Colors.white)),
            icon: Icon(Icons.info, color: Colors.white),
            duration: Duration(seconds: 2),
            forwardAnimationCurve: Curves.linearToEaseOut,
            reverseAnimationCurve: Curves.linear,
            isDismissible: false,
          )..show(context);

void anErrorOccuredFlushBar({required BuildContext context})=> Flushbar(
            messageText: Text(
            "An error occured, perhaps your internet connection is weak.",
            style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_20, color: Colors.white)),
            icon: Icon(Icons.wifi_off, color: Colors.white),
            duration: Duration(seconds: 2),
            forwardAnimationCurve: Curves.linearToEaseOut,
            reverseAnimationCurve: Curves.linear,
            isDismissible: false,
          )..show(context);

void phoneCannotCheckBiometricFlushBar({required BuildContext context})=> Flushbar(
            messageText: Text(
            "This phone does not have a biometric authenticator.",
            style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_20, color: Colors.white)),
            icon: Icon(Icons.error, color: Colors.white),
            duration: Duration(seconds: 3),
            forwardAnimationCurve: Curves.linearToEaseOut,
            reverseAnimationCurve: Curves.linear,
            isDismissible: false,
          )..show(context);

