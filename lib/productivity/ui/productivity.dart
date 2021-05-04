import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/analytics/analyticsSql.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/productivity/code/productivityManager.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Productivity extends StatefulWidget {
  @override
  _ProductivityState createState() => _ProductivityState();
}

class _ProductivityState extends State<Productivity> {

  @override
  Widget build(BuildContext context) {
    double completionRate = Provider.of<ProductivityManager>(context).getCompletionRate();
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 25,left: 20,right: 10,bottom: 20),
          child: Text('Productivity',
          style: Poppins.copyWith(fontSize: 30)),
        ),
        Expanded(
          child: ListView(
            children: [
              TaskCompletionRate(completionRate),
              SizedBox(height: 25),
              FavoriteTask(),
              SizedBox(height: 25),
              ActiveDaysChart()
            ],
          ),
        ),
      ],
    );
  }
}

enum RateType{UNCOMPLETED,COMPLETED}
class CompletionRate{
  late Color color;
  double percent;
  late String typeOfCompletion;
  CompletionRate(this.percent,RateType type){
    typeOfCompletion = (type == RateType.COMPLETED) ? 'Completed' : 'Uncompleted';
    color = (type == RateType.COMPLETED) ? Color.fromRGBO(102, 133, 157, 1) : Color.fromRGBO(156, 92, 92, 1) ;
  }
}


class FavoriteTask extends StatelessWidget {
  const FavoriteTask({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Idea> favorites = Provider.of<ProductivityManager>(context).getFavoriteTasks();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromRGBO(157, 118, 118, 0.2),
          ),
          padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text('Favorite Tasks',
            style: RhodiumLibre.copyWith(fontSize: 27)),
            for(int index = 0; index <= favorites.length-1; index++)
            ListTile(leading: (index == 0)?FaIcon(FontAwesomeIcons.solidHeart,color: Colors.red[700])
                :(index == 1)?FaIcon(FontAwesomeIcons.solidHeart,color: Colors.blue)
                :FaIcon(FontAwesomeIcons.solidHeart,color: Colors.amber),
            title: Text(favorites[index].ideaTitle),
            trailing: Icon(Icons.arrow_forward_ios))
            ],
        ),
      ),
    );
  }
}

class TaskCompletionRate extends StatelessWidget {
  late double percent;

  TaskCompletionRate(double percent){
    this.percent = percent*100;
    double other = 100 - (percent*100);
    rate = [
      
    CompletionRate(100 - this.percent, RateType.UNCOMPLETED),
    CompletionRate(this.percent, RateType.COMPLETED)
    ];
  }
  late List<CompletionRate> rate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: LightGray,
        ),
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Tasks Completion Rate',
            style: RhodiumLibre.copyWith(fontSize: 22)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: SfCircularChart(
                    
                    series: <CircularSeries>[
                      PieSeries<CompletionRate,String>(
                        dataSource: this.rate,
                        pointColorMapper: (CompletionRate r,_)=> r.color,
                        xValueMapper: (CompletionRate r,_)=> r.typeOfCompletion,
                        yValueMapper: (CompletionRate r,_)=> r.percent,
                        // Radius of pie
                        radius: '100%',
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true
                        ),
                        dataLabelMapper: (_,__)=> '${_.percent.toInt()}%',
                        explode: true,
                        explodeGesture: ActivationMode.singleTap
                      )
                    ],
                  ),
                ),

              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Center(
                    child: Row(
                    children: [
                      Container(height: 25, width: 25, color: Color.fromRGBO(102, 133, 157, 1)),
                      SizedBox(width: 5),
                      Text('Completed Tasks',
                      style: Peddana.copyWith(fontSize: 25)),
                    ],)
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Center(
                    child: Row(
                    children: [
                      Container(height: 25, width: 25, color: Color.fromRGBO(156, 92, 92, 1)),
                      SizedBox(width: 5),
                      Text('Uncompleted Tasks',
                      style: Peddana.copyWith(fontSize: 25)),
                    ],
                  ),),
                ),
              ],
            )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ActiveDaysChart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<AnalyticsData> analytics = Provider.of<List<AnalyticsData>>(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
      child: Container(
        width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: LightGray,
          ),
          padding: EdgeInsets.symmetric(vertical: 20),

        child: SfCartesianChart(
              title: ChartTitle(
                text: 'Active Days',
                textStyle: RhodiumLibre.copyWith(fontSize: 27)
              ),
              tooltipBehavior: TooltipBehavior(
                shouldAlwaysShow: true,
                enable: true,
                canShowMarker: false,
                format: 'point.x:\npoint.y tasks completed',
                header: 'Productivity',
                color: Colors.grey,
                animationDuration: 500,
                textStyle: TextStyle(fontSize: 17,fontWeight: FontWeight.w500)
                ),
              plotAreaBorderColor: Colors.transparent,
              primaryYAxis: NumericAxis(
                labelStyle: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),
                majorGridLines: MajorGridLines(width: 0),
                majorTickLines: MajorTickLines(width: 0),
                title: AxisTitle(
                text: 'Number of tasks completed',
                textStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.deepOrange.withOpacity(0.7)))
              ),
              primaryXAxis: DateTimeCategoryAxis(
                intervalType: DateTimeIntervalType.days,
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                // maximum: DateTime.now(),
                majorTickLines: MajorTickLines(size: 10,width: 0),
                majorGridLines: MajorGridLines(width: 0),
                labelStyle: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),
                title: AxisTitle(
                  text: 'Date',
                  textStyle: TextStyle(fontSize: 21,fontWeight: FontWeight.w500,color: Colors.deepOrange.withOpacity(0.7))
                )
              ),
              series: <ChartSeries>[
                  SplineAreaSeries<AnalyticsData,DateTime>(
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    color: Colors.white,
                    height: 12,
                    width: 12
                  ),
                  cardinalSplineTension: 0.7,
                  gradient: LinearGradient(colors: [Colors.blueGrey.withOpacity(0.7),Colors.white.withOpacity(0.5)]),
                   dataSource: analytics,
                   splineType: SplineType.cardinal,
                   xValueMapper: (AnalyticsData analytic,_)=>analytic.date,
                   yValueMapper: (AnalyticsData analytic,_)=>analytic.numberOfTasksCompleted
                  )
              ],
        ),
      ),
    );
  }
}
