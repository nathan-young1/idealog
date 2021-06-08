import 'package:flutter/material.dart';
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/Idea/ui/DetailPage/views/Tasks/MultiSelectTile/Notifier.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/global/extension.dart';
import 'package:provider/provider.dart';

class UncompletedTaskTile extends StatelessWidget {
  const UncompletedTaskTile({
    Key? key,
    required this.idea,
    required this.uncompletedTask
  }) : super(key: key);

  final IdeaModel idea;
  final List<int> uncompletedTask;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: ()=> Provider.of<MultiSelect>(context,listen: false).startMultiSelect(uncompletedTask),
      child: ListTile(
    
      leading: Checkbox(value: false, onChanged: (bool? value) async =>
       await IdeaManager.completeTask(idea, uncompletedTask)),
    
      title: Text(uncompletedTask.toAString),
    
      trailing: IconButton(icon: Icon(Icons.close),
      onPressed: () async => await IdeaManager.deleteTask(idea, uncompletedTask))
      
      ),
    );
  }
}