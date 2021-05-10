import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/idea/ideaDetails/code/ideaManager.dart';
import 'package:idealog/global/extension.dart';
import 'package:provider/provider.dart';

class DetailTasksList extends StatelessWidget {
  final Idea idea;
  const DetailTasksList({required this.idea});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Idea>.value(value: idea,
      child: Builder(
        builder: (BuildContext context) =>
          Column(
          children: [
            if(Provider.of<Idea>(context).uncompletedTasks.isNotEmpty)
            _UncompletedTasks(idea: idea),
            SizedBox(height: 30),
            if(Provider.of<Idea>(context).completedTasks.isNotEmpty)
            _CompletedTasks(idea: idea)
          ],
        ),
      ),
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
            Center(child: Text('Uncompleted Tasks',style: Overpass.copyWith(fontSize: 25,fontWeight: FontWeight.w300)),),
            ...Provider.of<Idea>(context).uncompletedTasks.map((uncompletedTask) => 
            ListTile(
            leading: Checkbox(value: false, onChanged: (bool? value) async =>
             await IdeaManager.completeTask(idea, uncompletedTask)),
            title: Text(uncompletedTask.toAString),
            trailing: IconButton(icon: Icon(Icons.close),onPressed: () async =>
             await IdeaManager.deleteUncompletedTask(idea, uncompletedTask)))).toList()],
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
            Center(child: Text('Completed Tasks',style: Overpass.copyWith(fontSize: 25,fontWeight: FontWeight.w300))),
            ...Provider.of<Idea>(context).completedTasks.map((completedTask) => 
            ListTile(
            leading: Checkbox(
            value: true,
             onChanged: (bool? value) async =>
              await IdeaManager.uncheckCompletedTask(idea, completedTask)),
            title: Text(completedTask.toAString),
            trailing: IconButton(icon: Icon(Icons.more_vert),onPressed: () async =>
             await IdeaManager.deleteCompletedTask(idea, completedTask)))).toList()],
        );
  }
}