import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/TaskManager/code/reorderListController.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/groupedList.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/reactivePage.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/reorderableGroupedList.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/taskPageMenu.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/taskPageAppBar.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:provider/provider.dart';


class UncompletedTasksPage extends StatelessWidget {
  
  UncompletedTasksPage({Key? key, required this.idea}) : super(key: key);
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
          backgroundColor: uncompletedTasksColor,
          resizeToAvoidBottomInset: false,
          appBar: TaskPageAppBar(pageName: "Uncompleted Tasks", pageColor: uncompletedTasksColor, context: context),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            controller: scrollController,
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
                            builder: (_,idea, __)=> (idea.uncompletedTasks.isNotEmpty) ? SearchBar_ReorderPopup(idea: idea, searchFieldController: searchFieldController) : Container(height: 108)),
                          ReactToReorderState(
                            isEnabled: FullReorderableList(idea: idea, scrollController: scrollController),
                            isDisabled: GroupedList(idea: idea))
                        ],
                      ),
              )
            ),
          ),
        ),
      ),
    );
  }
}
