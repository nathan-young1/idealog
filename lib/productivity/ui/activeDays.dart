import 'package:flutter/material.dart';
import 'package:idealog/Databases/analytics-db/analyticsSql.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ActiveDaysChart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var listOfAnalyticsData = Provider.of<List<AnalyticChartData>>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: LightGray,
          ),
          padding: EdgeInsets.symmetric(vertical: 20),

        child: (listOfAnalyticsData.length >= 3)?SfCartesianChart(
          
          enableAxisAnimation: true,
              title: ChartTitle(
                text: 'Active Days',
                textStyle: rhodiumLibre.copyWith(fontSize: 25)
              ),
              zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true
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
                isVisible: false
              ),
              primaryXAxis: DateTimeCategoryAxis(
                axisLine: AxisLine(width: 2,dashArray: [5,5]),
                zoomFactor: (listOfAnalyticsData.length>5)?0.5:1,
                // zoom position is 1 so that the date can show from current
                zoomPosition: 1,
                autoScrollingDeltaType: DateTimeIntervalType.days,
                intervalType: DateTimeIntervalType.days,
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                majorTickLines: MajorTickLines(size: 10,width: 0),
                majorGridLines: MajorGridLines(width: 0),
                labelStyle: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),
              ),
              series: <ChartSeries>[
                  SplineSeries<AnalyticChartData,DateTime>(
                  width: 4,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    color: LightPink,
                    height: 12,
                    width: 12
                  ),
                  color: Color.fromRGBO(50, 101, 141, 1),
                   dataSource: listOfAnalyticsData,
                   xValueMapper: (AnalyticChartData analytic,_)=>analytic.date,
                   yValueMapper: (AnalyticChartData analytic,_)=>analytic.numberOfTasksCompleted
                  )
              ],
        )
        :Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Active Days',
              style: rhodiumLibre.copyWith(fontSize: 25)),
              Icon(Icons.lock_outlined,size: 60,color: Colors.black45,),
              SizedBox(height: 6),
              Text('Complete tasks for 3 days this month',
              style: lato.copyWith(fontSize: 17))
            ]),
        ),
      ),
    );
  }
}
