import 'package:flutter/cupertino.dart';

class Idea extends Tasks{
  int uniqueId;
  String ideaTitle;
  String? moreDetails;
  
  Idea({required this.ideaTitle,this.moreDetails,List<List<int>> tasksToCreate = const[],required this.uniqueId}):super(listOfTasksToCreate: tasksToCreate);

  Idea.readFromDb({required this.ideaTitle,this.moreDetails,List<List<int>> completedTasks = const[],required this.uniqueId,List<List<int>> uncompletedTasks = const[]}):super.fromDb(completedTasks: completedTasks,uncompletedTasks: uncompletedTasks);

  changeMoreDetail(String? newDetails)=> this.moreDetails= newDetails;
}


abstract class Tasks with ChangeNotifier{
  
  List<List<int>> completedTasks = [];
  List<List<int>> uncompletedTasks = [];

  List<List<int>> get allTasks => [...completedTasks,...uncompletedTasks];
  Tasks({List<List<int>> listOfTasksToCreate = const[]}):uncompletedTasks = listOfTasksToCreate;
  Tasks.fromDb({this.completedTasks = const[],this.uncompletedTasks = const[]});

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
