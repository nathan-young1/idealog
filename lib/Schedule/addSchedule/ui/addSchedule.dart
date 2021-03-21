import 'dart:typed_data';
import 'package:date_time_picker/date_time_picker.dart';
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
import 'package:idealog/sqlite-db/sqlite.dart';
import 'package:sqflite/sqflite.dart';

class AddSchedule extends StatefulWidget {
  @override
  _AddScheduleState createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  static const platform = const MethodChannel(javaToFlutterMethodChannelName);

  createNewAlarm({required String? alarmText,required NotificationType typeOfNotification,required int? uniqueAlarmId,required int? alarmTime}) async{
    //remember to change configuaration to int in native java code
    Map<String,dynamic> alarmConfiguration = {
      'timeForAlarm': alarmTime!,
      'alarmText': alarmText!,
      'typeOfNotification': (typeOfNotification == NotificationType.IDEAS)?1:2,
      'uniqueAlarmId': uniqueAlarmId!
    };

    try{
      String result = await platform.invokeMethod("setAlarm",alarmConfiguration);
      print("kd".hashCode.toString());
      print('dart ${result.split(',').toString()}');
      print('dart substring ${String.fromCharCodes(List<int>.from(result.substring(2,result.length-2).split(',')))}');
      print(result);
    }catch(e){
      print(e);
    }
  }

  cancelAlarm({required int? uniqueAlarmId}) async {
    Map<String,dynamic> alarmConfiguration = {
      'uniqueAlarmId': uniqueAlarmId!
    };
    try{
      String result = await platform.invokeMethod("cancelAlarm",alarmConfiguration);
      print(result);
    }catch(e){
      print(e);
    }
  }

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
                TextFormField(
                  decoration: underlineAndFilled.copyWith(
                    prefixIcon: Icon(Icons.text_fields),
                    labelText: 'Title'
                  ),
                ),
                Row(
                  children: [
                  Expanded(
                    flex: 2,
                    child: DateTimePicker(
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
                      type: DateTimePickerType.time,
                      use24HourFormat: false,
                      decoration: underlineAndFilled.copyWith(
                            labelText: 'End time',
                            prefixIcon: Icon(Icons.access_time_sharp)
                      ),
                    ),
                  ),
                ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Date:'),
                    Container(
                      width: 200,
                      child: DateTimePicker(
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
                TextFormField(
                  maxLines: null,
                  minLines: 5,
                  decoration: underlineAndFilled.copyWith(
                    labelText: 'More details on schedule...'
                  ),
                ),
                Row(
                  children: [
                    Text('Repeat: '),
                    Container(
                      width: 150.w,
                      child: DropdownButtonFormField(
                        hint: Text('NONE'),
                        onChanged: (value){
                          print(value);
                        },
                        items: [
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
                    onPressed: () async { 
                      DateTime newer = new DateTime(2021,3,20);
                      print(newer);
                      print(newer.millisecondsSinceEpoch);
                      // await createNewAlarm(alarmText: 'scehdule',typeOfNotification: NotificationType.SCHEDULE,uniqueAlarmId: 200,alarmTime: setTime);
                      // Schedule? schedule = Schedule(scheduleTitle: 'jdklf', scheduleDate: newer.millisecondsSinceEpoch,
                      //  repeatSchedule: RepeatSchedule.DAILY, uniqueId: DateTime.now().millisecondsSinceEpoch,
                      //  startTime: TimeOfDay(hour: 4,minute: 10),endTime: TimeOfDay(hour: 2,minute: 1),moreDetails: 'djkd');
                      // await Sqlite.writeToDb(notificationType: NotificationType.SCHEDULE,schedule: schedule);
                      List<Schedule> schedule = await Sqlite.readFromDb(type: NotificationType.SCHEDULE);
                      print(schedule.first.scheduleTitle);
                      print(schedule.first.uniqueId);
                      print(schedule.first.startTime);
                      },
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