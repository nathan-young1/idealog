import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:idealog/customAppBar/appBar.dart';
import 'package:flutter/services.dart';
import 'package:idealog/global/strings.dart';
import 'package:sqflite/sqflite.dart';

enum RepeatSchedule{NONE,DAILY,WEEKLY,MONTHLY,YEARLY}
enum NotificationType{IDEAS,SCHEDULE}

class AddSchedule extends StatefulWidget {
  @override
  _AddScheduleState createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  static const platform = const MethodChannel('com.idealog.alarmServiceCaller');

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
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.text_fields),
                  labelText: 'Title'
                ),
              ),
              Row(
                children: [
                Icon(Icons.watch),
                Container(
                  width: 50.w,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Start time'
                    ),
                  ),
                ),
                Text('To'),
                Container(
                  width: 50.w,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'End time'
                    ),
                  ),
                ),
              ],),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.date_range),
                  labelText: 'Date',
                ),
              ),
              TextFormField(
                maxLines: null,
                minLines: 5,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.text_fields),
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
              CheckboxListTile(
               value: true,
               onChanged: (value){},
               title: Text('Set alarm for task'),),
            ],
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
                      // int setTime = DateTime.now().millisecondsSinceEpoch;
                      // await createNewAlarm(alarmText: 'scehdule',typeOfNotification: NotificationType.SCHEDULE,uniqueAlarmId: 200,alarmTime: setTime);
                      // print(setTime);
                      var db = await openDatabase(sqliteDbName);
                      List<List<int>> tasks = ['firest'.codeUnits,'wash'.codeUnits,'eating'.codeUnits,'running'.codeUnits];
                      await db.execute('DELETE FROM IDEAS WHERE uniqueId < 230');
                      await db.transaction((txn) => txn.insert('IDEAS', {'uniqueId' : 260,
                      'ideaTitle': 400,'moreDetails': tasks.toString(),'deadline': 678}));
                      print(await db.rawQuery('SELECT * FROM IDEAS WHERE moreDetails != null'));
                      await db.close();
                      //Navigator.pushNamed(context, 'CheckSchedule');
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