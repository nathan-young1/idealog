import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Idea/ui/Others/AddTasks.dart';
import 'package:idealog/Idea/ui/TaskManager/highPriority.dart';
import 'package:idealog/Idea/ui/TaskManager/uncompletedTasksPage.dart';
import 'package:idealog/SearchBar/SearchNotifier.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';
import 'MultiSelectTile/Notifier.dart';
import 'MultiSelectTile/SectionTile.dart';
import 'MultiSelectTile/Tile.dart';
import 'NormalTile/completedTile.dart';
import 'NormalTile/uncompletedTile.dart';
import 'package:idealog/global/typedef.dart';

class DetailTasksList extends StatelessWidget {
  final Idea idea;
  DetailTasksList({required this.idea});
  
  @override
  Widget build(BuildContext context) {
    SearchController searchController = Provider.of<SearchController>(context);

    return Column(
        children: [
          if(Provider.of<Idea>(context).uncompletedTasks.where(_searchTermExists).isNotEmpty)
          _UncompletedTasks(idea: idea,searchTerm: searchController.searchTerm),
          SizedBox(height: 30),
          if(Provider.of<Idea>(context).completedTasks.where(_searchTermExists).isNotEmpty)
          _CompletedTasks(idea: idea,searchTerm: searchController.searchTerm)
        ],
      );
  }
}

class _UncompletedTasks extends StatelessWidget {
  final Idea idea;
  final String searchTerm;
  _UncompletedTasks({required this.idea,required this.searchTerm});

  @override
  Widget build(BuildContext context) {
    DBTaskList uncompletedTasks = Provider.of<Idea>(context).uncompletedTasks;
    bool selectionState = Provider.of<MultiSelect>(context).state;
    return Column(
            children: [
            Center(
            child: (!selectionState)
            ?Text('Uncompleted Tasks',style: overpass.copyWith(fontSize: 25,fontWeight: FontWeight.w300))
            :SectionMultiSelect(sectionTasks: uncompletedTasks, sectionName: Section.UNCOMPLETED_TASK)
             ),

             
            ...uncompletedTasks.where(_searchTermExists)
            .map((uncompletedTask) => 
                    (!selectionState)
                    ?UncompletedTaskTile(idea: idea,uncompletedTask: uncompletedTask)
                    :MultiSelectTaskTile(taskRow: uncompletedTask)
            ).toList()
            ],
        );
  }
}



class _CompletedTasks extends StatelessWidget {
  final Idea idea;
  final String searchTerm;
  _CompletedTasks({required this.idea, required this.searchTerm});

  @override
  Widget build(BuildContext context) {
    DBTaskList completedTasks = Provider.of<Idea>(context).completedTasks;
    bool selectionState = Provider.of<MultiSelect>(context).state;
    return Column(
            children: [
            Center(child: (!selectionState)
            ?Text('Completed Tasks',style: overpass.copyWith(fontSize: 25,fontWeight: FontWeight.w300))
            :SectionMultiSelect(sectionTasks: completedTasks, sectionName: Section.COMPLETED_TASK)),

            ...completedTasks.where(_searchTermExists)
            .map((completedTask) =>
                  (!selectionState)
                  ?CompletedTaskTile(idea: idea, completedTask: completedTask)
                  :MultiSelectTaskTile(taskRow: completedTask)
            ).toList()
            ],
        );
  }
}

// check if the search term exists in the list
bool _searchTermExists(Task taskRow)=> taskRow.task.contains(SearchController.instance.searchTerm);

class TaskManager extends StatelessWidget {
  TaskManager({required this.idea});

  final Idea idea;
  BorderRadius borderRadius = BorderRadius.all(Radius.circular(10));
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Task Manager',style: overpass.copyWith(fontSize: 25)),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            HighPriorityTasks(borderRadius: borderRadius, idea: idea),
            AddTaskWidget(borderRadius: borderRadius,idea: idea)
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            UncompletedTasksWidget(borderRadius: borderRadius, idea: idea),
            CompletedTasksWidget(borderRadius: borderRadius)
          ],
        )
      ]
    );
  }
  
}

class CompletedTasksWidget extends StatelessWidget {
  const CompletedTasksWidget({
    Key? key,
    required this.borderRadius,
  }) : super(key: key);

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(height: 130, width: 130,
    decoration: BoxDecoration(borderRadius: borderRadius,color: completedTasksColor),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Black242424.withOpacity(0.2)),
          child: Icon(Icons.warning_amber_outlined,color: Colors.white,size: 18)
        ),
        Flexible(child: Text('Completed Tasks',style: overpass.copyWith(fontSize: 16, color: Colors.white))),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Text('20/20',style: overpass.copyWith(fontSize: 14,color: Colors.white),)],)
      ],),
    ),);
  }
}

class UncompletedTasksWidget extends StatelessWidget {
  const UncompletedTasksWidget({
    Key? key,
    required this.borderRadius,
    required this.idea
  }) : super(key: key);

  final BorderRadius borderRadius;
  final Idea idea;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => 
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=> UncompletedTasksPage(idea: idea))
      ),
      child: Container(height: 130, width: 130,
      decoration: BoxDecoration(borderRadius: borderRadius,color: uncompletedTasksColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Black242424.withOpacity(0.2)),
            child: Icon(FeatherIcons.list,color: Colors.white,size: 18)
          ),
          Flexible(child: Text('Uncompleted Tasks',style: overpass.copyWith(fontSize: 16, color: Colors.white))),
          LinearProgressIndicator(value: 60,backgroundColor: Black242424.withOpacity(0.2),color: Colors.white,),
        ],),
      ),),
    );
  }
}

class HighPriorityTasks extends StatelessWidget {
  const HighPriorityTasks({
    Key? key,
    required this.borderRadius,
    required this.idea
  }) : super(key: key);

  final BorderRadius borderRadius;
  final Idea idea;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => 
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=> HighPriorityTaskPage(idea: idea))
      ),
      child: Container(height: 130, width: 130,
      decoration: BoxDecoration(borderRadius: borderRadius,color: HighPriorityColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Black242424.withOpacity(0.2)),
            child: Icon(Icons.warning_amber_outlined,color: Colors.white,size: 18)
          ),
          Flexible(child: Text('High Priority Tasks',style: overpass.copyWith(fontSize: 16, color: Colors.white))),
          LinearProgressIndicator(value: 60,backgroundColor: Black242424.withOpacity(0.2),color: Colors.white,),
        ],),
      ),),
    );
  }
}

class AddTaskWidget extends StatelessWidget {
  const AddTaskWidget({
    Key? key,
    required this.borderRadius,
    required this.idea
  }) : super(key: key);

  final BorderRadius borderRadius;
  final Idea idea;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> AddToExistingIdea(idea: idea))),
      child: Container(height: 100, width: 130,
      decoration: BoxDecoration(borderRadius: borderRadius,color: DarkBlue),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          Icon(Icons.add, size: 35, color: Colors.white),
          Text('Add Task',style: overpass.copyWith(fontSize: 22,color: Colors.white))
        ]),
      )),
    );
  }
}
