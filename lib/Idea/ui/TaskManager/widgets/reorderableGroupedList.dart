 import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/Databases/idealog-db/idealog_config.dart';
import 'package:idealog/Idea/ui/TaskManager/code/reorderListController.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';

// A reorderable list view for task in a particular priority group.
class SingleReorderableGroupedList extends StatelessWidget{
  SingleReorderableGroupedList({required this.idea, required this.priorityGroup, required this.scrollController});
  
  final Idea idea;
  final int priorityGroup;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
      return Consumer<Idea>(
      builder: (BuildContext context, Idea idea, _){

        List<Task> groupTasks = idea.getListForPriorityGroup(priorityGroup);

        return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text((priorityGroup == Priority_High)
            ?'High Priority'
            :(priorityGroup == Priority_Medium) ? 'Medium Priority' : 'Low Priority',
             style: overpass.copyWith(fontSize: 22, fontWeight: FontWeight.w500)),
          ),
    
          ListView.builder(
            shrinkWrap: true,
            itemCount: idea.getListForPriorityGroup(priorityGroup).length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index){
            ValueNotifier<double> notifier = ValueNotifier(0);
    
              return DragTarget<Task>(
                  
                  onAccept: (draggedTask)=>
                    ReorderListController.instance.reorderList(
                    incomingTask: draggedTask,
                    idea: idea,
                    recieverTask: groupTasks[index],
                    priorityGroup: priorityGroup,
                    notifier: notifier),

                  onMove: (incomingTask) =>
                    ReorderListController.increasePadding(
                    notifier: notifier,
                    incomingTask: incomingTask.data,
                    recieverTask: groupTasks[index]),
    
                  onLeave: (_)=> ReorderListController.removePadding(notifier),
                  builder: (_,__,___)=> 
                  LongPressDraggable<Task>(
                    dragAnchorStrategy: (draggable, context , position){
                      // I am adding position(dx) gotten from the child because without it the drag will be anchored to
                      // the pointer's dx offset, Then i am adding 20 to dy offset so that the pointer can be at the center of the drag
                      // since the feedback size is 40;
                      Offset toBeReturned = Offset(position.dx, Offset.zero.dy + 20);
                      return toBeReturned;
                    },
                    maxSimultaneousDrags: 1,
                    axis: Axis.vertical,
                    childWhenDragging: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey),
                      onDragUpdate: (dragUpdateDetails) =>
                          ReorderListController.instance.scrollPageWithDraggable(
                            scrollController: scrollController,
                            dragUpdateDetails: dragUpdateDetails,
                            context: context),
    
                    onDragEnd: (_)=>  ReorderListController.instance.stopScrolling(),
                    data: groupTasks[index],
    
                    feedback: Material(
                      child: Container(
                        decoration: elevatedBoxDecoration.copyWith(color: Colors.white),
                        width: MediaQuery.of(context).size.width,
                        child: ListTile(
                        leading: Checkbox(value: false, onChanged: (bool? value) {}),
                        title: Text(groupTasks[index].task,overflow: TextOverflow.ellipsis),
                        trailing: IconButton(icon: Icon(FontAwesomeIcons.gripLines), onPressed: (){})
                          ),
                      ),
                    ),
                    child: ValueListenableBuilder<double>(
                        valueListenable: notifier,
                        builder: (BuildContext context,double padding,__) {
    
                          return AnimatedPadding(
                            padding: ReorderListController.instance.animatePaddingTo(
                              padding: padding,
                              currentIndex: index),
    
                            duration: Duration(milliseconds: 200),
                            child: ListTile(
                            key: UniqueKey(),
                            title: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(groupTasks[index].task),
                            ),
                            trailing: Icon(FontAwesomeIcons.gripLines)
                              ),
                          );
                        }
                      )
                  ),
                );
                }
          ),
    
          Container(
            height: 70,
            padding: idea.getListForPriorityGroup(priorityGroup).isEmpty? EdgeInsets.symmetric(vertical: 10): null,
            child: DragTarget<Task>(
              onAccept: (incomingTask) async =>
                await ReorderListController.instance.addTaskToBottomOfPriorityGroup(
                 incomingTask: incomingTask,
                 priorityGroup: priorityGroup,
                 idea: idea,
                 groupTasks: groupTasks),
                 
              builder: (context,_,__){ 
                bool thereIsTasksInThisPriorityGroup = idea.getListForPriorityGroup(priorityGroup).isNotEmpty;
                return Container(
                color: (!thereIsTasksInThisPriorityGroup)? LightGray : null,
                child: (!thereIsTasksInThisPriorityGroup)
                ? Center(child: Text("Drag a task here to add to these group"))
                : null
              );}),
          ),

          
        ],
      );
      }
    );
  }         
}


/// The list when the page is in reordering mode.
class ReorderableListForAllPriorityGroups extends StatelessWidget {
  const ReorderableListForAllPriorityGroups({Key? key, required this.idea, required this.scrollController}) : super(key: key);
  final Idea idea;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleReorderableGroupedList(idea: idea, priorityGroup: Priority_High, scrollController: scrollController),
        SingleReorderableGroupedList(idea: idea, priorityGroup: Priority_Medium, scrollController: scrollController),
        SingleReorderableGroupedList(idea: idea, priorityGroup: Priority_Low, scrollController: scrollController)
      ],
    );
  }
}