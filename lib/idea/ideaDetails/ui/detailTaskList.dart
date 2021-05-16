import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/idea/ideaDetails/code/ideaManager.dart';
import 'package:idealog/global/extension.dart';
import 'package:provider/provider.dart';

class DetailTasksList extends StatelessWidget {
  final Idea idea;
  const DetailTasksList({required this.idea});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Idea>.value(value: idea,
      child: Builder(
        builder: (BuildContext context) =>
          Column(
          children: [
            if(Provider.of<Idea>(context).uncompletedTasks.isNotEmpty)
            _UncompletedTasks(idea: idea),
            SizedBox(height: 30),
            if(Provider.of<Idea>(context).completedTasks.isNotEmpty)
            _CompletedTasks(idea: idea)
          ],
        ),
      ),
    );
  }
}

class _UncompletedTasks extends StatelessWidget {
  final Idea idea;
  _UncompletedTasks({required this.idea});

  @override
  Widget build(BuildContext context) {
    
    return Column(
            children: [
            Center(child: Text('Uncompleted Tasks',style: Overpass.copyWith(fontSize: 25,fontWeight: FontWeight.w300)),),
            ...Provider.of<Idea>(context).uncompletedTasks.map((uncompletedTask) => 
            ListTile(
            leading: Checkbox(value: false, onChanged: (bool? value) async =>
             await IdeaManager.completeTask(idea, uncompletedTask)),
            title: Text(uncompletedTask.toAString),
            trailing: IconButton(icon: Icon(Icons.close),onPressed: () async =>
             await IdeaManager.deleteUncompletedTask(idea, uncompletedTask)))).toList()],
        );
  }
}

class _CompletedTasks extends StatelessWidget {
  final Idea idea;
  _CompletedTasks({required this.idea});

  @override
  Widget build(BuildContext context) {

    return Column(
            children: [
            Center(child: Text('Completed Tasks',style: Overpass.copyWith(fontSize: 25,fontWeight: FontWeight.w300))),
            ...Provider.of<Idea>(context).completedTasks.map((completedTask) {

            
            ValueNotifier<bool> slidableIsOpen = ValueNotifier(false);
            return Slidable(
              key: Key(completedTask.toAString),
              actionPane: SlidableDrawerActionPane(key: Key(completedTask.toAString)),
              actionExtentRatio: 0.2,
               controller: SlidableController(
                onSlideIsOpenChanged: (bool value) =>slidableIsOpen.value = value,
                onSlideAnimationChanged: (_){}
                ),
              child: ListTile(
              leading: Checkbox(
              value: true,
               onChanged: (bool? value) async =>
                await IdeaManager.uncheckCompletedTask(idea, completedTask)),
              title: Text(completedTask.toAString),
              trailing: ValueListenableBuilder(
                valueListenable: slidableIsOpen,
                builder: (context, bool _isOpen,child) =>
                SlidableControllerButton(_isOpen,slidableIsOpen.value))),
               secondaryActions: [
                IconSlideAction(
                  icon: Icons.delete,
                  color: LightPink,
                  caption: 'Delete',
                  onTap: () async =>
                  await IdeaManager.deleteCompletedTask(idea, completedTask)
                )
               ],
            );
            }
            ).toList()],
        );
  }
}

class SlidableControllerButton extends StatelessWidget {

  //To know if slidable is open
  final bool slidableIsOpen;

  // To hold the value of the value notifer
  bool valueListenable;
  SlidableControllerButton(this.slidableIsOpen,this.valueListenable);

  // When an event occurs on the completed task list (like the add of a new item) the list is rebuit making the value
  // notifer slidableIsOpen to reintialize to false, this causes the icon to change to default (more-vert) while the 
  // slider is still open , so in other to close the slider whilst changing the icon in the occurence of any event ,
  // i am checking to see if the valueListenable (SlidableIsOpen.value) is false (the intialization default) while the
  // slidable is open. Note: i am using (!slidableIsOpen) to check if the slidable is open because on any event
  // reintialization the value given to the slidableIsOpen will be false (just like the valuelistenable) even though
  // it the slidable is actually open this is because the isOpenChanged of the slider is only called on button Tap
  // && slider not on creation. so if there is an event intialization , (!slidableIsOpen) will give us true to show that
  // the slidable is actually open just that the reintialization altered the value, WHILE valueListenable will be false
  // so we will call the close method, so that both button and slider will match&close on event reintialization.
  
  void closeSlidableOnOutsideTap(context){
    if (!slidableIsOpen && valueListenable == false)
    Slidable.of(context).close();
  }
  
  @override
  Widget build(BuildContext context) {
    closeSlidableOnOutsideTap(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 700),
      child: slidableIsOpen
      ? IconButton(icon:Icon(Icons.arrow_forward_ios,size: 24),
      onPressed: () async =>Slidable.of(context).close()
      )
      : IconButton(icon:Icon(Icons.more_vert),
      onPressed: () async => Slidable.of(context).open(actionType: SlideActionType.secondary)
      ),
    );
  }
}