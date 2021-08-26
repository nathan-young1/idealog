import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/TaskManager/code/MultiSelectController.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
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
          color: tileIsSelected?(Prefrences.instance.isDarkMode) ?LightDark :DarkGray :null,
          child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: tileIsSelected,
          
          onChanged: (bool? value)=>
            (value == true)
            ?multiSelectObj.addTaskToMultiSelect(completedTask)
            :multiSelectObj.removeTaskFromMultiSelect(completedTask),
          title: Text(completedTask.task, style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_20)),
            ),
        );}
        ).toList()
      ,)
    );
  }
}