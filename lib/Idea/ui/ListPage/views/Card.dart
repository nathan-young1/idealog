import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:idealog/Idea/ui/DetailPage/Detail.dart';
import 'package:idealog/Idea/ui/ListPage/views/slideActions.dart';
import 'package:idealog/core-models/ideasModel.dart';

import 'mainTile.dart';

class IdeaCard extends StatelessWidget {
  final IdeaModel idea;
  final ValueNotifier<bool> slidableIconState;
  IdeaCard({required this.idea,required this.slidableIconState});


  @override
  Widget build(BuildContext context) {
    final uncompletedTasksSize = idea.uncompletedTasks.length;
    final completedTasksSize = idea.completedTasks.length;
    final totalNumberOfTasks = uncompletedTasksSize + completedTasksSize;
    //first check that the total number of tasks is not zero, so as not to have division by zero error
    // ignore: omit_local_variable_types
    final double percent = (totalNumberOfTasks != 0)?(completedTasksSize/totalNumberOfTasks)*100:0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 35),
      child:  GestureDetector(
        onTap: ()=> Navigator.push(context,
         MaterialPageRoute(builder: (context)=> IdeaDetail(idea: idea))),

        child: Slidable(
          key: UniqueKey(),
          movementDuration: Duration(milliseconds: 400),
          actionPane: SlidableBehindActionPane(),
          actionExtentRatio: 0.3,
          controller: SlidableController(
          onSlideIsOpenChanged: (bool? value) => slidableIconState.value = value!,
          onSlideAnimationChanged: (_){}
          ),
          secondaryActions: [
                    Transform.translate(
                      offset: Offset(-8,0),
                      child: TaskAdderSlideAction(idea: idea)),
            
                    Transform.translate(
                      offset: Offset(-18,0),
                      child: DeleteSlideAction(idea: idea))
                    ],
          child: MainTile(
                percent: percent,
                idea: idea,
                slidableIconState: slidableIconState
                )
        ),
      ),
    );
  }
}