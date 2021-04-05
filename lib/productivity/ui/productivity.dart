import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/analytics/analyticsSql.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Productivity extends StatefulWidget {
  @override
  _ProductivityState createState() => _ProductivityState();
}

class _ProductivityState extends State<Productivity> {
  @override
    void initState() {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async{await AnalyticsSql.readAnalytics(); });
      super.initState();
    }
  final List<_ActiveDays> thisWeek = [
    _ActiveDays(date: DateTime(2021,3,21), numberOfTasksCompleted: 5),
    _ActiveDays(date: DateTime(2021,3,8), numberOfTasksCompleted: 8),
    _ActiveDays(date: DateTime(2021,3,9), numberOfTasksCompleted: 4),
    _ActiveDays(date: DateTime(2021,3,15), numberOfTasksCompleted: 6),
    _ActiveDays(date: DateTime(2021,3,20), numberOfTasksCompleted: 7),
    _ActiveDays(date: DateTime(2021,2,25), numberOfTasksCompleted: 3),
    _ActiveDays(date: DateTime.now(), numberOfTasksCompleted: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 15,left: 20,right: 10),
          child: Text('Productivity',style: TextStyle(fontSize: 27,fontWeight: FontWeight.w600)),
        ),
        Expanded(
          child: ListView(
            children: [
              TaskCompletionRate(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(minHeight: 25,value: 0.6)),
              ),
              FavoriteTask(),
              SizedBox(height: 25),
              ActiveDaysChart(thisWeek: thisWeek)
            ],
          ),
        ),
      ],
    );
  }
}

class FavoriteTask extends StatelessWidget {
  const FavoriteTask({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Favorite Tasks'),
        ...List.generate(4, (index) => Row(
          children: [ 
            if(index == 0)FaIcon(FontAwesomeIcons.solidHeart,color: Colors.red[700])
            else if(index == 1)FaIcon(FontAwesomeIcons.solidHeart,color: Colors.blue)
            else FaIcon(FontAwesomeIcons.solidHeart,color: Colors.amber),
            Text('    $index my list'),
          ],
        )).toList()],
    );
  }
}

class TaskCompletionRate extends StatelessWidget {
  const TaskCompletionRate({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Tasks Completion Rate'),
        Container(
          height: 50,
          width: 160,
          child: Center(
            child: Row(
            children: [
              Container(height: 30, width: 30, color: Colors.teal[700]),
              SizedBox(width: 5),
              Text('Completed Tasks'),
            ],)
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: 160,
          child: Center(
            child: Row(
            children: [
              Container(height: 30, width: 30, color: Colors.grey),
              SizedBox(width: 5),
              Text('Uncompleted Tasks'),
            ],
          ),),
        )
      ],
    );
  }
}

class ActiveDaysChart extends StatelessWidget {
  const ActiveDaysChart({
    Key? key,
    required this.thisWeek,
  }) : super(key: key);

  final List<_ActiveDays> thisWeek;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: 350,
      child: SfCartesianChart(
        title: ChartTitle(
          text: 'Active Days',
          textStyle: TextStyle(fontSize: 27,fontWeight: FontWeight.w500)
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
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          maximum: DateTime.now(),
          majorTickLines: MajorTickLines(size: 10,width: 0),
          majorGridLines: MajorGridLines(width: 0),
          labelStyle: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),
          title: AxisTitle(
            text: 'Date',
            textStyle: TextStyle(fontSize: 21,fontWeight: FontWeight.w500,color: Colors.deepOrange.withOpacity(0.7))
          )
        ),
        series: <ChartSeries>[
            SplineAreaSeries<_ActiveDays,DateTime>(
            markerSettings: MarkerSettings(
              isVisible: true,
              color: Colors.white,
              height: 12,
              width: 12
            ),
            cardinalSplineTension: 0.7,
            gradient: LinearGradient(colors: [Colors.blueGrey.withOpacity(0.7),Colors.white.withOpacity(0.5)]),
             dataSource: thisWeek,
             splineType: SplineType.cardinal,
             xValueMapper: (_ActiveDays thisWeek,_)=>thisWeek.date,
             yValueMapper: (_ActiveDays thisWeek,_)=>thisWeek.numberOfTasksCompleted
            )
        ],
      ),
    );
  }
}

class _ActiveDays{
  DateTime date;
  int numberOfTasksCompleted;
  _ActiveDays({required this.date,required this.numberOfTasksCompleted});
}