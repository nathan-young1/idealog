import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/Databases/idealog-db/idealog_config.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';

enum Direction {Up, Down}

class ReorderableGroupedListController with ChangeNotifier{
  ReorderableGroupedListController._();
  static ReorderableGroupedListController instance = ReorderableGroupedListController._();
  
  int height = 20;

  bool _draggableIsGoingUp = false;

  Direction get draggableDirection => (_draggableIsGoingUp) ? Direction.Up : Direction.Down;

  /// Updates the draggable direction only if there was a change in direction.
  void updateDraggableDirection(DragUpdateDetails dragUpdateDetails){
    bool isGoingUp = dragUpdateDetails.delta.direction.isNegative ? true : false;

    // only update if there was a change in direction.
    if (isGoingUp != _draggableIsGoingUp){
      _draggableIsGoingUp = isGoingUp;
      notifyListeners();
    }
  }
}

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.idea.uncompletedTasks.forEach((e) => print(e.priority));
    print('The length is ${widget.idea.uncompletedTasks.length}');


    return SafeArea(
      child: Scaffold(
        backgroundColor: uncompletedTasksColor,
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text("Uncompleted Tasks", style: overpass.copyWith(fontSize: 25, color: Colors.white))),
                    Expanded(
                      flex: 1,
                      child: IconButton(onPressed: ()=> Navigator.of(context).pop(),
                      icon: Icon(FeatherIcons.chevronDown, size: 30, color: Colors.white)),
                    ),
                ]),
              ),

              Expanded(
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
              )
          ],
        ),
      ),
    );
  }


  Widget ReorderableGroupedList ({required Idea idea, required int priorityGroup, required ScrollController scrollController}){

  List<Task> groupTasks = idea.uncompletedTasks.where((task) => task.priority == priorityGroup).toList();
    
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
          itemCount: groupTasks.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index){
          ValueNotifier<double> notifier = ValueNotifier(0);
            return DragTarget<Task>(
                
                onAccept: (_){
                  notifier.value = 0;

                  if(_.priority != priorityGroup){
                    _.priority = priorityGroup;
                  }
                  //////////////////////////////////////////
                  int amountToAddToIndex = 0;
                  if(_.priority == Priority_Low){
                    amountToAddToIndex = idea.uncompletedTasks.length - groupTasks.length;
                  } else if(_.priority == Priority_Medium){
                    amountToAddToIndex = idea.uncompletedTasks.where((e) => e.priority == Priority_High).length;
                  }
                  ////////////////////////////////////////////////
                  
                  
                  int incomingIndex =  idea.uncompletedTasks.indexOf(_);
                  int recieverIndex = idea.uncompletedTasks.indexOf(groupTasks[index]);

                  idea.uncompletedTasks.remove(_);
                 
                  if (incomingIndex < recieverIndex)
                    idea.uncompletedTasks.insert((index+amountToAddToIndex)-1, _);
                  else
                    idea.uncompletedTasks.insert((index+amountToAddToIndex), _);
                
                    
                setState((){});

                },
                onMove: (_){
                  if(_.data != groupTasks[index]){
                    if(notifier.value == 0.0){
                      notifier.value = 40;
                    }
                  }
                },
                onLeave: (_){
                  notifier.value = 0;
                },
                builder: (_,__,___)=> 
                LongPressDraggable<Task>(
                  feedbackOffset: Offset(0, 10),
                  maxSimultaneousDrags: 1,
                  axis: Axis.vertical,
                  childWhenDragging: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                      color: Colors.grey,),
                  onDragUpdate: (dragUpdateDetails){
                    ReorderableGroupedListController.instance.updateDraggableDirection(dragUpdateDetails);
                    // scroll the page with the drag widget.
                    scrollController.position.pointerScroll(dragUpdateDetails.delta.dy);
                  },
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
                      builder: (BuildContext context,_,__) {

                        return AnimatedPadding(
                          padding: (ReorderableGroupedListController.instance.draggableDirection == Direction.Up)
                          ?EdgeInsets.only(top: _)
                          :(ReorderableGroupedListController.instance.draggableDirection == Direction.Down && index == 0)
                          ?EdgeInsets.only(top: _)
                          :(index == 0)?EdgeInsets.only(bottom: _):EdgeInsets.only(top: _),

                          duration: Duration(milliseconds: 200),
                          child: ListTile(
                          key: UniqueKey(),
                          leading: Checkbox(value: false, onChanged: (bool? value) {}),
                          title: Text(groupTasks[index].task),
                          trailing: IconButton(icon: Icon(FontAwesomeIcons.gripLines), onPressed: (){})
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
            onAccept: (_){
              if(_.priority != priorityGroup){
                    _.priority = priorityGroup;
              }

              idea.uncompletedTasks.remove(_);
              int whereToAddto = idea.uncompletedTasks.indexOf(idea.uncompletedTasks.where((e) => e.priority == priorityGroup).last);
              idea.uncompletedTasks.insert(++whereToAddto, _);
              // idea.uncompletedTasks.add(_);
              setState(() {});
            },
            builder: (context,_,__)=> Container()),
        ),
      ],
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
