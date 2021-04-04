import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/customDecoration/boxDecoration.dart';
import 'package:idealog/idea/ideaDetails/ui/ideaDetails.dart';
import 'package:idealog/idea/ui/addToExisting.dart';
import 'package:idealog/sqlite-db/sqlite.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class IdeaCard extends StatelessWidget {
  final Idea info;
  IdeaCard({required this.info});

  @override
  Widget build(BuildContext context) {
    final int uncompletedTasksSize = info.tasks!.uncompletedTasks.length;
    final int completedTasksSize = info.tasks!.completedTasks.length;
    final int totalNumberOfTasks = uncompletedTasksSize + completedTasksSize;
    final double percent = (completedTasksSize/totalNumberOfTasks)*100;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 30),
      child: GestureDetector(
        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>IdeaDetail(detail: info))),
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
                      children: [
                        Expanded(
                          flex: 2,
                          child: Center(child: Text(info.ideaTitle,style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis))),
                        Expanded(
                        flex: 1, 
                        child: Center(
                          child: PopupMenuButton<int>(
                          iconSize: 35,
                          padding: EdgeInsets.zero,
                          onSelected: (_) async=> await Sqlite.deleteFromDB(uniqueId: '${info.uniqueId}'),
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
                      ),
                        ))
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
                              initialValue: 40,
                              innerWidget: (double percent)=> Center(child: Text('${percent.toInt()}%',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),)),
                              appearance: CircularSliderAppearance(
                                angleRange: 360,
                                customWidths: CustomSliderWidths(
                                  progressBarWidth: 6,
                                  trackWidth: 6
                                ),
                                customColors: CustomSliderColors(
                                  dotColor: Colors.transparent,
                                  // progressBarColor: Colors.blueGrey,
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
              onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddToExistingIdea(idea: info))),
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