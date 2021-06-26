import 'package:flutter/material.dart';
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/Idea/ui/DetailPage/views/Tasks/MultiSelectTile/Notifier.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:provider/provider.dart';
import 'package:idealog/global/typedef.dart';

class MultiSelectAction extends StatelessWidget {
  const MultiSelectAction({
    Key? key,
    required this.idea,
    required this.selectedTasks
  }) : super(key: key);

  final Idea idea;
  final DBTaskList selectedTasks;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await IdeaManager.multiDelete(idea, selectedTasks);
        Provider.of<MultiSelect>(context,listen: false).stopMultiSelect();
      },
      iconSize: 32,
      icon: Icon(Icons.delete)
    );
  }
}