import 'package:flutter/material.dart';
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/Idea/ui/DetailPage/views/Tasks/MultiSelectTile/Notifier.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:provider/provider.dart';

class MultiSelectAction extends StatelessWidget {
  const MultiSelectAction({
    Key? key,
    required this.idea,
    required this.selectedTasks
  }) : super(key: key);

  final IdeaModel idea;
  final List<List<int>> selectedTasks;

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