import 'package:flutter/material.dart';
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/SearchBar/SearchNotifier.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/customWidget/flushbar.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';

enum TaskPage{UNCOMPLETED,COMPLETED,HIGH_PRIORITY}


// ignore: non_constant_identifier_names
Widget AnimatedListTile({
  required Task taskRow,
  required Idea idea,
  required int index,
  required Animation<double> animation,
  required bool isAnimating,
  required BuildContext context,
  TaskPage? pageCalledFrom}){
  
  /// the intial checkbox value should depend on the page this method was called from.
  bool checkboxValue = (pageCalledFrom == TaskPage.COMPLETED);
  return IgnorePointer(
    // ignore touch if list tile is animating.
    ignoring: isAnimating,
    child: ListTile(
      leading: StatefulBuilder(
        builder: (context, setState) {
          return Transform.scale(
            scale: 1.3,
            child: Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith((states) => (pageCalledFrom == TaskPage.COMPLETED) ?completedTasksColor :Theme.of(context).bottomNavigationBarTheme.backgroundColor),
              value: checkboxValue,
             onChanged: (bool? value) async {
                 setState(()=> checkboxValue = value!);
                 await Future.delayed(Duration(milliseconds: 200));
                 await removeItem(taskRow: taskRow, checkboxWasClicked: true, index: index, idea: idea, context: context, pageCalledFrom: pageCalledFrom);
                 }),
          );
        }
      ),
      title: Text(taskRow.task, style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.small)),
      trailing: IconButton(icon: Icon(Icons.close),
       color: LightPink,
      onPressed: () async { 
        /// button should only work when this button is not animating.
        await removeItem(taskRow: taskRow, checkboxWasClicked: false, index: index, idea: idea, context: context, pageCalledFrom: pageCalledFrom);
      })
      ),
  );
}



/// Remove the task from the idea while animating it out of the list.
  Future<void> removeItem({
  required Task taskRow,
  /// i am going to use this to know whether to delete the task or to (completed or check it).
  required bool checkboxWasClicked,
  required int index,
  required Idea idea,
  required BuildContext context,
  /// i will use this variable to know if removeitem was called from completed task page so that i can uncheck it instead of calling complete task.
  TaskPage? pageCalledFrom
  }) async {

    final Tween<Offset> _slideOutTween = Tween<Offset>(begin: Offset(1,0), end: Offset(0,0));

    if(checkboxWasClicked) {
      // if this was called from completed page then uncheck the task otherwise complete it.
      if(pageCalledFrom == TaskPage.COMPLETED) await IdeaManager.uncheckCompletedTask(idea, taskRow);
      else await IdeaManager.completeTask(idea, taskRow);
      }

    else await IdeaManager.deleteTask(idea, taskRow);

    AnimatedListRemovedItemBuilder removedItemBuilder = (context, animation) => 
          SlideTransition(
            // if the task was completed animate it out to the left else animate it out to the right.
            textDirection: (checkboxWasClicked) ?TextDirection.rtl :TextDirection.ltr,
            position: animation.drive(_slideOutTween),
            child: AnimatedListTile(taskRow: taskRow, idea: idea, index: index, isAnimating: true, animation: animation, context: context, pageCalledFrom: pageCalledFrom),
            );

    /// call the animated list to start the animation.
    AnimatedList.of(context).removeItem(index, removedItemBuilder,duration: Duration(milliseconds: 400));
    notifyUserOfChangeInTaskList(taskWasCompleted: checkboxWasClicked, context: context, pageCalledFrom: pageCalledFrom);

    /// Manually calls the grouped list to rebuild since it listens to the search controller.
    await Future.delayed(Duration(milliseconds: 400), ()=> SearchController.instance.notifyListeners());
     
  }
