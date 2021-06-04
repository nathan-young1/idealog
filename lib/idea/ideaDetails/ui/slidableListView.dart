import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/idea/ideaDetails/code/ideaManager.dart';
import 'package:idealog/global/extension.dart';


class SlidableListView extends StatelessWidget {
  const SlidableListView({
    Key? key,
    required this.slidableIconState,
    required this.idea,
    required this.completedTask
  }) : super(key: key);

  final ValueNotifier<bool> slidableIconState;
  final IdeaModel idea;
  final List<int> completedTask;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
       controller: SlidableController(
        onSlideIsOpenChanged: (bool? value) =>slidableIconState.value = value!,
        onSlideAnimationChanged: (_){}
        ),

       secondaryActions: [
        IconSlideAction(
          icon: Icons.delete,
          color: LightPink,
          caption: 'Delete',
          onTap: () async =>
          await IdeaManager.deleteCompletedTask(idea, completedTask)
        )
       ],
      child: ListTile(

      leading: Checkbox(
      value: true,

      onChanged: (bool? value) async =>
      await IdeaManager.uncheckCompletedTask(idea, completedTask)
      ),
      
      title: Text(completedTask.toAString),
      trailing: SlidableControllerButton(slidableIconState),

        ),
    );
  }
}






class SlidableControllerButton extends StatelessWidget {

  final ValueNotifier<bool> slidableIconState;
  
  SlidableControllerButton(this.slidableIconState);

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