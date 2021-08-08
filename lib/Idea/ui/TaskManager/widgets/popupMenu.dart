import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Idea/ui/TaskManager/code/reorderListController.dart';
import 'package:idealog/design/textStyles.dart';

enum _Menu{ReorderTasks, MultiSelect}

// ignore: non_constant_identifier_names
Widget PopupMenu_reorder({required int flex}){

  return Expanded(
              flex: flex,
              child: PopupMenuButton<_Menu>(
                onSelected: (selected){
                  switch(selected){
                    case _Menu.ReorderTasks:
                      ReorderListController.instance.enableReordering();
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(child: Row(
                    children: [
                      Icon(FeatherIcons.move),
                      SizedBox(width: 12),
                      Text('Reorder Tasks', style: overpass.copyWith(fontSize: 16))
                    ],
                  ),
                  value: _Menu.ReorderTasks)
                ]),
            );
}