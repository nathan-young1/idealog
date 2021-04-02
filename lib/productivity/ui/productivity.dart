import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Productivity extends StatelessWidget {
  final List<_ActiveDays> thisWeek = [
    _ActiveDays(date: DateTime(2021,3,6), numberOfTasksCompleted: 5),
    _ActiveDays(date: DateTime(2021,3,8), numberOfTasksCompleted: 8),
    _ActiveDays(date: DateTime(2021,3,9), numberOfTasksCompleted: 4),
    _ActiveDays(date: DateTime(2021,3,15), numberOfTasksCompleted: 6),
    _ActiveDays(date: DateTime(2021,3,20), numberOfTasksCompleted: 7),
    _ActiveDays(date: DateTime(2021,3,25), numberOfTasksCompleted: 3),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('Productivity'),
          Text('Tasks Completion Rate'),
          Text('Completed Tasks'),
          Text('Uncompleted Tasks'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(minHeight: 25,value: 0.6)),
          ),
          Text('Favorite Tasks'),
          Column(
            children: List.generate(5, (index) => Text('$index')).toList(),
          ),
          Text('Active Days'),
          Container(
            height: 250,
            width: 350,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              enableAxisAnimation: false,
              plotAreaBorderColor: Colors.transparent,
              plotAreaBackgroundColor: Colors.transparent,
              borderColor: Colors.transparent,
              primaryXAxis: DateTimeAxis(),
              series: <ChartSeries>[
                  SplineAreaSeries<_ActiveDays,DateTime>(
                  animationDuration: 0,
                  cardinalSplineTension: 0.7,
                  gradient: LinearGradient(colors: [Colors.blueGrey.withOpacity(0.7),Colors.white.withOpacity(0.5)]),
                   dataSource: thisWeek,
                   splineType: SplineType.cardinal,
                   yAxisName: 'Number of tasks completed',
                   xAxisName: 'Date',
                   enableTooltip: true,
                   xValueMapper: (_ActiveDays thisWeek,_)=>thisWeek.date,
                   yValueMapper: (_ActiveDays thisWeek,_)=>thisWeek.numberOfTasksCompleted
                  )
              ],
            ),
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