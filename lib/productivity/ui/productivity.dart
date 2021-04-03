import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Productivity extends StatelessWidget {
  final List<_ActiveDays> thisWeek = [
    _ActiveDays(date: DateTime(2021,2,6), numberOfTasksCompleted: 5),
    _ActiveDays(date: DateTime(2021,3,8), numberOfTasksCompleted: 8),
    _ActiveDays(date: DateTime(2021,3,9), numberOfTasksCompleted: 4),
    _ActiveDays(date: DateTime(2021,3,15), numberOfTasksCompleted: 6),
    _ActiveDays(date: DateTime(2021,3,20), numberOfTasksCompleted: 7),
    _ActiveDays(date: DateTime(2021,2,25), numberOfTasksCompleted: 3),
    _ActiveDays(date: DateTime.now(), numberOfTasksCompleted: 0),
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
          SizedBox(height: 25),
          Container(
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
                tickPosition: TickPosition.outside,
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
                  cardinalSplineTension: 0.9,
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