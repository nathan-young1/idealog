import 'package:flutter/material.dart';
import 'package:idealog/Databases/idealog-db/idealog_config.dart';
import 'package:idealog/global/typedef.dart';


class Idea extends TaskList{
  int? ideaId;
  late String ideaTitle;
  String? moreDetails;
  bool isFavorite = false;

  Idea({required this.ideaTitle,this.moreDetails,required List<Task> tasksToCreate})
      :super(tasksToCreate: tasksToCreate);

  Idea.readFromDb({required this.ideaId, required this.ideaTitle, required this.moreDetails,required this.isFavorite, required DBTaskList completedTasks,required DBTaskList uncompletedTasks})
      :super.fromDb(completedTasks: completedTasks,uncompletedTasks: uncompletedTasks);

  Idea.fromJson({required Map<String, dynamic> json}):
  ideaId = json['ideaId'],
  ideaTitle = json['ideaTitle'],
  moreDetails = json['moreDetails'],
  isFavorite = json['favorite'].toString().trim() == "true",
  super.fromDb(completedTasks: _jsonObject_To_Task(json['completedTasks']),uncompletedTasks: _jsonObject_To_Task(json['uncompletedTasks']));

  String? changeIdeaDetail(String? newDetails)=> moreDetails= newDetails;

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
  List<Task> highPriority = [];
  List<Task> mediumPriority = [];
  List<Task> lowPriority = [];

  List<Task> get allTasks => [...completedTasks,...uncompletedTasks];
  List<Task> get uncompletedTasks => [...highPriority,...mediumPriority,...lowPriority];
  /// Get the string of all tasks.
  List<String> get tasksStringInLowercase => allTasks.map((taskObj)=> taskObj.task.trim().toLowerCase()).toList();

  double get percentIndicator {
        final totalNumberOfTasks = allTasks.length;
        //first check that the total number of tasks is not zero, so as not to have a division by zero error.
        final double percent = (totalNumberOfTasks != 0) ?(completedTasks.length/totalNumberOfTasks)*100 :0;
        return percent;
  }
  
  TaskList({required List<Task> tasksToCreate})
  {
    SetOrderIndex_AddTaskToIdea(tasksList: tasksToCreate);
  }

  TaskList.fromDb({required this.completedTasks, required List<Task> uncompletedTasks})
  {
    insertTaskFromStorageToIdea(tasksList: uncompletedTasks);
  }
  
  TaskList.fromJson({required List<Map<String, dynamic>> completedTasks, required List<Map<String, dynamic>> uncompletedTasks})
  {
    Task Function(Map<String, dynamic> taskObj) createTaskFromJson = (taskObj) => Task.fromJson(json: taskObj);

    this.completedTasks = completedTasks.map(createTaskFromJson).toList();
    List<Task> uncompletedTasksFromJson = uncompletedTasks.map(createTaskFromJson).toList();
    insertTaskFromStorageToIdea(tasksList: uncompletedTasksFromJson);
  }

  /// Put the uncompleted tasks into their varying list based on their priority group, it also sets their order index
  /// and returns the modified list of tasks that now has an order index.
  // ignore: non_constant_identifier_names
  List<Task> SetOrderIndex_AddTaskToIdea({required List<Task> tasksList})
  {
    for(var task in tasksList){
      var priorityListObjRef = getListForPriorityGroup(task.priority);
      // The order index of the task should be the length of the objectRefList, because it increases every time a task is added.
      task.orderIndex = priorityListObjRef.length;
      priorityListObjRef.add(task);
    }

    // Returns the tasksList of items that now have an order index, incase you need it.
    return tasksList;
  }

  /// Use this method when reading task from external storage (Db or json).
  void insertTaskFromStorageToIdea({required List<Task> tasksList}) {
      tasksList.forEach((task) => getListForPriorityGroup(task.priority).add(task)); 
      sortAllListByOrderIndex();
  }    


  void deleteTask(Task task)
  {
    (uncompletedTasks.contains(task))
    ?getListForPriorityGroup(task.priority).remove(task)
    :completedTasks.remove(task);
    notifyListeners();
  }

  void uncheckCompletedTask(Task task)
  {
    completedTasks.remove(task);
    getListForPriorityGroup(task.priority).add(task);
    notifyListeners();
  }

  void completeTask(Task task)
  {
    getListForPriorityGroup(task.priority).remove(task);
    completedTasks.add(task);
    notifyListeners();
  }

  void addNewTask(Task task)
  {
    getListForPriorityGroup(task.priority!).add(task);
    notifyListeners();
  }

  /// return the corresponding list for the priority group.
  List<Task> getListForPriorityGroup(int? priorityGroup)
  {
    switch(priorityGroup!){
      case Priority_High: return highPriority;
      case Priority_Medium: return mediumPriority;
      case Priority_Low: return lowPriority;
      default: return[];
    }
  }

  /// Sort the list by their orderIndex.
  void sortAllListByOrderIndex(){
    int Function(Task a,Task b) sortByOrderIndex = (a,b)=> a.orderIndex.compareTo(b.orderIndex);
    highPriority.sort(sortByOrderIndex);
    mediumPriority.sort(sortByOrderIndex);
    lowPriority.sort(sortByOrderIndex);
  }


  /// Removes the task from the previous priorityGroup when it is being dragged across priorities.
  void deleteTaskFromGroup(Task incomingTask)
  {
    getListForPriorityGroup(incomingTask.priority!).remove(incomingTask);
    notifyListeners();
  }
  
}


class Task {
  late String task;
  late int orderIndex;
  int? primaryKey;
  int? priority;

  /// Default constructor for Task.
  Task();
  Task.fromDb({required this.task, required this.orderIndex, required this.primaryKey, required this.priority});
  Task.fromJson({required Map<String, dynamic> json}):
    this.task = json['task'],
    this.orderIndex = json['orderIndex'],
    this.primaryKey = json['primaryKey'],
    this.priority = json['priority'];

  Map toMap(){
    return {
      "task": task,
      "orderIndex": orderIndex,
      "primaryKey": primaryKey,
      "priority": priority
    };
  }
}

