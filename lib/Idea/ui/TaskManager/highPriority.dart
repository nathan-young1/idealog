import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Databases/idealog-db/idealog_config.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';

class HighPriorityTaskPage extends StatelessWidget {
  const HighPriorityTaskPage({ Key? key, required this.idea}) : super(key: key);
  final Idea idea;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HighPriorityColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text("High Priority Tasks", style: overpass.copyWith(fontSize: 25, color: Colors.white))),
                    Expanded(
                      flex: 1,
                      child: IconButton(onPressed: ()=> Navigator.of(context).pop(),
                      icon: Icon(FeatherIcons.chevronDown, size: 30, color: Colors.white)),
                    ),
                ]),
              ),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: LightGray,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: HighPriorityMenu(),
                        ),
                        ...idea.uncompletedTasks.where((task)=> task.priority == Priority_High)
                        .map((uncompletedTask) => 
                             ListTile(
                            leading: Checkbox(value: false, onChanged: (bool? value) {}),
                            title: Text(uncompletedTask.task),
                            trailing: IconButton(icon: Icon(Icons.close), onPressed: (){})
                            
                              ),
                        ).toList()
                      ],
                    ),
                  )
                ),
              )
          ],
        ),
      ),
    );
  }
}

enum _Menu{ReorderTasks}

class HighPriorityMenu extends StatelessWidget {
  const HighPriorityMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: TextField(),
            )),
          Spacer(flex: 1),
          Expanded(
            flex: 1,
            child: PopupMenuButton<_Menu>(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(child: TextButton.icon(
                 onPressed: (){},
                 icon: Icon(FeatherIcons.move),
                 label: Text('Reorder Tasks', style: overpass.copyWith(fontSize: 16))),
                value: _Menu.ReorderTasks)
              ]),
          )
        ]
      ),
    );
  }
}