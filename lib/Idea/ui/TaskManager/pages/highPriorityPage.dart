import 'package:flutter/material.dart';
import 'package:idealog/Databases/idealog-db/idealog_config.dart';
import 'package:idealog/Idea/ui/TaskManager/code/reorderListController.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/groupedList.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/reactivePage.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/reorderableGroupedList.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/taskBar.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/DoesNotExist.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/tasksAppBar.dart';
import 'package:idealog/SearchBar/SearchNotifier.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:provider/provider.dart';

class HighPriorityTaskPage extends StatelessWidget {
  HighPriorityTaskPage({ Key? key, required this.idea}) : super(key: key);
  final Idea idea;
  final ScrollController scrollController = ScrollController();
    TextEditingController searchFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       ChangeNotifierProvider<Idea>.value(value: idea),
       ChangeNotifierProvider<ReorderListController>.value(value: ReorderListController.instance)
       ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: HighPriorityColor,
          resizeToAvoidBottomInset: false,
          appBar: TasksAppBar(pageName: "High Priority Tasks", pageColor: HighPriorityColor, context: context),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            controller: scrollController,
            child: Container(
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40))
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    SearchBar_ReorderPopup(idea: idea, searchFieldController: searchFieldController),
                    PageReactiveToReorderState(
                      isEnabled: SingleReorderableGroupedList(idea: idea, priorityGroup: Priority_High, scrollController: scrollController),
                      isDisabled: Consumer<SearchController>(
                        builder: (_, searchController, __){
                          List<Task> highPriorityTasks = idea.highPriority.where(searchTermExistsInTask).toList();
                          
                          if(highPriorityTasks.isEmpty) return DoesNotExistIllustration();
                          return PriorityTasksInColumnView(idea: idea);
                        })),      
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
