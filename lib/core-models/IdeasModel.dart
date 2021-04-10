import 'package:flutter/material.dart';

class Idea extends Tasks{
  int uniqueId;
  String ideaTitle;
  String? moreDetails;
  
  Idea({required this.ideaTitle,this.moreDetails,required List<List<int>> tasksToCreate,required this.uniqueId}):super(listOfTasksToCreate: tasksToCreate);

  Idea.readFromDb({required this.ideaTitle,this.moreDetails,required List<List<int>> completedTasks,required this.uniqueId,required List<List<int>> uncompletedTasks}):super.fromDb(completedTasks: completedTasks,uncompletedTasks: uncompletedTasks);

  changeMoreDetail(String? newDetails)=> this.moreDetails= newDetails;
}


abstract class Tasks with ChangeNotifier{
  
  List<List<int>> completedTasks = [];
  List<List<int>> uncompletedTasks = [];

  List<List<int>> get allTasks => [...completedTasks,...uncompletedTasks];
  Tasks({required List<List<int>> listOfTasksToCreate}):uncompletedTasks = listOfTasksToCreate;
  Tasks.fromDb({required this.completedTasks,required this.uncompletedTasks});

  deleteTask(List<int> task){
    (uncompletedTasks.contains(task))
    ?uncompletedTasks.remove(task)
    :completedTasks.remove(task);
    notifyListeners();
  }

  uncheckCompletedTask(List<int> task){
    completedTasks.remove(task);
    uncompletedTasks.add(task);
    notifyListeners();
  }

  completeTask(List<int> task){
    uncompletedTasks.remove(task);
    completedTasks.add(task);
    notifyListeners();
    }

  addNewTask(List<int> task){
  uncompletedTasks.add(task);
  notifyListeners();}
}
