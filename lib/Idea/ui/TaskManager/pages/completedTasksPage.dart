import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/Idea/ui/TaskManager/code/MultiSelectController.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/multiSelectionList.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/reactivePage.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/taskBar.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/tasksAppBar.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:provider/provider.dart';

class CompletedTasksPage extends StatelessWidget {
  const CompletedTasksPage({ Key? key , required this.idea}) : super(key: key);
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
          appBar: TasksAppBar(pageName: "Completed Tasks", pageColor: completedTasksColor, context: context), 
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
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
                  SearchBar_MultiSelectPopup(),
                  PageReactiveToMultiSelectionState(
                    isEnabled: MultiSelectionList(),
                    isDisabled: ColumnViewCompletedTasks())
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


class ColumnViewCompletedTasks extends StatelessWidget {
  const ColumnViewCompletedTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Idea>(
      builder: (context, idea, _)=> Column(
        children: [
          ...idea.completedTasks.map((completedTask) => 
              ListTile(
            leading: Checkbox(value: true, onChanged: (bool? value) async => await IdeaManager.uncheckCompletedTask(idea, completedTask)),
            title: Text(completedTask.task),
            trailing: IconButton(icon: Icon(Icons.close), onPressed: (){})
            
              ),
        ).toList()
        ],
      ),
    );
  }
}