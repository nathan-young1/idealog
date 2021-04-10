import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/customDecoration/boxDecoration.dart';
import 'package:idealog/idea/ideaDetails/ui/ideaDetails.dart';
import 'package:idealog/idea/ui/addToExisting.dart';
import 'package:idealog/sqlite-db/sqlite.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class IdeaCard extends StatelessWidget {
  final Idea idea;
  IdeaCard({required this.idea});

  @override
  Widget build(BuildContext context) {
    final int uncompletedTasksSize = idea.uncompletedTasks.length;
    final int completedTasksSize = idea.completedTasks.length;
    final int totalNumberOfTasks = uncompletedTasksSize + completedTasksSize;
    final double percent = (completedTasksSize/totalNumberOfTasks)*100;
    print('$percent');
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 30),
      child: GestureDetector(
        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>IdeaDetail(idea: idea))),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10,bottom: 15,left: 10,right: 10),
              decoration: lightModeBackgroundColor.copyWith(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(child: Text(idea.ideaTitle,style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis))),
                        PopupMenuButton<int>(
                        iconSize: 35,
                        padding: EdgeInsets.zero,
                        onSelected: (_) async=> await Sqlite.deleteFromDB(uniqueId: '${idea.uniqueId}'),
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                        PopupMenuItem<int>( 
                          value: 0,
                          child:  Container(
                            child: Row(
                              children: [
                              Icon(Icons.delete_sweep,size: 30),
                              SizedBox(width: 10),
                              Text('Delete',style: TextStyle(fontSize: 18))
                            ],),
                          ),
                        )],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      )
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(children: [
                      Tooltip(
                        message: 'Completed tasks in percent',
                        child: IgnorePointer(
                          child: Container(
                            height: 60,
                            width: 60,
                            child: SleekCircularSlider(
                              initialValue: percent,
                              innerWidget: (double percent)=> Center(child: Text('${percent.toInt()}%',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),)),
                              appearance: CircularSliderAppearance(
                                angleRange: 360,
                                customWidths: CustomSliderWidths(
                                  progressBarWidth: 6,
                                  trackWidth: 6
                                ),
                                customColors: CustomSliderColors(
                                  dotColor: Colors.transparent,
                                  progressBarColor: Colors.blueGrey,
                                  trackColor: Colors.white
                                )
                              ),
                            )),
                        ),
                      ),
                      SizedBox(width: 15),
                      if(uncompletedTasksSize != 0)
                      Flexible(child: Text('Uncompleted Tasks: $uncompletedTasksSize',style: TextStyle(fontSize: 20),overflow: TextOverflow.ellipsis,)),
                      if(uncompletedTasksSize == 0 && completedTasksSize > 0)
                      Text('Tasks completed',style: TextStyle(fontSize: 20)),
                      if(uncompletedTasksSize == 0 && completedTasksSize == 0)
                      Text('No tasks available',style: TextStyle(fontSize: 20))
                    ],)
              ],),
            ),
            GestureDetector(
              onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddToExistingIdea(idea: idea))),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Add A New Task',style: TextStyle(color: Colors.black,fontSize: 20)),
                    SizedBox(width: 15),
                    FaIcon(FontAwesomeIcons.plus,color: Colors.grey[800])
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