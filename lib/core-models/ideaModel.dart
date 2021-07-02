import 'package:flutter/material.dart';
import 'package:idealog/global/typedef.dart';


class Idea extends TaskList{
  int? ideaId;
  String ideaTitle;
  String? moreDetails;
  
  Idea({required this.ideaTitle,this.moreDetails,required List<String> tasksToCreate}):super(tasksToCreate: tasksToCreate);

  Idea.readFromDb({required this.ideaTitle,this.moreDetails,required DBTaskList completedTasks,required this.ideaId,required DBTaskList uncompletedTasks}):super.fromDb(completedTasks: completedTasks,uncompletedTasks: uncompletedTasks);

  Idea.fromFirebaseJson({required Map<String, dynamic> json}):
  ideaId = json['ideaId'],
  ideaTitle = json['ideaTitle'],
  moreDetails = json['moreDetails'],
  super.fromDb(completedTasks: json['completedTasks'],uncompletedTasks: json['uncompletedTasks']);

  String? changeMoreDetail(String? newDetails)=> moreDetails= newDetails;

  Map<String, dynamic> toMap(){
    return {
        'ideaId': ideaId,
        'ideaTitle': ideaTitle,
        'moreDetails': moreDetails,
        'completedTasks': completedTasks.map((e) => e.toMap()).toList(),
        'uncompletedTasks': uncompletedTasks.map((e) => e.toMap()).toList()
    };
  }
}


abstract class TaskList with ChangeNotifier{
  
  List<Task> completedTasks = [];
  List<Task> uncompletedTasks = [];

  List<Task> get allTasks => [...completedTasks,...uncompletedTasks];
  double get percentIndicator {
        final totalNumberOfTasks = allTasks.length;
        //first check that the total number of tasks is not zero, so as not to have division by zero error
        // ignore: omit_local_variable_types
        final double percent = (totalNumberOfTasks != 0)?(completedTasks.length/totalNumberOfTasks)*100:0;
        return percent;
  }
  
  TaskList({required List<String> tasksToCreate})
    :this.uncompletedTasks = Task.createTasks(tasksToCreate);

  TaskList.fromDb({required this.completedTasks, required this.uncompletedTasks});

  void deleteTask(Task task){
    (uncompletedTasks.contains(task))
    ?uncompletedTasks.remove(task)
    :completedTasks.remove(task);
    notifyListeners();
  }

  void uncheckCompletedTask(Task task){
    completedTasks.remove(task);
    uncompletedTasks.add(task);
    notifyListeners();
  }

  void completeTask(Task task){
    uncompletedTasks.remove(task);
    completedTasks.add(task);
    notifyListeners();
    }

  void addNewTask(Task task){
  uncompletedTasks.add(task);
  notifyListeners();
  }
}


class Task {
  String task;
  int orderIndex;
  int? primaryKey;

  Task.fromDb({required this.task, required this.orderIndex, required this.primaryKey});
  Task({required this.task, required this.orderIndex,this.primaryKey});

  static DBTaskList createTasks (List<String> allTask){
    DBTaskList taskList = [];

    for(int i = 0; i< allTask.length; i++){
      Task newTask = Task(task: allTask[i], orderIndex: i);
      taskList.add(newTask);
    }
    return taskList;
  }

  Map toMap(){
    return {
      "task": task,
      "orderIndex": orderIndex,
      "primaryKey": primaryKey
    };
  }
}

