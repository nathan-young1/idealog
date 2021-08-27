import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/Others/AddTasks.dart';
import 'package:idealog/Prefs&Data/phoneSizeInfo.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class GotoAddTasksPage extends StatelessWidget {
  const GotoAddTasksPage({
    Key? key,
    required this.borderRadius,
  }) : super(key: key);

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {

    return Consumer<Idea>(
      builder: (context, Idea idea,_) =>
      GestureDetector(
        onTap: ()=> Navigator.of(context).push(PageTransition(child: AddTasksToExistingIdea(idea: idea), type: PageTransitionType.rightToLeftWithFade)),
        child: Container(
          height: 100, width: 130,
        decoration: BoxDecoration(borderRadius: borderRadius,color: DarkBlue),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            Icon(Icons.add, size: 35, color: Colors.white),
            Text('Add Task',style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_23, color: Colors.white))
          ]),
        )),
      ),
    );
  }
}
