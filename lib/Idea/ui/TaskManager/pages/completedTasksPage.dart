import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/TaskManager/code/MultiSelectController.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/NoTaskYet.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/animatedListTile.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/groupedList.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/multiSelectionList.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/reactivePage.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/taskPageMenu.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/DoesNotExist.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/taskPageAppBar.dart';
import 'package:idealog/SearchBar/SearchNotifier.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:provider/provider.dart';

class CompletedTasksPage extends StatelessWidget {
  
  CompletedTasksPage({ Key? key , required this.idea}) : super(key: key);
  final TextEditingController searchFieldController = new TextEditingController();
  final Idea idea;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       ChangeNotifierProvider<Idea>.value(value: idea),
       ChangeNotifierProvider<MultiSelectController>.value(value: MultiSelectController.instance)
       ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: completedTasksColor,
          resizeToAvoidBottomInset: false,
          appBar: TaskPageAppBar(pageName: "Completed Tasks", pageColor: completedTasksColor, context: context), 
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40))
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                children: [
                  Consumer<Idea>(
                        builder: (_,idea, __)=> (idea.completedTasks.isNotEmpty) ? SearchBar_MultiSelectPopup(searchFieldController: searchFieldController) : Container(height: 108)),
                  ReactToMultiSelection(
                    isEnabled: MultiSelectionList(),
                    isDisabled: Consumer<SearchController>(
                      builder: (_, searchController, __){
                        List<Task> completedTasks = idea.completedTasks.where(searchTermExistsInTask).toList();
                        
                          /// illustration for when there is no longer any completed task.
                          if(idea.completedTasks.isEmpty) return NoTaskYet(page: TaskPage.COMPLETED);
                         /// illustrastion for when no search result was found.
                         else if (completedTasks.isEmpty) return SearchNotFoundIllustration();
                         return TasksInColumnView(idea: idea, pageCalledFrom: TaskPage.COMPLETED);
                         }))
                ],
              ),
              ),
            ),
          )
        ),
      ),
    );
  }
}