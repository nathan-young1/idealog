import 'dart:async';

import 'package:flutter/material.dart';
import 'package:idealog/Databases/idealog-db/idealog_config.dart';
import 'package:idealog/core-models/ideaModel.dart';

enum Direction {Up, Down}

class ReorderListController with ChangeNotifier{
  ReorderListController._();
  static ReorderListController instance = ReorderListController._();

  static late ValueNotifier<double> currentPaddingNotifier;

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
  void updateTasksOrderIndex(Idea idea){
    for(var i = 0; i < idea.uncompletedTasks.length; i++){
      if(idea.uncompletedTasks[i].orderIndex != i)
        idea.uncompletedTasks[i].orderIndex = i;
    }
  }

  /// Reorganize the list of tasks.
  void reorderList({required Task incomingTask, required Idea idea, required Task recieverTask, required int priorityGroup, required ValueNotifier<double> notifier}){
    // if the user release a draggable while scrolling do not do anything.
    if(scrollViewCanScroll) return;
    
    removePadding(notifier);
    _promoteTaskIfNecessary(incomingTask: incomingTask, priorityGroup: priorityGroup);
    
    int incomingIndex =  idea.uncompletedTasks.indexOf(incomingTask);
    int recieverIndex = idea.uncompletedTasks.indexOf(recieverTask);

    idea.uncompletedTasks.remove(incomingTask);
    
    if (incomingIndex < recieverIndex)
      idea.uncompletedTasks.insert(recieverIndex-1, incomingTask);
    else
      idea.uncompletedTasks.insert(recieverIndex, incomingTask);
  }

  /// Change the task priority if it was dragged into another priority group.
  void _promoteTaskIfNecessary({required Task incomingTask, required int priorityGroup}){
    if(incomingTask.priority != priorityGroup){
      incomingTask.priority = priorityGroup;
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
      startScrollTimer(scrollViewDirection: Direction.Down, scrollController: scrollController);
      autoAdjustScrollSpeed(scrollViewDirection: Direction.Down, dragScreenPositionInPercent: dragScreenPositionInPercent);

    } else if (userIsDraggingTaskUp && dragScreenPositionInPercent < 25){
      // Start scrolling up when the draggable is held at 25% of the screen.
      startScrollTimer(scrollViewDirection: Direction.Up, scrollController: scrollController);
      autoAdjustScrollSpeed(scrollViewDirection: Direction.Up, dragScreenPositionInPercent: dragScreenPositionInPercent);

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
  void autoAdjustScrollSpeed({required Direction scrollViewDirection, required double dragScreenPositionInPercent}){
    switch (scrollViewDirection){
      
      case Direction.Up:
        if(dragScreenPositionInPercent < 20)
          scrollSpeed = 20;
        else if (dragScreenPositionInPercent < 10)
          scrollSpeed = 30;
        else scrollSpeed = 15;
      break;

      case Direction.Down:
        if(dragScreenPositionInPercent > 80)
          scrollSpeed = 20;
        else if (dragScreenPositionInPercent > 90)
          scrollSpeed = 30;
        else scrollSpeed = 15;
        break;
    }
  }

  /// Automatically scroll the scroll view over a specified interval.
  void startScrollTimer({required Direction scrollViewDirection, required ScrollController scrollController}) {

    if(!scrollViewCanScroll){
      startScrolling();
    scrollTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      /// when scrolling remove the padding from the current drag target.
      removePadding(currentPaddingNotifier);
      /// if the scroll view has been stopped from scrolling then cancel the timer.
      if (!scrollViewCanScroll) timer.cancel();

      switch(scrollViewDirection){
        case Direction.Up: 
          if (scrollController.position.extentBefore > 0) scrollController.position.pointerScroll(-scrollSpeed);
          else timer.cancel();
        break;

        case Direction.Down: 
          if (scrollController.position.extentAfter > 0)  scrollController.position.pointerScroll(scrollSpeed);
          else timer.cancel();
        break;
      }

          });
    }
  }

//============================================================================================================================================//

  /// Increase padding if the incoming Task is not the same as the recieverTask.
  static void increasePadding({required ValueNotifier<double> notifier, required Task incomingTask, required Task recieverTask}){
    currentPaddingNotifier = notifier;
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
  void addTaskToBottomOfPriorityGroup({required Task incomingTask, required int priorityGroup, required Idea idea, required List<Task> groupTasks}){

    _promoteTaskIfNecessary(incomingTask: incomingTask, priorityGroup: priorityGroup);

      // if task is the only task in the priority group , and it drop in the container do not do anything.
      if(groupTasks.length == 1 && incomingTask == groupTasks.first) return;

      idea.uncompletedTasks.remove(incomingTask);

      if(groupTasks.isNotEmpty){
        // Add one to the index of the last task in other for new task to be added below it.
        int indexForNewTask = idea.uncompletedTasks.indexOf(groupTasks.last) + 1;
        idea.uncompletedTasks.insert(indexForNewTask, incomingTask);

      }else{

        switch(priorityGroup){

          case Priority_High:
            // if priority high is empty, then just add task to the beginning of the list.
            idea.uncompletedTasks.insert(0,incomingTask);
          break;

          case Priority_Medium:
            // if priority medium is empty then check if high priority is empty if yes add task to the zero index , else add task to plus one of the last high priority index.
            if(highPriorityTasks.isEmpty){
              idea.uncompletedTasks.insert(0,incomingTask);
            }else{
              int indexForNewTask = idea.uncompletedTasks.indexOf(highPriorityTasks.last) + 1;
              idea.uncompletedTasks.insert(indexForNewTask, incomingTask);
            }
          break;

          case Priority_Low:
            // if priority low is empty , just add to the end of the list the incoming task.
            idea.uncompletedTasks.add(incomingTask);
          break;
        }

      }
  }

}

