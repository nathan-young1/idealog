import 'package:flutter/material.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';
import 'Notifier.dart';


enum Section{COMPLETED_TASK,UNCOMPLETED_TASK}

class SectionMultiSelect extends StatelessWidget {
  const SectionMultiSelect({
    Key? key,
    required this.sectionTasks,
    required this.sectionName
  }) : super(key: key);

  final List<List<int>> sectionTasks;
  final Section sectionName;

  @override
  Widget build(BuildContext context) {
    MultiSelect multiSelectObj = Provider.of<MultiSelect>(context);

    return CheckboxListTile(
    selected: multiSelectObj.containsAllTaskInSection(sectionTasks),
     selectedTileColor: Colors.blueGrey,
     controlAffinity: ListTileControlAffinity.leading,
     value: multiSelectObj.containsAllTaskInSection(sectionTasks),
     title: Text(
     (sectionName == Section.COMPLETED_TASK)
     ?'Completed Tasks'
     :'Uncompleted Tasks',
     style: Overpass.copyWith(fontSize: 25,fontWeight: FontWeight.w300)
     ),
     onChanged: (bool? value)=>
                (value == true)
                ?multiSelectObj.addAllTaskInSectionToMultiSelect(sectionTasks)
                :multiSelectObj.removeAllTaskInSectionFromMultiSelect(sectionTasks)
     );
  }
}