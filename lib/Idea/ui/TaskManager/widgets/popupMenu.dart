import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/Idea/ui/TaskManager/code/MultiSelectController.dart';
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


Widget PopupMenu_MultiSelect({required int flex}){

  return Expanded(
              flex: flex,
              child: PopupMenuButton<_Menu>(
                onSelected: (selected){
                  switch(selected){
                    case _Menu.MultiSelect:
                      MultiSelectController.instance.startMultiSelect();
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(child: Row(
                    children: [
                      Icon(FontAwesomeIcons.tasks),
                      SizedBox(width: 12),
                      Text('Multi-Selection', style: overpass.copyWith(fontSize: 16))
                    ],
                  ),
                  value: _Menu.MultiSelect)
                ]),
            );
}