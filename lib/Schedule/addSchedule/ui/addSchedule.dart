import 'dart:typed_data';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:idealog/Schedule/addSchedule/code/scheduleManager.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/core-models/scheduleModel.dart';
import 'package:idealog/customInputDecoration/inputDecoration.dart';
import 'package:idealog/global/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:idealog/customAppBar/appBar.dart';
import 'package:flutter/services.dart';
import 'package:idealog/global/strings.dart';
import 'package:idealog/global/extension.dart';
import 'package:idealog/nativeCode/bridge.dart';
import 'package:idealog/sqlite-db/sqlite.dart';
import 'package:sqflite/sqflite.dart';

class AddSchedule extends StatefulWidget {
  @override
  _AddScheduleState createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  TextEditingController scheduleDetails = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController date = TextEditingController();
  RepeatSchedule repeatSchedule = RepeatSchedule.NONE;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight*1.2),
              child: CustomAppBar(title: 'ADD SCHEDULE')),
        body: Form(
          child: Padding(
            padding: const EdgeInsets.only(left: 15,right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Date:'),
                    Container(
                      width: 200,
                      child: DateTimePicker(
                        controller: date,
                            dateLabelText: 'Schedule Date',
                            dateMask: 'd MMM, yyyy',
                            decoration: underlineAndFilled.copyWith(
                                suffixIcon: Icon(Icons.date_range),
                                labelText: 'dd-mm-year'
                              ),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                initialDate: DateTime.now(),
                              ),
                    ),
                  ],
                ),
                Row(
                  children: [
                  Expanded(
                    flex: 2,
                    child: DateTimePicker(
                      controller: startTime,
                      timeLabelText: 'Start Time',
                      type: DateTimePickerType.time,
                      use24HourFormat: false,
                      decoration: underlineAndFilled.copyWith(
                            labelText: 'Start time',
                            prefixIcon: Icon(Icons.access_time_sharp)
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('To',textAlign: TextAlign.center,)),
                  Expanded(
                    flex: 2,
                    child: DateTimePicker(
                      controller: endTime,
                      timeLabelText: 'End Time',
                      type: DateTimePickerType.time,
                      use24HourFormat: false,
                      decoration: underlineAndFilled.copyWith(
                            labelText: 'End time',
                            prefixIcon: Icon(Icons.access_time_sharp)
                      ),
                    ),
                  ),
                ],),
                TextFormField(
                  controller: scheduleDetails,
                  maxLines: null,
                  minLines: 5,
                  decoration: underlineAndFilled.copyWith(
                    labelText: 'Schedule Details...'
                  ),
                ),
                Row(
                  children: [
                    Text('Repeat: '),
                    Container(
                      width: 150.w,
                      child: DropdownButtonFormField(
                        value: repeatSchedule,
                        onChanged: (RepeatSchedule? value){
                          repeatSchedule = value!;
                          print(repeatSchedule);
                        },
                        items: [
                          DropdownMenuItem(
                            value: RepeatSchedule.NONE,
                            child: Text('None')),
                          DropdownMenuItem(
                            value: RepeatSchedule.DAILY,
                            child: Text('Daily')),
                          DropdownMenuItem(
                            value: RepeatSchedule.WEEKLY,
                            child: Text('Weekly')),
                          DropdownMenuItem(
                            value: RepeatSchedule.MONTHLY,
                            child: Text('Monthly')),
                          DropdownMenuItem(
                            value: RepeatSchedule.YEARLY,
                            child: Text('Yearly'))
                          ]),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
            height: 50,
            color: Colors.green,
            child: Center(
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () async => addToDbAndSetAlarmSchedule(
                      scheduleDate: date.text,
                      startTime: startTime.text,
                      endTime: endTime.text,
                      scheduleDetails: scheduleDetails.text,
                      repeatSchedule: repeatSchedule),
                    child: Text('Save')),
                    ElevatedButton(
                    onPressed: () async { 
                      await cancelAlarm(uniqueAlarmId: 200);
                      },
                    child: Text('Cancel')),
                ],
              ),
            ),),
      ),
    );
  }
}