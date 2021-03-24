import 'dart:math';

class Idea{
  int uniqueId;
  String ideaTitle;
  String? moreDetails;
  _Tasks? tasks;
  
  Idea({required this.ideaTitle,this.moreDetails,List<List<int>> tasksToCreate = const[],required this.uniqueId}){
    tasks = _Tasks(listOfTasksToCreate: tasksToCreate);
  }

  Idea.readFromDb({required this.ideaTitle,this.moreDetails,List<List<int>> completedTasks = const[],required this.uniqueId,List<List<int>> uncompletedTasks = const[]}){
    tasks = _Tasks.fromDb(completedTasks: completedTasks,uncompletedTasks: uncompletedTasks);
  }
}

class _Tasks{
  
  List<List<int>> completedTasks = [];
  List<List<int>> uncompletedTasks = [];

  List<List<int>> get allTasks => [...completedTasks,...uncompletedTasks];
  _Tasks({List<List<int>> listOfTasksToCreate = const[]}):uncompletedTasks = listOfTasksToCreate;
  _Tasks.fromDb({this.completedTasks = const[],this.uncompletedTasks = const[]});

  deleteTask(List<int> task){
    (uncompletedTasks.contains(task))
    ?uncompletedTasks.remove(task)
    :completedTasks.remove(task);
  }

  completeTask(List<int> task){
    uncompletedTasks.remove(task);
    completedTasks.add(task);
    }

  addNewTask(List<int> task)=>uncompletedTasks.add(task);
}