import 'package:flutter/material.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

enum RateType{UNCOMPLETED,COMPLETED}

class CompletionRateModel{
  late final Color color;
  late final double percent;
  late final String completionRateType;

  CompletionRateModel({required this.percent,required RateType type}){
    completionRateType = (type == RateType.COMPLETED) ? 'Completed' : 'Uncompleted';
    color = (type == RateType.COMPLETED) ? PieChartCompletedColor : PieChartUncompletedColor;
  }
}


class TaskCompletionRate extends StatelessWidget {

  late final List<CompletionRateModel> rates;
  final double completedTaskPercent;
  int get percentageCompletion { 
    return (completedTaskPercent * 100).round();
  }

  TaskCompletionRate(this.completedTaskPercent){
    // 100% is 1 , so uncompleted tasks will be (1-completedTaskPercent)
    var uncompletedTaskPercent = 1 - this.completedTaskPercent;
    rates = [
    CompletionRateModel(percent: completedTaskPercent, type: RateType.COMPLETED),
    CompletionRateModel(percent: uncompletedTaskPercent, type: RateType.UNCOMPLETED)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Tasks Completion Rate',
            style: dosis.copyWith(fontSize: 22)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: SfCircularChart(
                    annotations: [
                      CircularChartAnnotation(
                        horizontalAlignment: ChartAlignment.center,
                        verticalAlignment: ChartAlignment.center,
                         widget: Container( child: Text('$percentageCompletion%',style: TextStyle(fontSize: 20),),))
                    ],
                    series: <CircularSeries>[
                      DoughnutSeries<CompletionRateModel,String>(
                        cornerStyle: (percentageCompletion > 10 && percentageCompletion < 90)
                          ?CornerStyle.bothCurve
                          :CornerStyle.bothFlat,
                        animationDuration: 1000,
                        dataSource: rates,
                        pointColorMapper: (CompletionRateModel r,_)=> r.color,
                        xValueMapper: (CompletionRateModel r,_)=> r.completionRateType,
                        yValueMapper: (CompletionRateModel r,_)=> r.percent,
                        // Radius of pie
                        radius: '100%',
                        // Radius of doughnut's inner circle
                        innerRadius: '70%',
                        // only explode the pie chart if the completionRate is within 10 and 90
                        explode: (percentageCompletion > 10 && percentageCompletion < 90),
                        explodeIndex: 0,
                        explodeOffset: '10%',
                        explodeAll: true,
                        explodeGesture: ActivationMode.none,
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
                      Container(height: 25, width: 25, color: PieChartCompletedColor),
                      SizedBox(width: 5),
                      Text('Completed Tasks',
                      style: dosis.copyWith(fontSize: 17)),
                    ],)
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Center(
                    child: Row(
                    children: [
                      Container(height: 25, width: 25, color: PieChartUncompletedColor),
                      SizedBox(width: 5),
                      Text('Uncompleted Tasks',
                      style: dosis.copyWith(fontSize: 17)),
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