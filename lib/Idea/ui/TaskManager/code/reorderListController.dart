import 'dart:async';
import 'package:flutter/material.dart';
import 'package:idealog/Databases/idealog-db/idealog_Db.dart';
import 'package:idealog/core-models/ideaModel.dart';

enum DragDirection {Up, Down}

class ReorderListController with ChangeNotifier{
  ReorderListController._();
  static ReorderListController instance = ReorderListController._();

  /// Checks if the page tasks is in reordering mode.
  bool reOrderIsActive = false;
  /// Changes the states of the reorderable to true thereby starting reordering mode.
  void enableReordering(){reOrderIsActive = true; notifyListeners();}
  /// Changes the states of the reorderable to false thereby stoping reordering mode.
  void disableReordering(){reOrderIsActive = false; notifyListeners();}

  bool _draggableIsGoingUp = false;
  /// Use this to track high priority task.
  List<Task> highPriorityTasks = [];
  /// Stores the timer that controls the custom scrolling.
  Timer? scrollTimer;

  void setHighPriorityTasks(List<Task> highPriorityTasks)=> this.highPriorityTasks = highPriorityTasks;

  /// if the user is dragging the task upwards.
  bool get userIsDraggingTaskUp => _draggableIsGoingUp;

  /// Updates the draggable direction only if there was a change in direction.
  void updateDraggableDirection(DragUpdateDetails dragUpdateDetails){
    bool isGoingUp = dragUpdateDetails.delta.direction.isNegative ? true : false;

    // only update if there was a change in direction.
    if (isGoingUp != _draggableIsGoingUp){
      _draggableIsGoingUp = isGoingUp;
      notifyListeners();
    }
  }

  /// Make sure the orderIndex of every task, match their list index.
  Future<void> updateAndSaveTaskOrderIndex(Idea idea, ReorderListController reorderListController) async {
    
    for(var i = 0; i < idea.uncompletedTasks.length; i++){
      Task currentTaskInIteration = idea.uncompletedTasks[i];
      // Get the object reference to the Priority Group of this task.
      List<Task> listObjRef = idea.getListForPriorityGroup(currentTaskInIteration.priority);
      // Get this task index in it's priority group.
      int indexInListObjRef = listObjRef.indexOf(currentTaskInIteration);

      // If the order index of this task is not equal to it's index in the priority group list, then update it's order index.
      if(currentTaskInIteration.orderIndex != indexInListObjRef){
        currentTaskInIteration.orderIndex = indexInListObjRef;
      }

      // Save the new index in the database.
      await IdealogDb.instance.updateOrderIndexForTaskInDb(
        taskRowWithNewIndex: currentTaskInIteration,
        ideaPrimaryKey: idea.ideaId!);
    }

    // Then off the reordering state.
    reorderListController.disableReordering();
    // Then sort all list's by their order index.
    idea.sortAllListByOrderIndex();
  }

  /// Reorganize the list of tasks.
  Future<void> reorderList({required Task incomingTask, required Idea idea, required Task recieverTask, required int priorityGroup, required ValueNotifier<double> notifier}) async {
    // if the user release a draggable while scrolling do not do anything.
    if(scrollViewCanScroll) return;
    
    removePadding(notifier);
    await _removeFromList_PromoteIfNeeded(incomingTask: incomingTask, priorityGroup: priorityGroup, idea: idea);

    int recieverIndex = idea.getListForPriorityGroup(priorityGroup).indexOf(recieverTask);
    // The recieverIndex will be -1(does not exist), if the task was dropped on it's 'ChildWhenDragging Widget'.
    if (recieverIndex == -1)  idea.getListForPriorityGroup(priorityGroup).insert(0, incomingTask);
    else  idea.getListForPriorityGroup(priorityGroup).insert(recieverIndex, incomingTask);

    // notify changes made.
    idea.notifyListeners();
  }

  /// Change the task priority if it was dragged into another priority group, and delete the task from the previous priority group if there was any.
  // ignore: non_constant_identifier_names
  static Future<void> _removeFromList_PromoteIfNeeded({required Task incomingTask, required int priorityGroup, required Idea idea}) async {
    idea.deleteTaskFromGroup(incomingTask); /* note this will delete in the current priority group because it deletes based on task.priority.*/
    if(incomingTask.priority != priorityGroup){
      incomingTask.priority = priorityGroup;
      await IdealogDb.instance.updatePriorityForTaskInDb(taskRowWithNewIndex: incomingTask, ideaPrimaryKey: idea.ideaId!);
    }
  }

// =============================================================SCROLL CONTROLLER==================================================//
  /// Scroll the page in sync with the draggable.
  void scrollPageWithDraggable({required ScrollController scrollController, required DragUpdateDetails dragUpdateDetails, required BuildContext context}){
    updateDraggableDirection(dragUpdateDetails);
                    
    double screenHeight = MediaQuery.of(context).size.height;
    double scrollPosition = dragUpdateDetails.globalPosition.dy;
    double dragScreenPositionInPercent = scrollPosition/screenHeight * 100;

    // Start scrolling down when the draggable is held at 75% of the screen.
    if (!userIsDraggingTaskUp && dragScreenPositionInPercent > 75){
      startScrollTimer(scrollViewDirection: DragDirection.Down, scrollController: scrollController);
      autoAdjustScrollSpeed(scrollViewDirection: DragDirection.Down, dragScreenPositionInPercent: dragScreenPositionInPercent);

    } else if (userIsDraggingTaskUp && dragScreenPositionInPercent < 25){
      // Start scrolling up when the draggable is held at 25% of the screen.
      startScrollTimer(scrollViewDirection: DragDirection.Up, scrollController: scrollController);
      autoAdjustScrollSpeed(scrollViewDirection: DragDirection.Up, dragScreenPositionInPercent: dragScreenPositionInPercent);

    } else if (scrollViewCanScroll) stopScrolling();
    
  }

