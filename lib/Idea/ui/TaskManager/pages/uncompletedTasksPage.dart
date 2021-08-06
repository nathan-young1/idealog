import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:idealog/Databases/idealog-db/idealog_config.dart';
import 'package:idealog/Idea/ui/TaskManager/code/reorderListController.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/groupedList.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/reorderableGroupedList.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/tasksAppBar.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';


class UncompletedTasksPage extends StatelessWidget {
  
  UncompletedTasksPage({Key? key, required this.idea}) : super(key: key);
  final Idea idea;

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Sort the list by orderIndex on enter.
    idea.sortAllListByOrderIndex();

    return MultiProvider(
      providers: [
       ChangeNotifierProvider<Idea>.value(value: idea),
       ChangeNotifierProvider<ReorderListController>.value(value: ReorderListController.instance)
       ],
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight * 1.2),
            child: TasksAppBar(pageName: "Uncompleted Tasks", pageColor: uncompletedTasksColor)
            ),
          body: Container(
            color: uncompletedTasksColor,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              controller: scrollController,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40))
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 35, top: 10),
                        child: UncompletedTaskMenu(idea: idea),
                      ),
                      // This consumer will watch for state change in reorder list.
                      Consumer<ReorderListController>(
                        builder: (context, reorderListController, _)=> 
                        (reorderListController.reOrderIsActive)
                          ?ReorderableListForAllPriorityGroups(idea: idea, scrollController: scrollController)
                          :GroupedList()
                        )
                    ],
                  ),
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}


enum _Menu{ReorderTasks}

class UncompletedTaskMenu extends StatelessWidget {
  UncompletedTaskMenu({required this.idea});
  final Idea idea;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReorderListController>(
      builder: (context, reorderListController, _)=>
      // Show this menu on top if the list is not in reordering mode.
      (!reorderListController.reOrderIsActive)
      ?Container(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  decoration: elevatedBoxDecoration,
                  child: TextField(
                    decoration: formTextField.copyWith(
                      hintText: 'Search for a task'
                    ),
                  ),
                ),
              )),
            Expanded(
              flex: 1,
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
            )
          ]
        ),
      )
      // Show this menu if the list is in reorder mode.
      :Align(
        alignment: Alignment(1, 0),
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Container(
            width: 250,
            decoration: elevatedBoxDecoration.copyWith(color: Colors.white),
            child: TextButton.icon(
              onPressed: () async => 
                    await reorderListController.updateAndSaveTaskOrderIndex(idea, reorderListController),
              icon: Icon(FeatherIcons.check),
              label: Text('Save tasks order', style: overpass.copyWith(fontSize: 22))),
          ),
        ),
      ),
    );
  }
}
