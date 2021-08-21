import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/TaskManager/code/MultiSelectController.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:provider/provider.dart';

class MultiSelectionList extends StatelessWidget {
  const MultiSelectionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MultiSelectController multiSelectObj = Provider.of<MultiSelectController>(context);

    return Consumer<Idea>(
      builder: (context, idea , _)=>
      Column(
      children: idea.completedTasks.map((completedTask) {
        bool tileIsSelected = multiSelectObj.containsTask(completedTask);

        return Container(
          color: tileIsSelected?Colors.blueGrey:null,
          child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: tileIsSelected,
          
          onChanged: (bool? value)=>
            (value == true)
            ?multiSelectObj.addTaskToMultiSelect(completedTask)
            :multiSelectObj.removeTaskFromMultiSelect(completedTask),
          title: Text(completedTask.task),
            ),
        );}
        ).toList()
      ,)
    );
  }
}