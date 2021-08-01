import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideaModel.dart';

class ReorderListController with ChangeNotifier{
  ReorderListController._();
  static ReorderListController instance = ReorderListController._();


  bool _draggableIsGoingUp = false;

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

  /// Scroll the page in sync with the draggable.
  void scrollPageWithDraggable({required ScrollController scrollController, required DragUpdateDetails dragUpdateDetails, required BuildContext context}){
    updateDraggableDirection(dragUpdateDetails);
                    
    double screenHeight = MediaQuery.of(context).size.height;
    double scrollPosition = dragUpdateDetails.globalPosition.dy;
    double dragScreenPositionInPercent = scrollPosition/screenHeight * 100;
    double extentBefore = scrollController.position.extentBefore;
    double extentAfter = scrollController.position.extentAfter;
    
    // Start scrolling down when draggable widget is at 30 percent of the screen and there is content below the view port.
    if (!userIsDraggingTaskUp && dragScreenPositionInPercent > 30 && extentAfter > 0){
      scrollController.position.pointerScroll(dragUpdateDetails.delta.dy);
    }else if(userIsDraggingTaskUp && dragScreenPositionInPercent < 70 && extentBefore > 0){
      // Start scrolling up when draggable widget is at 70 percent of the screen and there is content above the view port.
      scrollController.position.pointerScroll(dragUpdateDetails.delta.dy);
    }
  }

  /// Increase padding if the incoming Task is not the same as the recieverTask.
  static void increasePadding({required ValueNotifier<double> notifier, required Task incomingTask, required Task recieverTask}){
    if(incomingTask != recieverTask){
      if(notifier.value == 0.0){
        notifier.value = 40;
      }
    }
  }

  /// Remove the padding on the recieving widget.
  static void removePadding(ValueNotifier<double> notifier)=> notifier.value = 0;

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

}

