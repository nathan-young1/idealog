import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/global/typedef.dart';

class MultiSelect with ChangeNotifier{
  MultiSelect._();
  static final MultiSelect instance = MultiSelect._();
  DBTaskList _multiSelectedTasks = [];
  
  // if _multiSelectionState is true it means selection is activated
  bool _multiSelectState = false;


  startMultiSelect(Task task){ 
    addTaskToMultiSelect(task);
    _state = true;
    }
  
  stopMultiSelect(){ 
    clearSelectedTasks();
    _state = false;
  }

  bool get state => _multiSelectState;
  set _state(bool updateState){
    _multiSelectState = updateState;
    notifyListeners();
  }

  DBTaskList get selectedTasks => _multiSelectedTasks;

  set selectedTasks(DBTaskList allTasksInSection){
    _multiSelectedTasks = allTasksInSection;
    notifyListeners();
  }

  void clearSelectedTasks()=> selectedTasks = [];

  bool containsTask(Task task) => _multiSelectedTasks.contains(task);
  void addTaskToMultiSelect(Task task){
    _multiSelectedTasks.add(task);
    notifyListeners();
  }

  void addAllTaskInSectionToMultiSelect(DBTaskList allTaskInSection){
    _multiSelectedTasks.addAll(allTaskInSection);
    notifyListeners();
  }

  void removeTaskFromMultiSelect(Task task){
    _multiSelectedTasks.remove(task);
    notifyListeners();
  }

   void removeAllTaskInSectionFromMultiSelect(DBTaskList allTaskInSection){
     allTaskInSection.forEach((task) => _multiSelectedTasks.remove(task));
    notifyListeners();
  }

  bool containsAllTaskInSection(DBTaskList allTasksInSection){
    bool containsEveryTask = allTasksInSection.every((task) => _multiSelectedTasks.contains(task));
    return containsEveryTask;
  }
}
