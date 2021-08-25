import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/TaskManager/pages/completedTasksPage.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/animatedListTile.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/customWidget/flushbar.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';

class GotoCompletedPage extends StatelessWidget {
  const GotoCompletedPage({
    Key? key,
    required this.borderRadius,
  }) : super(key: key);

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Consumer<Idea>(
      builder: (context, Idea idea,_) => 
      GestureDetector(
        onTap: (){
          // if there is no completedTasks then show this flushbar otherwise navigate to the completed tasks page.
          if(idea.completedTasks.isEmpty) return tasksDoesNotExistForThisPageFlushBar(context: context, pageCalledFrom: TaskPage.COMPLETED);

          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=> CompletedTasksPage(idea: idea))
          );
        },
        child: Container(height: 130, width: 130,
        decoration: BoxDecoration(borderRadius: borderRadius,color: (idea.completedTasks.isNotEmpty)? completedTasksColor : Colors.grey.shade400),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Black242424.withOpacity(0.2)),
              child: Icon(Icons.flag,color: Colors.white,size: 18)
            ),
            Flexible(child: Text('Completed Tasks',style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.small, color: Colors.white))),
            Align(
              alignment: Alignment.centerRight,
              child: Text('${idea.completedTasks.length}/${idea.completedTasks.length}',style: dosis.copyWith(fontSize: 14,color: Colors.white)))
          ],),
        ),),
      ),
    );
  }
}