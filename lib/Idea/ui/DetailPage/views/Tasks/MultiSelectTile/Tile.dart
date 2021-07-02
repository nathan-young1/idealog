import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/global/extension.dart';
import 'package:provider/provider.dart';
import 'Notifier.dart';

class MultiSelectTaskTile extends StatelessWidget {
  const MultiSelectTaskTile({
    Key? key,
    required this.taskRow
  }) : super(key: key);

  final Task taskRow;

  @override
  Widget build(BuildContext context) {
    
    MultiSelect multiSelectObj = Provider.of<MultiSelect>(context);
    bool tileIsSelected = multiSelectObj.containsTask(taskRow);

    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      selected: tileIsSelected,
      selectedTileColor: Colors.blueGrey,
      value: tileIsSelected,
      onChanged: (bool? value)=>
        (value == true)
        ?multiSelectObj.addTaskToMultiSelect(taskRow)
        :multiSelectObj.removeTaskFromMultiSelect(taskRow)
      ,
      title: Text(taskRow.task),
      );
  }
}