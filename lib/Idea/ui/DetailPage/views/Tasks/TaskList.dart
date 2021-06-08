import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';
import 'MultiSelectTile/Notifier.dart';
import 'MultiSelectTile/SectionTile.dart';
import 'MultiSelectTile/Tile.dart';
import 'NormalTile/completedTile.dart';
import 'NormalTile/uncompletedTile.dart';

class DetailTasksList extends StatelessWidget {
  final IdeaModel idea;
  DetailTasksList({required this.idea});
  
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          if(Provider.of<IdeaModel>(context).uncompletedTasks.isNotEmpty)
          _UncompletedTasks(idea: idea),
          SizedBox(height: 30),
          if(Provider.of<IdeaModel>(context).completedTasks.isNotEmpty)
          _CompletedTasks(idea: idea)
        ],
      );
  }
}

class _UncompletedTasks extends StatelessWidget {
  final IdeaModel idea;
  _UncompletedTasks({required this.idea});

  @override
  Widget build(BuildContext context) {
    List<List<int>> uncompletedTasks = Provider.of<IdeaModel>(context).uncompletedTasks;
    bool selectionState = Provider.of<MultiSelect>(context).state;
    return Column(
            children: [
            Center(
            child: (!selectionState)
            ?Text('Uncompleted Tasks',style: Overpass.copyWith(fontSize: 25,fontWeight: FontWeight.w300))
            :SectionMultiSelect(sectionTasks: uncompletedTasks, sectionName: Section.UNCOMPLETED_TASK)
             ),

             
            ...uncompletedTasks.map((uncompletedTask) => 
                    (!selectionState)
                    ?UncompletedTaskTile(idea: idea,uncompletedTask: uncompletedTask)
                    :MultiSelectTaskTile(task: uncompletedTask)
            ).toList()
            ],
        );
  }
}



class _CompletedTasks extends StatelessWidget {
  final IdeaModel idea;
  _CompletedTasks({required this.idea});

  @override
  Widget build(BuildContext context) {
    List<List<int>> completedTasks = Provider.of<IdeaModel>(context).completedTasks;
    bool selectionState = Provider.of<MultiSelect>(context).state;
    return Column(
            children: [
            Center(child: (!selectionState)
            ?Text('Completed Tasks',style: Overpass.copyWith(fontSize: 25,fontWeight: FontWeight.w300))
            :SectionMultiSelect(sectionTasks: completedTasks, sectionName: Section.COMPLETED_TASK)),

            ...completedTasks.map((completedTask) =>
                  (!selectionState)
                  ?CompletedTaskTile(idea: idea, completedTask: completedTask)
                  :MultiSelectTaskTile(task: completedTask)
            ).toList()
            ],
        );
  }
}
