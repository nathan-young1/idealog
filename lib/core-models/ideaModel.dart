import 'package:flutter/material.dart';
import 'package:idealog/Databases/idealog-db/idealog_config.dart';
import 'package:idealog/global/typedef.dart';


class Idea extends TaskList{
  int? ideaId;
  // Made ideaTitle nullable
  late String ideaTitle;
  String? moreDetails;
  bool isFavorite = false;

  Idea.test():super.test();

  
  Idea({required this.ideaTitle,this.moreDetails,required List<String> tasksToCreate}):super(tasksToCreate: tasksToCreate);

  Idea.readFromDb({required this.ideaTitle,this.moreDetails,required DBTaskList completedTasks,required this.ideaId,required DBTaskList uncompletedTasks}):super.fromDb(completedTasks: completedTasks,uncompletedTasks: uncompletedTasks);

  Idea.fromJson({required Map<String, dynamic> json}):
  ideaId = json['ideaId'],
  ideaTitle = json['ideaTitle'],
  moreDetails = json['moreDetails'],
  isFavorite = json['favorite'],
  super.fromDb(completedTasks: _jsonObject_To_Task(json['completedTasks']),uncompletedTasks: _jsonObject_To_Task(json['uncompletedTasks']));

  String? changeMoreDetail(String? newDetails)=> moreDetails= newDetails;

  void makeFavorite()=> isFavorite = true;
  void unFavorite()=> isFavorite = false;

  Map<String, dynamic> toMap(){
    return {
        'ideaId': ideaId,
        'ideaTitle': ideaTitle,
        'moreDetails': moreDetails,
        'favorite': isFavorite,
        'completedTasks': _taskToMap(completedTasks),
        'uncompletedTasks': _taskToMap(uncompletedTasks)
    };
  }

  List<Map> _taskToMap(List<Task> tasks)=> tasks.map((e)=> e.toMap()).toList();

  // ignore: non_constant_identifier_names
  static List<Task> _jsonObject_To_Task(List jsonObject) =>
            jsonObject.map((e) => Task.fromJson(json: e)).toList();
  
}


abstract class TaskList with ChangeNotifier{
  
  List<Task> completedTasks = [];
  List<Task> uncompletedTasks = [];
  List<Task> highPriority = [];
  List<Task> mediumPriority = [];
  List<Task> lowPriority = [];

  List<Task> get allTasks => [...completedTasks,...uncompletedTasks];
  double get percentIndicator {
        final totalNumberOfTasks = allTasks.length;
        //first check that the total number of tasks is not zero, so as not to have division by zero error
        // ignore: omit_local_variable_types
        final double percent = (totalNumberOfTasks != 0)?(completedTasks.length/totalNumberOfTasks)*100:0;
        return percent;
  }
  
  TaskList.test();
  TaskList({required List<String> tasksToCreate}){
    this.uncompletedTasks = Task.createTasks(tasksToCreate);
    putTasksInTheirPriorityList();
  }

  TaskList.fromDb({required this.completedTasks, required this.uncompletedTasks}){
    putTasksInTheirPriorityList();
  }
  
  TaskList.fromJson({required List<Map<String, dynamic>> completedTasks, required List<Map<String, dynamic>> uncompletedTasks}){
    this.completedTasks = completedTasks.map((e) => Task.fromJson(json: e)).toList();
    this.uncompletedTasks = uncompletedTasks.map((e) => Task.fromJson(json: e)).toList();
    putTasksInTheirPriorityList();
  }

  /// Put the uncompleted tasks into their varying list based on their priority group.
  void putTasksInTheirPriorityList(){
    highPriority = this.uncompletedTasks.where((task) => task.priority == Priority_High).toList();
    mediumPriority = this.uncompletedTasks.where((task) => task.priority == Priority_Medium).toList();
    lowPriority = this.uncompletedTasks.where((task) => task.priority == Priority_Low).toList();
  }
  

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
    getListForPriorityGroup(task.priority!).add(task);
    notifyListeners();
  }

  /// return the corresponding list for the priority group.
  List<Task> getListForPriorityGroup(priorityGroup){
    switch(priorityGroup){
      case Priority_High:
        return highPriority;
      case Priority_Medium:
        return mediumPriority;
      case Priority_Low:
        return lowPriority;

      default:
        return[];
    }
  }


  /// Removes the task from the previous priorityGroup when move across priorityGroups.
  void deleteTaskFromGroup(Task incomingTask){
    getListForPriorityGroup(incomingTask.priority!).remove(incomingTask);
    notifyListeners();
  }
  
}


class Task {
  late String task;
  late int orderIndex;
  int? primaryKey;
  int? priority;

  Task.test();

  Task.fromDb({required this.task, required this.orderIndex, required this.primaryKey});
  Task.jj({required this.task, required this.orderIndex,this.primaryKey, required this.priority});
  Task({required this.task, required this.orderIndex,this.primaryKey});
  Task.fromJson({required Map<String, dynamic> json}):
    this.task = json['task'],
    this.orderIndex = json['orderIndex'],
    this.primaryKey = json['primaryKey'],
    this.priority = json['priority'];

  static DBTaskList createTasks(List<String> allTask){
    DBTaskList taskList = [];

    for(int i = 0; i< allTask.length; i++){
      // Task newTask = Task(task: allTask[i], orderIndex: i);
      // taskList.add(newTask);
    }
    return taskList;
  }

  Map toMap(){
    return {
      "task": task,
      "orderIndex": orderIndex,
      "primaryKey": primaryKey,
      "priority": priority
    };
  }
}

