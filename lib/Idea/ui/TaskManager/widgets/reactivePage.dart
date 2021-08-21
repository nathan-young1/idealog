import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/TaskManager/code/MultiSelectController.dart';
import 'package:idealog/Idea/ui/TaskManager/code/reorderListController.dart';
import 'package:provider/provider.dart';

/// A widget that listens to reorder list controller state to determine which page to show.
class ReactToReorderState extends StatelessWidget {
  const ReactToReorderState({Key? key, required this.isEnabled, required this.isDisabled}) : super(key: key);

  /// show this widget when reorderable list controller is enabled. 
  final Widget isEnabled;
  /// show this widget when reorderable list controller is disabled. 
  final Widget isDisabled;
  @override
  Widget build(BuildContext context) {
    return Consumer<ReorderListController>(
      builder: (context, reorderListController, _)=> 
      (reorderListController.reOrderIsActive)
        ?isEnabled
        :isDisabled
      ); 
  }
}

/// A widget that listens to multi-selection list controller state to determine which page to show.
class ReactToMultiSelection extends StatelessWidget {

  const ReactToMultiSelection({Key? key, required this.isEnabled, required this.isDisabled}) : super(key: key);

  /// show this widget when multi-selection list controller is enabled. 
  final Widget isEnabled;
  /// show this widget when multi-selection list controller is disabled. 
  final Widget isDisabled;

  @override
  Widget build(BuildContext context) {
    return Consumer<MultiSelectController>(
      builder: (context, multiSelectController, _)=> 
      (multiSelectController.state)
        ?isEnabled
        :isDisabled
      ); 
  }
}