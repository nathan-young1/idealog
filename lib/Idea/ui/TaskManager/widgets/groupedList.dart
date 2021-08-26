import 'package:flutter/material.dart';
import 'package:idealog/Databases/idealog-db/idealog_config.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/DoesNotExist.dart';
import 'package:idealog/SearchBar/SearchNotifier.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';
import 'NoTaskYet.dart';
import 'animatedListTile.dart';

/// The list when the page is not in reordering mode.
class GroupedList extends StatelessWidget { 
  GroupedList({required this.idea});
  final Idea idea;

  @override
  Widget build(BuildContext context) {
    
    return Consumer<SearchController>(
      builder: (context, searchController, _){
        /// All the lists filtered by the search term.
        List<Task> highPriorityTasks = idea.highPriority.where(searchTermExistsInTask).toList();
        List<Task> mediumPriorityTasks = idea.mediumPriority.where(searchTermExistsInTask).toList();
        List<Task> lowPriorityTasks = idea.lowPriority.where(searchTermExistsInTask).toList();

        if(highPriorityTasks.isEmpty && mediumPriorityTasks.isEmpty && lowPriorityTasks.isEmpty)
        // because grouped list is called by uncompletedTasks if it is empty show no tasks yet.
          return (idea.uncompletedTasks.isEmpty)? NoTaskYet(page: TaskPage.UNCOMPLETED): SearchNotFoundIllustration();
          
        return Column(
          children: [
            /// only show a priority section if it is not empty.
            if(highPriorityTasks.isNotEmpty) TasksInColumnView(priorityGroup: Priority_High, idea: idea),
            if(mediumPriorityTasks.isNotEmpty) TasksInColumnView(priorityGroup: Priority_Medium, idea: idea,),
            if(lowPriorityTasks.isNotEmpty) TasksInColumnView(priorityGroup: Priority_Low, idea: idea),
        ]
      );
    },
    );
  }
}




/// All tasks for a particular priorityGroup
class TasksInColumnView extends StatelessWidget{
  TasksInColumnView({this.priorityGroup, required this.idea,this.pageCalledFrom});

  // i am making priority group nullable so that i can reuse this widget in both highPriorityTasks and completedTasks.
  final int? priorityGroup;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final Idea idea;
  final TaskPage? pageCalledFrom;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          /// only show the animated list title if the priority group was given and the page called from
          /// is not the high priority page(Because the page is for high priority tasks so we do not need to show a title on top of the tasks again).
          if(priorityGroup != null && pageCalledFrom != TaskPage.HIGH_PRIORITY)Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text((priorityGroup == Priority_High)
            ?'High Priority'
            :(priorityGroup == Priority_Medium) ? 'Medium Priority' : 'Low Priority',
              style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_23)),
          ),

          /// if the priority group is not given then this was called from completed tasks page.
          AnimatedList(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            initialItemCount: (priorityGroup!= null)
            ?idea.getListForPriorityGroup(priorityGroup).where(searchTermExistsInTask).toList().length
            :idea.completedTasks.where(searchTermExistsInTask).toList().length,
            key:  _listKey,
            itemBuilder: (context, index, animation){
              return AnimatedListTile(
              taskRow: (priorityGroup!= null)
              ?idea.getListForPriorityGroup(priorityGroup).where(searchTermExistsInTask).toList()[index]
              :idea.completedTasks.where(searchTermExistsInTask).toList()[index],
              idea: idea,
              index: index,
              animation: animation,
              isAnimating: false,
              context: context,
              pageCalledFrom: pageCalledFrom);
            },
          )
      ]);
  }

}


