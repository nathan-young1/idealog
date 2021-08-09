import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/TaskManager/code/reorderListController.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/groupedList.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/reactivePage.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/reorderableGroupedList.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/taskBar.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/tasksAppBar.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
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
          appBar: TasksAppBar(pageName: "Uncompleted Tasks", pageColor: uncompletedTasksColor, context: context),
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
                      SearchBar_ReorderPopup(idea: idea),
                      PageReactiveToReorderState(
                        isEnabled: ReorderableListForAllPriorityGroups(idea: idea, scrollController: scrollController),
                        isDisabled: GroupedList()) 
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
