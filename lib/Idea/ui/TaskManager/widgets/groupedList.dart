import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:idealog/Databases/idealog-db/idealog_config.dart';
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';

/// The normal grouped list, when the page is not in reordering mode.
class GroupedList extends StatelessWidget {
  const GroupedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Idea>(
      builder: (context, idea, _)=>
      GroupedListView(
          shrinkWrap: true,
          elements: idea.uncompletedTasks,
          groupBy: (Task task)=> task.priority,
          groupSeparatorBuilder: (int? priority) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text((priority == Priority_High)
                ?'High Priority'
                :(priority == Priority_Medium) ? 'Medium Priority' : 'Low Priority',
                 style: overpass.copyWith(fontSize: 22, fontWeight: FontWeight.w500)),
              ),
            );
          },
          itemBuilder: (context, Task taskRow)=> 
            ListTile(
            leading: Checkbox(value: false, onChanged: (bool? value) async {if (value!) await IdeaManager.completeTask(idea, taskRow);}),
            title: Text(taskRow.task),
            trailing: IconButton(icon: Icon(Icons.close), onPressed: () async => await IdeaManager.deleteTask(idea, taskRow))
              )
        ),
    );
  }
}

