import 'package:flutter/material.dart';
import 'package:idealog/Databases/idealog-db/idealog_config.dart';
import 'package:idealog/Idea/ui/TaskManager/code/reorderListController.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/NoTaskYet.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/animatedListTile.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/groupedList.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/reactivePage.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/reorderableGroupedList.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/taskPageMenu.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/DoesNotExist.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/taskPageAppBar.dart';
import 'package:idealog/SearchBar/SearchNotifier.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:provider/provider.dart';

class HighPriorityTaskPage extends StatelessWidget {
  HighPriorityTaskPage({ Key? key, required this.idea}) : super(key: key);
  final Idea idea;
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchFieldController = new TextEditingController();

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
          appBar: TaskPageAppBar(pageName: "High Priority Tasks", pageColor: HighPriorityColor, context: context),
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
                    Consumer<Idea>(
                            builder: (_,idea, __)=> (idea.highPriority.isNotEmpty) ? SearchBar_ReorderPopup(idea: idea, searchFieldController: searchFieldController) : Container(height: 108)),
                    ReactToReorderState(
                      isEnabled: SingleReorderableList(idea: idea, priorityGroup: Priority_High, scrollController: scrollController),
                      isDisabled: Consumer<SearchController>(
                        builder: (_, searchController, __){
                          List<Task> highPriorityTasks = idea.highPriority.where(searchTermExistsInTask).toList();
                          
                          /// illustration for when there is no longer any high priority task.
                          if(idea.highPriority.isEmpty) return NoTaskYet();
                          /// illustrastion for when no search result was found.
                          else if(highPriorityTasks.isEmpty) return SearchNotFoundIllustration();

                          return TasksInColumnView(idea: idea, priorityGroup: Priority_High, pageCalledFrom: TaskPage.HIGH_PRIORITY);
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
