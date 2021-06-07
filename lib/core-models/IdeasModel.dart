import 'package:flutter/material.dart';
import 'package:idealog/Databases/idealog-db/idealog_Db_Moor.dart';
import 'package:idealog/global/extension.dart';

class IdeaModel extends Tasks{
  int? uniqueId;
  String ideaTitle;
  String? moreDetails;
  
  IdeaModel({required this.ideaTitle,this.moreDetails,required List<List<int>> tasksToCreate}):super(listOfTasksToCreate: tasksToCreate);

  IdeaModel.readFromDb({required this.ideaTitle,this.moreDetails,required List<List<int>> completedTasks,required this.uniqueId,required List<List<int>> uncompletedTasks}):super.fromDb(completedTasks: completedTasks,uncompletedTasks: uncompletedTasks);

  IdeaModel.readDb({required Idea idea}):
  uniqueId = idea.uniqueId,
  ideaTitle = idea.ideaTitle,
  moreDetails = idea.moreDetails,
  super.fromDb(completedTasks: idea.completedTasks!.fromDbStringToListInt,uncompletedTasks: idea.uncompletedTasks!.fromDbStringToListInt);

  IdeaModel.fromFirebaseJson({required Map<String, dynamic> json}):
  uniqueId = json['uniqueId'],
  ideaTitle = json['ideaTitle'],
  moreDetails = json['moreDetails'],
  super.fromDb(completedTasks: json['completedTasks'],uncompletedTasks: json['uncompletedTasks']);

  String? changeMoreDetail(String? newDetails)=> moreDetails= newDetails;

  Map<String, dynamic> toMap(){
    return {
        'uniqueId': uniqueId,
        'ideaTitle': ideaTitle,
        'moreDetails': moreDetails,
        'completedTasks': completedTasks,
        'uncompletedTasks': uncompletedTasks
    };
  }
}


abstract class Tasks with ChangeNotifier{
  
  List<List<int>> completedTasks = [];
  List<List<int>> uncompletedTasks = [];

  List<List<int>> get allTasks => [...completedTasks,...uncompletedTasks];
  Tasks({required List<List<int>> listOfTasksToCreate}):uncompletedTasks = listOfTasksToCreate;
  Tasks.fromDb({required this.completedTasks,required this.uncompletedTasks});

  void deleteTask(List<int> task){
    (uncompletedTasks.contains(task))
    ?uncompletedTasks.remove(task)
    :completedTasks.remove(task);
    notifyListeners();
  }

  void uncheckCompletedTask(List<int> task){
    completedTasks.remove(task);
    uncompletedTasks.add(task);
    notifyListeners();
  }

  void completeTask(List<int> task){
    uncompletedTasks.remove(task);
    completedTasks.add(task);
    notifyListeners();
    }

  void addNewTask(List<int> task){
  uncompletedTasks.add(task);
  notifyListeners();
  }
}
