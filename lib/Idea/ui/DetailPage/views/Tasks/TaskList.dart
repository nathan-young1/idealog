import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';
import 'MultiSelectTile/Notifier.dart';
import 'MultiSelectTile/SectionTile.dart';
import 'MultiSelectTile/Tile.dart';
import 'NormalTile/completedTile.dart';
import 'NormalTile/uncompletedTile.dart';
import 'SearchBar/SearchNotifier.dart';
import 'package:idealog/global/extension.dart';

class DetailTasksList extends StatelessWidget {
  final IdeaModel idea;
  DetailTasksList({required this.idea});
  
  @override
  Widget build(BuildContext context) {
    SearchController searchController = Provider.of<SearchController>(context);

    return Column(
        children: [
          if(Provider.of<IdeaModel>(context).uncompletedTasks.where(_searchTermExists).isNotEmpty)
          _UncompletedTasks(idea: idea,searchTerm: searchController.searchTerm),
          SizedBox(height: 30),
          if(Provider.of<IdeaModel>(context).completedTasks.where(_searchTermExists).isNotEmpty)
          _CompletedTasks(idea: idea,searchTerm: searchController.searchTerm)
        ],
      );
  }
}

class _UncompletedTasks extends StatelessWidget {
  final IdeaModel idea;
  final String searchTerm;
  _UncompletedTasks({required this.idea,required this.searchTerm});

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

             
            ...uncompletedTasks.where(_searchTermExists)
            .map((uncompletedTask) => 
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
  final String searchTerm;
  _CompletedTasks({required this.idea, required this.searchTerm});

  @override
  Widget build(BuildContext context) {
    List<List<int>> completedTasks = Provider.of<IdeaModel>(context).completedTasks;
    bool selectionState = Provider.of<MultiSelect>(context).state;
    return Column(
            children: [
            Center(child: (!selectionState)
            ?Text('Completed Tasks',style: Overpass.copyWith(fontSize: 25,fontWeight: FontWeight.w300))
            :SectionMultiSelect(sectionTasks: completedTasks, sectionName: Section.COMPLETED_TASK)),

            ...completedTasks.where(_searchTermExists)
            .map((completedTask) =>
                  (!selectionState)
                  ?CompletedTaskTile(idea: idea, completedTask: completedTask)
                  :MultiSelectTaskTile(task: completedTask)
            ).toList()
            ],
        );
  }
}

// check if the search term exists in the list
bool _searchTermExists(List<int> task)=> task.toAString.contains(SearchController.instance.searchTerm);
