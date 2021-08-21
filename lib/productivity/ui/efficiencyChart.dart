import 'package:flutter/material.dart';
import 'package:idealog/Databases/analytics-db/analyticsSql.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EfficiencyChart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var listOfAnalyticsData = AnalyticDB.instance.efficiencyChartData;
    debugPrint("the number of days is ${listOfAnalyticsData.length}");
    return (listOfAnalyticsData.length >= 3)
    ?Container(
      height: 270,
      child: SfCartesianChart(
        enableAxisAnimation: true,
            title: ChartTitle(
              text: 'Efficiency chart',
              textStyle: dosis.copyWith(fontSize: 25)
            ),
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true,
              zoomMode: ZoomMode.x),
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
              axisLine: AxisLine(width: 2,dashArray: [5,5], color: DarkGray),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              majorTickLines: MajorTickLines(size: 10,width: 0),
              majorGridLines: MajorGridLines(width: 0),
              labelStyle: TextStyle(fontWeight: FontWeight.w400, color: DarkGray)
              ),
            primaryXAxis: DateTimeCategoryAxis(
              axisLine: AxisLine(width: 2,dashArray: [5,5], color: DarkGray),
              zoomFactor: (listOfAnalyticsData.length>5)?0.5:1,
              // zoom position is 1 so that the date can show from current
              zoomPosition: 1,
              autoScrollingDeltaType: DateTimeIntervalType.days,
              intervalType: DateTimeIntervalType.days,
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              majorTickLines: MajorTickLines(size: 10,width: 0),
              majorGridLines: MajorGridLines(width: 0),
              labelStyle: TextStyle(fontSize: 17,fontWeight: FontWeight.w400, color: DarkGray),
              /// since least is the list is sorted by date the minium Date will be the first date.
              minimum: listOfAnalyticsData.first.date
            ),
            series: <ChartSeries>[
                SplineAreaSeries<EfficiencyChartData,DateTime>(
                markerSettings: MarkerSettings(
                  borderWidth: 0,
                  borderColor: Colors.transparent,
                  isVisible: true,
                  color: LightPink,
                  height: 14,
                  width: 14
                ),
                color: DarkBlue,
                // gradient: LinearGradient(
                //   colors: (!Prefrences.instance.isDarkMode)
                //   ?[DarkBlue.withOpacity(0.6), LightPink.withOpacity(0.6)]
                //   :[DarkRed, DarkRed.withOpacity(0.8)],
                  // begin: Alignment.topLeft,
                  // end: Alignment.bottomRight),
                 dataSource: listOfAnalyticsData,
                 xValueMapper: (EfficiencyChartData analytic,_)=>analytic.date,
                 yValueMapper: (EfficiencyChartData analytic,_)=>analytic.numberOfTasksCompleted
                )
            ],
      )
    )
    :Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
          height: 200,
          color: LightBlue.withOpacity(0.2),
          padding: EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Efficiency chart',style: dosis.copyWith(fontSize: 25)),
              SizedBox(height: 10),
              Icon(Icons.lock_clock,size: 60,color: Colors.black45),
              SizedBox(height: 10),
              Text('Complete tasks for at least 3 days this month',style: dosis.copyWith(fontSize: 17))
            ]),
        ),
    );
  }
}
