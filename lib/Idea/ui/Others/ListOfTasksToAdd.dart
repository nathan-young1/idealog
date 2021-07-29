import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideaModel.dart';

class ListOfTasksToAdd extends StatelessWidget {
  const ListOfTasksToAdd({Key? key, required this.tasks}) : super(key: key);
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
              children: tasks.reversed.map((taskRow) =>
                Row(
                  children: [
                    Icon(Icons.circle,color: Colors.grey,size: 20),
                    SizedBox(width: 25),
                    Expanded(child: Container(child: Text(taskRow.task))),
                    IconButton(
                    icon: Icon(CommunityMaterialIcons.close,color: Colors.grey),
                    onPressed: ()=> setState(() => tasks.remove(taskRow)))
                  ])
                  ).toList());
      }
    );
  }
}