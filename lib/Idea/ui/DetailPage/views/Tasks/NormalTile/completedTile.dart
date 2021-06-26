import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/Idea/ui/DetailPage/views/Tasks/MultiSelectTile/Notifier.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/global/extension.dart';
import 'package:provider/provider.dart';


class CompletedTaskTile extends StatelessWidget {
  
  CompletedTaskTile({
    Key? key,
    required this.idea,
    required this.completedTask
  }) : super(key: key);

  final ValueNotifier<bool> slidableIconState = ValueNotifier(false);
  final Idea idea;
  final Task completedTask;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
       controller: SlidableController(
        onSlideIsOpenChanged: (bool? value) => slidableIconState.value = value!,
        onSlideAnimationChanged: (_){}
        ),

       secondaryActions: [
        IconSlideAction(
          icon: Icons.delete,
          color: LightPink,
          caption: 'Delete',
          onTap: () async =>
          await IdeaManager.deleteTask(idea, completedTask)
        )
       ],

      child: GestureDetector(
        onLongPress: ()=> Provider.of<MultiSelect>(context,listen: false).startMultiSelect(completedTask),
        child: ListTile(
        leading: Checkbox(
        value: true,
        onChanged: (bool? value) async =>
        await IdeaManager.uncheckCompletedTask(idea, completedTask, idea.uncompletedTasks)
        ),
        
        title: Text(completedTask.task.toAString),
        trailing: SlidableIconButton(slidableIconState),
          ),
      ),
    );
  }
}






class SlidableIconButton extends StatelessWidget {

  final ValueNotifier<bool> slidableIconState;
  
  SlidableIconButton(this.slidableIconState);

  /* Events like add a list item causes the value notifier to reintialize to false, which results in controller icon
     to revert to default while the slidable is open.. In other to checkmate the problem _onListUpdate(context) checks
     if the controller icon is at default (more_vert) while the rendering mode is open(SlidableRenderingMode.slide).

    NOTE: we are checking if button controller is at default with (!slidableIconIsOpen) which means slidable icon is not open
  */

  void _onListUpdate(context){
    if(!slidableIconState.value && Slidable.of(context)!.renderingMode == SlidableRenderingMode.slide) {
      Slidable.of(context)!.close();
    }
  }
  
  @override
  Widget build(BuildContext context) {

    _onListUpdate(context);

    return ValueListenableBuilder(
      valueListenable: slidableIconState,
      builder: (context, bool _slidableIconisOpen,child) =>
      AnimatedContainer(
        duration: Duration(milliseconds: 500),
        child: _slidableIconisOpen
        ? IconButton(icon:Icon(Icons.arrow_forward_ios,size: 24),
        onPressed: () =>Slidable.of(context)!.close()
        )
        : IconButton(icon:Icon(Icons.more_vert),
        onPressed: () => Slidable.of(context)!.open(actionType: SlideActionType.secondary)
        ),
      ),
    );
  }
}