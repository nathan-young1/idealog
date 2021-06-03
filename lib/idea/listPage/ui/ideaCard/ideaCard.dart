import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/idea/ideaDetails/code/ideaManager.dart';
import 'package:idealog/idea/ideaDetails/ui/ideaDetails.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../addToExisting.dart';
import 'ToggleSlidable.dart';

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
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        controller: SlidableController(
        onSlideIsOpenChanged: (bool value) =>slidableIconState.value = value,
        onSlideAnimationChanged: (_){}
        ),
        child: GestureDetector(
          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>IdeaDetail(idea: idea))),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10,bottom: 10,left: 20,right: 10),
                decoration: BoxDecoration(
                  color: IdeaCardLight,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PercentageIncidator(percent: percent),
                          IdeaTitle(idea: idea),
                          ToggleSlidable(slidableIconState: slidableIconState)
                        ],
                      )
                ],),
              )
            ],
          ),
        ),
        secondaryActions: [
                  IconSlideAction(
                    icon: Icons.add,
                    color: DarkBlue,
                    caption: 'Add Task',
                    onTap: ()=>
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>
                        AddToExistingIdea(idea: idea)))
                  ),
                  IconSlideAction(
                    icon: Icons.delete,
                    color: LightPink,
                    caption: 'Delete',
                    onTap: () async =>
                    await IdeaManager.deleteIdeaFromDb(idea)
                  )
                  ]
      ),
    );
  }
}


class IdeaTitle extends StatelessWidget {
  const IdeaTitle({
    Key? key,
    required this.idea,
  }) : super(key: key);

  final IdeaModel idea;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(child: Text(idea.ideaTitle,
      style: ReemKufi.copyWith(fontSize: 30),
      overflow: TextOverflow.ellipsis)));
  }
}

class PercentageIncidator extends StatelessWidget {
  const PercentageIncidator({
    Key? key,
    required this.percent,
  }) : super(key: key);

  final double percent;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
    message: 'Completed tasks in percent',
    child: IgnorePointer(
      child: Container(
        height: 55,
        width: 55,
        child: SleekCircularSlider(
          initialValue: percent,
          innerWidget: (double percent)=> Center(
            child: Text('${percent.toInt()}%',
            style: TextStyle(fontSize: 16))),
          appearance: CircularSliderAppearance(
            animationEnabled: false,
            angleRange: 360,
            customWidths: CustomSliderWidths(
              progressBarWidth: 6,
              trackWidth: 6
            ),
            customColors: CustomSliderColors(
              dotColor: Colors.transparent,
              progressBarColor: AddToExistingLight,
              trackColor: Colors.white
            )
          ),
        )),
    ),
                      );
  }
}