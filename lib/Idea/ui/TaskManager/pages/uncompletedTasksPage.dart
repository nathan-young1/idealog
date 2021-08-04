import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/Databases/idealog-db/idealog_config.dart';
import 'package:idealog/Idea/ui/TaskManager/code/reorderListController.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';


class UncompletedTasksPage extends StatefulWidget {
  const UncompletedTasksPage({Key? key, required this.idea}) : super(key: key);
  final Idea idea;

  @override
  _UncompletedTasksPageState createState() => _UncompletedTasksPageState();
}

class _UncompletedTasksPageState extends State<UncompletedTasksPage> with SingleTickerProviderStateMixin{
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    widget.idea.uncompletedTasks.sort((a,b)=> a.priority!.compareTo(b.priority!));
    widget.idea.putTasksInTheirPriorityList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [ChangeNotifierProvider<Idea>.value(value: widget.idea)],
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight * 1.2),
            child: Container(
              color: uncompletedTasksColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  toolbarHeight: kToolbarHeight * 1.2,
                  title: Text("Uncompleted Tasks", style: overpass.copyWith(fontSize: 25, color: Colors.white)),
                  automaticallyImplyLeading: false,
                  actions: [
                    Container(
                      child: IconButton(onPressed: ()=> Navigator.of(context).pop(),
                      icon: Icon(FeatherIcons.chevronDown, size: 30, color: Colors.white)),
                    )
                  ],
                ),
              ),
            ),
          ),
          body: Container(
            color: uncompletedTasksColor,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              controller: scrollController,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40))
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 35, top: 10),
                        child: UncompletedTaskMenu(),
                      ),
              
                    ReorderableGroupedList(idea: widget.idea, priorityGroup: Priority_High, scrollController: scrollController),
                    ReorderableGroupedList(idea: widget.idea, priorityGroup: Priority_Medium, scrollController: scrollController),
                    ReorderableGroupedList(idea: widget.idea, priorityGroup: Priority_Low, scrollController: scrollController)
                    ],
                  ),
                )
              ),
            ),
          ),
        ),
      ),
    );
  }


  // ignore: non_constant_identifier_names
  Widget ReorderableGroupedList ({required Idea idea, required int priorityGroup, required ScrollController scrollController}){

  List<Task> groupTasks = idea.uncompletedTasks.where((task) => task.priority == priorityGroup).toList();
  // Store the high priority tasks, so i don't need to map over the entire list to get the last task.
  if(priorityGroup == Priority_High)
    ReorderListController.instance.setHighPriorityTasks(groupTasks);
    
    return Consumer<Idea>(

      builder: (BuildContext context, Idea idea, _){
        List<Task> groupTasks = getTasksForPriorityGroup(priorityGroup, idea);
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
            itemCount: lengthOfTasksForPriorityGroup(priorityGroup, idea),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index){
            ValueNotifier<double> notifier = ValueNotifier(0);
    
              return DragTarget<Task>(
                  
                  onAccept: (draggedTask){
    
                    ReorderListController.instance.reorderList(
                    incomingTask: draggedTask,
                    idea: idea,
                    recieverTask: groupTasks[index],
                    priorityGroup: priorityGroup,
                    notifier: notifier);
                      
                  setState((){});
    
                  },
                  onMove: (incomingTask) =>
                    ReorderListController.increasePadding(
                    notifier: notifier,
                    incomingTask: incomingTask.data,
                    recieverTask: groupTasks[index]),
    
                  onLeave: (_)=> ReorderListController.removePadding(notifier),
                  builder: (_,__,___)=> 
                  LongPressDraggable<Task>(
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
                        title: Text(groupTasks[index].task),
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
                            leading: Text('List index : '+idea.uncompletedTasks.indexOf(groupTasks[index]).toString()),
                            // leading: Checkbox(value: false, onChanged: (bool? value) {}),
                            title: Text(groupTasks[index].task),
                            trailing: Text('order index : '+groupTasks[index].orderIndex.toString()),
                            // trailing: IconButton(icon: Icon(FontAwesomeIcons.gripLines), onPressed: (){})
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
            child: DragTarget<Task>(
              onAccept: (incomingTask){
                ReorderListController.instance.addTaskToBottomOfPriorityGroup(
                 incomingTask: incomingTask,
                 priorityGroup: priorityGroup,
                 idea: idea,
                 groupTasks: groupTasks);
    
                setState(() {});
              },
              builder: (context,_,__)=> Container()),
          ),
        ],
      );
      }
    );         
}

}


enum _Menu{ReorderTasks}

class UncompletedTaskMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Container(
                decoration: elevatedBoxDecoration,
                child: TextField(
                  decoration: formTextField.copyWith(
                    hintText: 'Search for a task'
                  ),
                ),
              ),
            )),
          Expanded(
            flex: 1,
            child: PopupMenuButton<_Menu>(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(child: TextButton.icon(
                 onPressed: (){},
                 icon: Icon(FeatherIcons.move),
                 label: Text('Reorder Tasks', style: overpass.copyWith(fontSize: 16))),
                value: _Menu.ReorderTasks)
              ]),
          )
        ]
      ),
    );
  }
}

int lengthOfTasksForPriorityGroup(int priorityGroup, Idea idea){
  switch(priorityGroup){
      case Priority_High:
        return idea.highPriority.length;
      case Priority_Medium:
        return idea.mediumPriority.length;
      case Priority_Low:
        return idea.lowPriority.length;

      // This is suppose to never result in zero because the priority group is always between Priority_High and Priority_Low
      default:
        return 0;
  }
}

List<Task> getTasksForPriorityGroup(int priorityGroup, Idea idea) {

  switch(priorityGroup){
      case Priority_High:
        return idea.highPriority;
      case Priority_Medium:
        return idea.mediumPriority;
      case Priority_Low:
        return idea.lowPriority;

      // This is suppose to never result in default because the priority group is always between Priority_High and Priority_Low.
      default:
        return [];
  }
}