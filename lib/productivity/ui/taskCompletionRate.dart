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

  TaskCompletionRate(double completedTaskPercent){
    // 100% is 1 , so uncompleted tasks will be (1-completedTaskPercent)
    double uncompletedTaskPercent = 1 - completedTaskPercent;
    rates = [
    CompletionRateModel(percent: uncompletedTaskPercent, type: RateType.UNCOMPLETED),
    CompletionRateModel(percent: completedTaskPercent, type: RateType.COMPLETED)
    ];
  }

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
                      PieSeries<CompletionRateModel,String>(
                        dataSource: this.rates,
                        pointColorMapper: (CompletionRateModel r,_)=> r.color,
                        xValueMapper: (CompletionRateModel r,_)=> r.completionRateType,
                        yValueMapper: (CompletionRateModel r,_)=> r.percent,
                        // Radius of pie
                        radius: '100%',
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true
                        ),
                        // i have to times the percent by 100 because percent is btw 0-1
                        dataLabelMapper: (CompletionRateModel r,__)=> '${(r.percent*100).round()}%',
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
                      Container(height: 25, width: 25, color: PieChartCompletedColor),
                      SizedBox(width: 5),
                      Text('Completed Tasks',
                      style: Lato.copyWith(fontSize: 17)),
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
                      style: Lato.copyWith(fontSize: 17)),
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