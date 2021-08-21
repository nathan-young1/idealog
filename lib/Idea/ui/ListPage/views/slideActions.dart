import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/Idea/ui/Others/AddTasks.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';

class TaskAdderSlideAction extends StatelessWidget {
  const TaskAdderSlideAction({
    Key? key,
    required this.idea,
  }) : super(key: key);

  final Idea idea;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>
                      AddTasksToExistingIdea(idea: idea)));
        // close the slidable.
        Slidable.of(context)!.close();
      },
      child: Container(
        decoration: BoxDecoration(
          color: ActiveTabLight,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 37,
              color: Colors.white,
            ),
            Text('New Task',style: TextStyle(fontSize: 13,color: Colors.white))
          ],
        ),
      ),
    );
  }
}


class DeleteSlideAction extends StatelessWidget {
  const DeleteSlideAction({
    Key? key,
    required this.idea
  }) : super(key: key);

  final Idea idea;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        /// close the slidable before showing the alertDialog on whether the user want's to delete.
        Slidable.of(context)!.close();
        // if (await showDeleteDialog(context: context)) 
        await Future.delayed(Duration(milliseconds: 200),
                  () async => await IdeaManager.deleteIdeaFromDb(idea));
                  // show idea has been deleted flushbar.
        
        },
      child: Container(
        decoration: BoxDecoration(
          color: LightPink,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10)
            ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete,
              size: 35,
              color: Colors.white,
            ),
            Text('Delete',style: TextStyle(fontSize: 13,color: Colors.white))
          ],
        ),
      ),
    );
  }
}
