import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/TaskManager/code/reorderListController.dart';
import 'package:provider/provider.dart';

/// A widget that listens to reorder list controller state to determine which page to show.
class PageReactiveToReorderState extends StatelessWidget {
  const PageReactiveToReorderState({Key? key, required this.isEnabled, required this.isDisabled}) : super(key: key);

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