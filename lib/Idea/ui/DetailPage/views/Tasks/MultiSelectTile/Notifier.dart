import 'package:flutter/material.dart';

class MultiSelect with ChangeNotifier{
  MultiSelect._();
  static final MultiSelect instance = MultiSelect._();
  List<List<int>> _multiSelectedTasks = [];
  
  // if _multiSelectionState is true it means selection is activated
  bool _multiSelectState = false;


  startMultiSelect(List<int> task){ 
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

  List<List<int>> get selectedTasks => _multiSelectedTasks;

  set selectedTasks(List<List<int>> allTasksInSection){
    _multiSelectedTasks = allTasksInSection;
    notifyListeners();
  }

  void clearSelectedTasks()=> selectedTasks = [];

  bool containsTask(List<int> task) => _multiSelectedTasks.contains(task);
  void addTaskToMultiSelect(List<int> task){
    _multiSelectedTasks.add(task);
    notifyListeners();
  }

  void addAllTaskInSectionToMultiSelect(List<List<int>> allTaskInSection){
    _multiSelectedTasks.addAll(allTaskInSection);
    notifyListeners();
  }

  void removeTaskFromMultiSelect(List<int> task){
    _multiSelectedTasks.remove(task);
    notifyListeners();
  }

   void removeAllTaskInSectionFromMultiSelect(List<List<int>> allTaskInSection){
     allTaskInSection.forEach((task) => _multiSelectedTasks.remove(task));
    notifyListeners();
  }

  bool containsAllTaskInSection(List<List<int>> allTasksInSection){
    bool containsEveryTask = allTasksInSection.every((task) => _multiSelectedTasks.contains(task));
    return containsEveryTask;
  }
}
