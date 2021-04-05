import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/sqlite-db/sqlite.dart';
import 'package:idealog/global/extension.dart';

class DetailTasksList extends StatelessWidget {
  final Idea idea;
  const DetailTasksList({required this.idea});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(idea.tasks!.uncompletedTasks.isNotEmpty)
        _UncompletedTasks(idea: idea),
        SizedBox(height: 30),
        if(idea.tasks!.completedTasks.isNotEmpty)
        _CompletedTasks(idea: idea)
      ],
    );
  }
}

class _UncompletedTasks extends StatelessWidget {
  final Idea idea;
  _UncompletedTasks({required this.idea});

  @override
  Widget build(BuildContext context) {

    return Column(
            children: [
            Center(child: Text('Uncompleted Tasks',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500)),),
            ...idea.tasks!.uncompletedTasks.map((uncompletedTask) => 
            ListTile(
            leading: Checkbox(value: false, onChanged: (bool? value) async {
                idea.tasks!.completeTask(uncompletedTask);
                await Sqlite.updateDb(idea.uniqueId, idea: idea);
                }),
            title: Text(uncompletedTask.toAString),
            trailing: IconButton(icon: Icon(Icons.close),onPressed: () async {
            idea.tasks!.deleteTask(uncompletedTask);
            await Sqlite.updateDb(idea.uniqueId, idea: idea);}))).toList()],
        );
  }
}

class _CompletedTasks extends StatelessWidget {
  final Idea idea;
  _CompletedTasks({required this.idea});

  @override
  Widget build(BuildContext context) {

    return Column(
            children: [
            Center(child: Text('Completed Tasks',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500))),
            ...idea.tasks!.completedTasks.map((completedTask) => 
            ListTile(
            leading: Checkbox(
            value: true,
             onChanged: (bool? value) async {
                idea.tasks!.uncheckCompletedTask(completedTask);
                await Sqlite.updateDb(idea.uniqueId, idea: idea);
                }),
            title: Text(completedTask.toAString),
            trailing: IconButton(icon: Icon(Icons.close),onPressed: () async {
            idea.tasks!.deleteTask(completedTask);
            await Sqlite.updateDb(idea.uniqueId, idea: idea);}))).toList()],
        );
  }
}