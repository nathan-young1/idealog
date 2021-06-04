import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/idea/ideaDetails/code/ideaManager.dart';
import 'package:idealog/idea/listPage/ui/ideaCard/SlideClipPath.dart';

import '../addToExisting.dart';

class TaskAdderSlideAction extends StatelessWidget {
  const TaskAdderSlideAction({
    Key? key,
    required this.idea,
  }) : super(key: key);

  final IdeaModel idea;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: SlidableIconContainerClipper(),
      child: Container(
        decoration: BoxDecoration(
          color: ActiveTabLight,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10)
            ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 35,
              color: Colors.white,
              icon: Icon(Icons.add),
              onPressed: ()=> Navigator.of(context).push(
              MaterialPageRoute(builder: (context)=>
              AddToExistingIdea(idea: idea))),
            ),
            Text('Add Task',style: TextStyle(fontSize: 10,color: Colors.white))
          ],
        ),
      ),
    );
  }
}


class DeleteSlideAction extends StatelessWidget {
  const DeleteSlideAction({
    Key? key,
    required this.idea,
  }) : super(key: key);

  final IdeaModel idea;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: SlidableIconContainerClipper(),
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
            IconButton(
              iconSize: 35,
              color: Colors.white,
              icon: Icon(Icons.delete),
              onPressed: () async => 
              await IdeaManager.deleteIdeaFromDb(idea),
            ),
            Text('Delete',style: TextStyle(fontSize: 13,color: Colors.white))
          ],
        ),
      ),
    );
  }
}
