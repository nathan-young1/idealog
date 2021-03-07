import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckSchedule extends StatelessWidget {

  DateRangePickerController? _controller = DateRangePickerController()..view = DateRangePickerView.month;

  @override
  Widget build(BuildContext context) {
    Map<int,int> schDay = {1:5,9:2,20:1};
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.all(30.w),
            child: Icon(Icons.arrow_back_ios,size: 35.r,),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 30.w),
            child: Text('Check Schedule'),
          ),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          toolbarHeight: kToolbarHeight*1.2,
        ),
        body: Container(
          child: SfDateRangePicker(
            controller: _controller,
            showNavigationArrow: true,
            todayHighlightColor: Colors.deepOrange,
            toggleDaySelection: true,
            onSelectionChanged: (value){
              print(value.value);
            },
            navigationDirection: DateRangePickerNavigationDirection.vertical,
            allowViewNavigation: true,
            cellBuilder: (BuildContext context, DateRangePickerCellDetails cellDetails){
              
          if (_controller!.view == DateRangePickerView.month) {
          return Container(
            color: (schDay.containsKey(cellDetails.date.day.toInt())&&cellDetails.date.month==3)?Colors.indigo:(cellDetails.date.day == DateTime.now().day)?Colors.lime:Colors.transparent,
            width: cellDetails.bounds.width,
            height: cellDetails.bounds.height,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(cellDetails.date.day.toString(),
                style: (schDay.containsKey(cellDetails.date.day.toInt())&&cellDetails.date.month==3)?TextStyle(color: Colors.white):null,),
                if (schDay.containsKey(cellDetails.date.day.toInt())&&cellDetails.date.month==3)
                Text('Activity: ${schDay[cellDetails.date.day.toInt()]}',
                style: TextStyle(color: Colors.white))
              ],
            ),
          );
        } else if (_controller!.view == DateRangePickerView.year) {
          
          return Container(
            width: cellDetails.bounds.width,
            height: cellDetails.bounds.height,
            alignment: Alignment.center,
            child: Text(cellDetails.date.month.toString()),
          );
        } else if (_controller!.view == DateRangePickerView.decade) {
          return Container(
            width: cellDetails.bounds.width,
            height: cellDetails.bounds.height,
            alignment: Alignment.center,
            child: Text(cellDetails.date.year.toString()),
          );
        } else {
          final int yearValue = (cellDetails.date.year ~/ 10) * 10;
          return Container(
            width: cellDetails.bounds.width,
            height: cellDetails.bounds.height,
            alignment: Alignment.center,
            child: Text(
               yearValue.toString() + ' - ' + (yearValue + 9).toString()),
          );
        }
            },
          ),
          )
      ),
    );
  }
}