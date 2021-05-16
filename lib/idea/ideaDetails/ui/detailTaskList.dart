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

class _CompletedTasks extends StatefulWidget {
  final Idea idea;
  _CompletedTasks({required this.idea});

  @override
  __CompletedTasksState createState() => __CompletedTasksState();
}

class __CompletedTasksState extends State<_CompletedTasks> {
  late final SlidableController slidableController;

  void slidableChanged(bool value) => setState(()=>slidableIsOpen = value);


  bool slidableIsOpen = false;

  @protected
    void initState() {
      
    slidableController = SlidableController(
    onSlideIsOpenChanged: slidableChanged,
    onSlideAnimationChanged: (_){}
    );
    
      super.initState();
    }

  @override
  Widget build(BuildContext context) {

    return Column(
            children: [
            Center(child: Text('Completed Tasks',style: Overpass.copyWith(fontSize: 25,fontWeight: FontWeight.w300))),
            ...Provider.of<Idea>(context).completedTasks.map((completedTask) => 
            GestureDetector(
              child: Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.2,
                 controller: slidableController,
                child: ListTile(
                leading: Checkbox(
                value: true,
                 onChanged: (bool? value) async =>
                  await IdeaManager.uncheckCompletedTask(widget.idea, completedTask)),
                title: Text(completedTask.toAString),
                trailing: SlidableControllerButton(slidableIsOpen)),
                 secondaryActions: [
                  IconSlideAction(
                    icon: Icons.delete,
                    color: LightPink,
                    caption: 'Delete',
                    onTap: () async =>
                    await IdeaManager.deleteCompletedTask(widget.idea, completedTask)
                  )
                 ],
              ),
            )).toList()],
        );
  }
}

class SlidableControllerButton extends StatelessWidget {

  //To know if slidable is open
  final bool slidableIsOpen;
  SlidableControllerButton(this.slidableIsOpen);

  //I am checking for rendering mode so that the icon does not change for all the list tiles only the open one
  bool thisTileIsOpen(context)=> (slidableIsOpen && Slidable.of(context).renderingMode == SlidableRenderingMode.slide);

  @override
  Widget build(BuildContext context) {

    return AnimatedContainer(
      duration: Duration(milliseconds: 700),
      child: thisTileIsOpen(context)
      ? IconButton(icon:Icon(Icons.arrow_forward_ios,size: 24),
      onPressed: () async =>Slidable.of(context).close()
      )
      : IconButton(icon:Icon(Icons.more_vert),
      onPressed: () async => Slidable.of(context).open(actionType: SlideActionType.secondary)
      ),
    );
  }
}