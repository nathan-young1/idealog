import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:provider/provider.dart';

class ProductivityManager{

    final BuildContext context;
// Intialize the buildcontext for all methods of the class
    ProductivityManager({required this.context});

    List<IdeaModel> getFavoriteTasks(){
      var allIdeas = Provider.of<List<IdeaModel>>(context);
      //sort the ideas by their completeTasks Length in descending order
      allIdeas.sort((a,b) => b.completedTasks.length.compareTo(a.completedTasks.length));
      // only take four of the ideas with the biggest task length
      var favoriteIdeas = allIdeas.take(3);
      return List<IdeaModel>.from(favoriteIdeas);
    }

    double getCompletionRate(){
    var allIdeas = Provider.of<List<IdeaModel>>(context);
    var uncompletedTasksLength = 0;
    var completedTasksLength = 0;
    allIdeas.forEach((idea) { 
      uncompletedTasksLength += idea.uncompletedTasks.length;
      completedTasksLength += idea.completedTasks.length;
    });

    var totalNumberOfTasks = uncompletedTasksLength + completedTasksLength;
    // first check that total number of tasks is not equal to zero to avoid division by zero error
    var completionRate = (totalNumberOfTasks != 0)?(completedTasksLength / totalNumberOfTasks):0.0;

    return completionRate;
  }
}