import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/idea/ideaDetails/code/ideaManager.dart';
import 'package:idealog/idea/ideaDetails/ui/ideaDetails.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'addToExisting.dart';

class IdeaCard extends StatelessWidget {
  final IdeaModel idea;
  IdeaCard({required this.idea});

  @override
  Widget build(BuildContext context) {
    final int uncompletedTasksSize = idea.uncompletedTasks.length;
    final int completedTasksSize = idea.completedTasks.length;
    final int totalNumberOfTasks = uncompletedTasksSize + completedTasksSize;
    //first check that the total number of tasks is not zero, so as not to have division by zero error
    final double percent = (totalNumberOfTasks != 0)?(completedTasksSize/totalNumberOfTasks)*100:0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 35),
      child: GestureDetector(
        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>IdeaDetail(idea: idea))),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10,bottom: 10,left: 20,right: 10),
              decoration: BoxDecoration(
                color: IdeaCardLight,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(child: Text(idea.ideaTitle,
                          style: ReemKufi.copyWith(fontSize: 30),
                          overflow: TextOverflow.ellipsis))),
                        PopupMenuButton<int>(
                        iconSize: 33,
                        padding: EdgeInsets.zero,
                        onSelected: (_) async=> await IdeaManager.deleteIdeaFromDb(idea),
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                        PopupMenuItem<int>( 
                          value: 0,
                          child:  Container(
                            child: Row(
                              children: [
                              Icon(Icons.delete_sweep,size: 30,color: Colors.black54),
                              SizedBox(width: 10),
                              Text('Delete',style: TextStyle(fontSize: 18))
                            ],),
                          ),
                        )],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      )
                      ],
                    ),
                    Row(children: [
                      Tooltip(
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
                      ),
                      SizedBox(width: 8),
                      if(uncompletedTasksSize != 0)
                      Flexible(child: Text('Uncompleted Tasks: $uncompletedTasksSize',
                      style: ReemKufi.copyWith(fontSize: 22,fontWeight: FontWeight.w100),
                      overflow: TextOverflow.ellipsis)),
                      if(uncompletedTasksSize == 0 && completedTasksSize > 0)
                      Text('Tasks completed',
                      style: ReemKufi.copyWith(fontSize: 22,fontWeight: FontWeight.w100)),
                      if(uncompletedTasksSize == 0 && completedTasksSize == 0)
                      Text('No tasks available',
                      style: ReemKufi.copyWith(fontSize: 22,fontWeight: FontWeight.w100))
                    ],)
              ],),
            ),
            GestureDetector(
              onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddToExistingIdea(idea: idea))),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),
                  color: AddToExistingLight,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Add A New Task',
                    style: RhodiumLibre.copyWith(fontSize: 20,color: Colors.white)),
                    SizedBox(width: 15),
                    Icon(Icons.add,color: Colors.white,size: 35)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}