import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/global/typedef.dart';

class MultiSelectController with ChangeNotifier{
  MultiSelectController._();
  static final MultiSelectController instance = MultiSelectController._();
  DBTaskList _multiSelectedTasks = [];
  
  /// if _multiSelectionState is true it means selection is activated
  bool _multiSelectState = false;

  /// Enable multi-selection mode for completed tasks page.
  startMultiSelect(){
    _state = true;
    notifyListeners();
    }
  
  /// Disable multi-selection mode for completed tasks page.
  stopMultiSelect(){ 
    clearSelectedTasks();
    _state = false;
    notifyListeners();
  }

  /// Get multi-selection state.
  bool get state => _multiSelectState;
  /// Set multi-selection state.
  set _state(bool updateState){
    _multiSelectState = updateState;
    notifyListeners();
  }

  DBTaskList get selectedTasks => _multiSelectedTasks;

  set _selectedTasks(DBTaskList allTasksInSection){
    _multiSelectedTasks = allTasksInSection;
    notifyListeners();
  }

  void clearSelectedTasks()=> _selectedTasks = [];
  /// Check if a particular task is in the multi-selection list.
  bool containsTask(Task task) => _multiSelectedTasks.contains(task);

  void addTaskToMultiSelect(Task task){
    _multiSelectedTasks.add(task);
    notifyListeners();
  }

  void removeTaskFromMultiSelect(Task task){
    _multiSelectedTasks.remove(task);
    notifyListeners();
  }
}