  /// Controls whether our custom scroller can scroll or not.
  bool scrollViewCanScroll = false;
  /// The amount in height the custom scroller scrolls by, these and the interval of the scroll timer determines the scroll speed.
  double scrollSpeed = 15;


  /// Disable the custom scrolling of the scroll view.
  void stopScrolling()=> scrollViewCanScroll = false;
  /// Enable the custom scrolling of the scroll view.
  void startScrolling()=> scrollViewCanScroll = true;

  /// Adjust the scroll speed based on the user's position on the screen while scrolling.
  void autoAdjustScrollSpeed({required DragDirection scrollViewDirection, required double dragScreenPositionInPercent}){
    switch (scrollViewDirection){
      
      case DragDirection.Up:
        if(dragScreenPositionInPercent < 20)
          scrollSpeed = 20;
        else if (dragScreenPositionInPercent < 10)
          scrollSpeed = 30;
        else scrollSpeed = 15;
      break;

      case DragDirection.Down:
        if(dragScreenPositionInPercent > 80)
          scrollSpeed = 20;
        else if (dragScreenPositionInPercent > 90)
          scrollSpeed = 30;
        else scrollSpeed = 15;
        break;
    }
  }

  /// Automatically scroll the scroll view over a specified interval.
  void startScrollTimer({required DragDirection scrollViewDirection, required ScrollController scrollController}) {

    if(!scrollViewCanScroll){
      startScrolling();
    scrollTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      /// if the scroll view has been stopped from scrolling then cancel the timer.
      if (!scrollViewCanScroll) timer.cancel();

      switch(scrollViewDirection){
        case DragDirection.Up: 
          if (scrollController.position.extentBefore > 0) scrollController.position.pointerScroll(-scrollSpeed);
          else {timer.cancel(); stopScrolling();}
        break;

        case DragDirection.Down: 
          if (scrollController.position.extentAfter > 0)  scrollController.position.pointerScroll(scrollSpeed);
          else {timer.cancel(); stopScrolling();}
        break;
      }

          });
    }
  }



//============================================================================================================================================//

  /// Increase padding if the incoming Task is not the same as the recieverTask.
  static void increasePadding({required ValueNotifier<double> notifier, required Task incomingTask, required Task recieverTask}){
    if(incomingTask != recieverTask){
      if(notifier.value == 0.0){
        notifier.value = 40;
      }
    }
  }

  /// Remove the padding on the recieving widget.
  static void removePadding(ValueNotifier<double> notifier)=> (notifier.value != 0) ? notifier.value = 0 : null;

  /// Returns an EdgeInsets specifying where to add padding to.
  EdgeInsets animatePaddingTo({required double padding, required int currentIndex}){
    EdgeInsets result;

      if(userIsDraggingTaskUp){
        result = EdgeInsets.only(top: padding);
      } else if (!userIsDraggingTaskUp && currentIndex == 0){
        result = EdgeInsets.only(top: padding);
      } else if (currentIndex == 0){
        result = EdgeInsets.only(bottom: padding);
      } else {
        result = EdgeInsets.only(top: padding);
      }

      return result;
  }

  /// Add a task to the bottom of a priorityGroup.
  Future<void> addTaskToBottomOfPriorityGroup({required Task incomingTask, required int priorityGroup, required Idea idea, required List<Task> groupTasks}) async {

    // if task is the only task in the priority group , and it drop in the container do not do anything.
    if(groupTasks.length == 1 && incomingTask == groupTasks.first) return;

    // Note: First delete the task from it's current priority group.
    idea.deleteTaskFromGroup(incomingTask);
    // if the task priority is not equal to the current priority group, then promote it.
    if (incomingTask.priority != priorityGroup) {
      incomingTask.priority = priorityGroup;
      await IdealogDb.instance.updatePriorityForTaskInDb(taskRowWithNewIndex: incomingTask, ideaPrimaryKey: idea.ideaId!);
    }

    idea.getListForPriorityGroup(priorityGroup).add(incomingTask);

      // notify all listeners of change.
      idea.notifyListeners();
  }

}

