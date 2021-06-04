import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/idea/ideaDetails/ui/ideaDetails.dart';
import 'package:idealog/idea/listPage/ui/ideaCard/slideActions.dart';
import 'mainTile.dart';

class IdeaCard extends StatelessWidget {
  final IdeaModel idea;
  final ValueNotifier<bool> slidableIconState;
  IdeaCard({required this.idea,required this.slidableIconState});


  @override
  Widget build(BuildContext context) {
    final int uncompletedTasksSize = idea.uncompletedTasks.length;
    final int completedTasksSize = idea.completedTasks.length;
    final int totalNumberOfTasks = uncompletedTasksSize + completedTasksSize;
    //first check that the total number of tasks is not zero, so as not to have division by zero error
    final double percent = (totalNumberOfTasks != 0)?(completedTasksSize/totalNumberOfTasks)*100:0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 35),
      child:  Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        controller: SlidableController(
        onSlideIsOpenChanged: (bool value) => slidableIconState.value = value,
        onSlideAnimationChanged: (_){}
        ),
        child: GestureDetector(
          onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>IdeaDetail(idea: idea))),
          child: Column(
            children: [
              MainTile(
                    percent: percent,
                    idea: idea,
                    slidableIconState: slidableIconState)
            ],
          ),
        ),
        secondaryActions: [
                  Transform.translate(
                    offset: Offset(-5,0),
                    child: TaskAdderSlideAction(idea: idea)),

                  Transform.translate(
                    offset: Offset(-5,0),
                    child: DeleteSlideAction(idea: idea))
                  ]
      ),
    );
  }
}