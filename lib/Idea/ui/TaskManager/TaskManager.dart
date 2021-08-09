import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/TaskManager/navigators/GotoAddTasksPage.dart';
import 'package:idealog/Idea/ui/TaskManager/navigators/GotoCompletedPage.dart';
import 'package:idealog/Idea/ui/TaskManager/navigators/GotoHighPriorityPage.dart';
import 'package:idealog/Idea/ui/TaskManager/navigators/GotoUncompletedPage.dart';
import 'package:idealog/SearchBar/SearchNotifier.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/textStyles.dart';

// check if the search term exists in the list
bool _searchTermExists(Task taskRow)=> taskRow.task.contains(SearchController.instance.searchTerm);

class TaskManager extends StatelessWidget {

  final BorderRadius borderRadius = BorderRadius.all(Radius.circular(10));
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Task Manager',style: overpass.copyWith(fontSize: 25)),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GotoHighPriorityPage(borderRadius: borderRadius),
            GotoAddTasksPage(borderRadius: borderRadius)
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GotoUncompletedPage(borderRadius: borderRadius),
            GotoCompletedPage(borderRadius: borderRadius)
          ],
        )
      ]
    );
  }
  
}