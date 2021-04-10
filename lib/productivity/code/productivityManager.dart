import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:provider/provider.dart';

List<Idea> getFavoriteTasks(BuildContext context){
  List<Idea> allIdeas = Provider.of<List<Idea>>(context);
  //sort the ideas by their completeTasks Length in descending order
  allIdeas.sort((a,b) => b.completedTasks.length.compareTo(a.completedTasks.length));
  // only take four of the ideas with the biggest task length
  Iterable<Idea> favoriteIdeas = allIdeas.take(4);
  return List<Idea>.from(favoriteIdeas);
}

  double getCompletionRate(BuildContext context){
  List<Idea> allIdeas = Provider.of<List<Idea>>(context);
  int uncompletedTasksLength = 0;
  int completedTasksLength = 0;
  allIdeas.forEach((idea) { 
    uncompletedTasksLength += idea.uncompletedTasks.length;
    completedTasksLength += idea.completedTasks.length;
  });

  int totalNumberOfTasks = uncompletedTasksLength + completedTasksLength;
  // first check that total number of tasks is not equal to zero to avoid division by zero error
  double completionRate = (totalNumberOfTasks != 0)?(completedTasksLength / totalNumberOfTasks):0.0;

  return completionRate;
}