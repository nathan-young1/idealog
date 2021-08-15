import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:idealog/Databases/idealog-db/idealog_config.dart';
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/DoesNotExist.dart';
import 'package:idealog/SearchBar/SearchNotifier.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';
import 'NoTaskYet.dart';
import 'animatedListTile.dart';

/// The normal grouped list, when the page is not in reordering mode.
class GroupedList extends StatelessWidget { 
  GroupedList({required this.idea});
  final Idea idea;

  @override
  Widget build(BuildContext context) {
    
    return Consumer<SearchController>(
      builder: (context, searchController, _){
        /// All the lists filtered by the search term.
        List<Task> highPriorityTasks = idea.highPriority.where(searchTermExistsInTask).toList();
        List<Task> mediumPriorityTasks = idea.mediumPriority.where(searchTermExistsInTask).toList();
        List<Task> lowPriorityTasks = idea.lowPriority.where(searchTermExistsInTask).toList();

        if(highPriorityTasks.isEmpty && mediumPriorityTasks.isEmpty && lowPriorityTasks.isEmpty)
        // because grouped list is called by uncompletedTasks if it is empty show no tasks yet.
          return (idea.uncompletedTasks.isEmpty)? NoTaskYet(): DoesNotExistIllustration();
          
        return Column(
          children: [
            /// only show a priority section if it is not empty.
            if(highPriorityTasks.isNotEmpty) PriorityTasksInColumnView(priorityGroup: Priority_High, idea: idea),
            if(mediumPriorityTasks.isNotEmpty) PriorityTasksInColumnView(priorityGroup: Priority_Medium, idea: idea,),
            if(lowPriorityTasks.isNotEmpty) PriorityTasksInColumnView(priorityGroup: Priority_Low, idea: idea),
        ]
      );
    },
    );
  }
}




/// All tasks for a particular priorityGroup
class PriorityTasksInColumnView extends StatelessWidget{
  PriorityTasksInColumnView({this.priorityGroup, required this.idea,this.pageCalledFrom});

  // i am making priority group nullable so that i can reuse this widget in both highPriorityTasks and completedTasks.
  final int? priorityGroup;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final Idea idea;
  final TaskPage? pageCalledFrom;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          if(priorityGroup != null)Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text((priorityGroup == Priority_High)
            ?'High Priority'
            :(priorityGroup == Priority_Medium) ? 'Medium Priority' : 'Low Priority',
              style: overpass.copyWith(fontSize: 22, fontWeight: FontWeight.w500)),
          ),

          /// if the priority group is not given then this was called from completed tasks page.
          AnimatedList(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            initialItemCount: (priorityGroup!= null)
            ?idea.getListForPriorityGroup(priorityGroup).where(searchTermExistsInTask).toList().length
            :idea.completedTasks.where(searchTermExistsInTask).toList().length,
            key:  _listKey,
            itemBuilder: (context, index, animation){
              return AnimatedListTile(
              taskRow: (priorityGroup!= null)
              ?idea.getListForPriorityGroup(priorityGroup).where(searchTermExistsInTask).toList()[index]
              :idea.completedTasks.where(searchTermExistsInTask).toList()[index],
              idea: idea,
              index: index,
              animation: animation,
              isAnimating: false,
              context: context,
              pageCalledFrom: pageCalledFrom);
            },
          )
      ]);
  }

}


/// This is the list tile that is animated either in or out.
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
  return ListTile(
    leading: StatefulBuilder(
      builder: (context, setState) {
        return Transform.scale(
          scale: 1.3,
          child: Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith((states) => DarkBlue),
            value: checkboxValue,
           onChanged: (bool? value) async {
             if (!isAnimating){
               setState(()=> checkboxValue = value!);
               await Future.delayed(Duration(milliseconds: 200));
               await removeItem(taskRow: taskRow, checkboxWasClicked: true, index: index, idea: idea, context: context, pageCalledFrom: pageCalledFrom);
               }}),
        );
      }
    ),
    title: Text(taskRow.task),
    trailing: IconButton(icon: Icon(Icons.close),
     color: LightPink,
    onPressed: () async { 
      /// button should only work when this button is not animating.
      if(!isAnimating) await removeItem(taskRow: taskRow, checkboxWasClicked: false, index: index, idea: idea, context: context, pageCalledFrom: pageCalledFrom);
    })
    );
}


  
/// Shows a snack bar to notify user of change in task list.
void _notifyUserOfChange({required bool taskWasCompleted,required BuildContext context, TaskPage? pageCalledFrom})=> Flushbar(
            messageText: Text(
            /// check the page this was called from to determine the message to show.
            (taskWasCompleted)
              ? (pageCalledFrom == TaskPage.COMPLETED) ?"1 task was unchecked" :"1 task was completed"
              : "1 task was removed",
            style: overpass.copyWith(fontSize: 22)),
            duration: Duration(seconds: 2),
            forwardAnimationCurve: Curves.linearToEaseOut,
            reverseAnimationCurve: Curves.linear,
            isDismissible: false,
          )..show(context);


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
    _notifyUserOfChange(taskWasCompleted: checkboxWasClicked, context: context, pageCalledFrom: pageCalledFrom);

    /// Manually calls the grouped list to rebuild since it listens to the search controller.
    await Future.delayed(Duration(milliseconds: 400), ()=> SearchController.instance.notifyListeners());
     
  }
