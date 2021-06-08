import 'package:flutter/material.dart';
import 'package:idealog/global/extension.dart';
import 'package:provider/provider.dart';
import 'Notifier.dart';

class MultiSelectTaskTile extends StatelessWidget {
  const MultiSelectTaskTile({
    Key? key,
    required this.task
  }) : super(key: key);

  final List<int> task;

  @override
  Widget build(BuildContext context) {
    
    MultiSelect multiSelectObj = Provider.of<MultiSelect>(context);
    bool tileIsSelected = multiSelectObj.containsTask(task);

    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      selected: tileIsSelected,
      selectedTileColor: Colors.blueGrey,
      value: tileIsSelected,
      onChanged: (bool? value)=>
        (value == true)
        ?multiSelectObj.addTaskToMultiSelect(task)
        :multiSelectObj.removeTaskFromMultiSelect(task)
      ,
      title: Text(task.toAString),
      );
  }
}