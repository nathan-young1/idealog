import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:idealog/Databases/analytics-db/analyticsSql.dart';
import 'package:idealog/Prefs&Data/phoneSizeInfo.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EfficiencyChart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var listOfAnalyticsData = AnalyticDB.instance.efficiencyChartData;
    return (listOfAnalyticsData.length >= 2)
    ?Container(
      height: percentHeight(40),
      child: SfCartesianChart(
        enableAxisAnimation: true,
            title: ChartTitle(
              text: 'Efficiency chart',
              textStyle: AppFontWeight.medium.copyWith(fontSize: AppFontSize.medium)
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
              textStyle: AppFontWeight.reqular.copyWith(fontSize: AppFontSize.small),
              ),
            plotAreaBorderColor: Colors.transparent,
            primaryYAxis: NumericAxis(
              axisLine: AxisLine(width: 2,dashArray: [5,5], color: DarkGray),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              majorTickLines: MajorTickLines(size: 10,width: 0),
              majorGridLines: MajorGridLines(width: 0),
              labelStyle: AppFontWeight.reqular.copyWith(fontSize: AppFontSize.small, color: DarkGray),
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
              labelStyle: AppFontWeight.reqular.copyWith(fontSize: AppFontSize.small, color: DarkGray),
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
          color: LightBlue.withOpacity(0.2),
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AutoSizeText('Efficiency chart',
              style: AppFontWeight.medium,
              maxFontSize: AppFontSize.medium,
              minFontSize: AppFontSize.fontSize_23),
              SizedBox(height: 10),
              Icon(Icons.lock_clock,size: 60,color: Colors.black45),
              SizedBox(height: 10),
              AutoSizeText('Complete tasks for at least 2 days this month',
              style: AppFontWeight.reqular,
              maxLines: 1,
              minFontSize: AppFontSize.small)
            ]),
        ),
    );
  }
}
