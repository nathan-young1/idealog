import 'package:date_time_picker/date_time_picker.dart';
import 'package:idealog/Schedule/code/scheduleManager.dart';
import 'package:idealog/customDecoration/boxDecoration.dart';
import 'package:idealog/customDecoration/colors.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/global/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:idealog/customAppBar/appBar.dart';

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
      child: Container(
        decoration: lightModeBackgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20,right: 15),
              child: Column(
                children: [
                  CustomAppBar(title: 'ADD SCHEDULE'),
                  Form(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15,right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                      labelText: 'Start',
                                      prefixIcon: Icon(Icons.timer)
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text('To',textAlign: TextAlign.center,style: TextStyle(fontSize: 23,fontWeight: FontWeight.w500),)),
                            Expanded(
                              flex: 2,
                              child: DateTimePicker(
                                controller: endTime,
                                timeLabelText: 'End Time',
                                type: DateTimePickerType.time,
                                use24HourFormat: false,
                                decoration: underlineAndFilled.copyWith(
                                      labelText: 'End',
                                      prefixIcon: Icon(Icons.flag)
                                ),
                              ),
                            ),
                          ],),
                            SizedBox(height: 25),
                          Container(
                            width: 200,
                            child: DateTimePicker(
                                  controller: date,
                                      dateLabelText: 'Schedule Date',
                                      dateMask: 'd MMM, yyyy',
                                      decoration: underlineAndFilled.copyWith(
                                          suffixIcon: Icon(Icons.date_range),
                                          labelText: 'Schedule Date'
                                        ),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                          initialDate: DateTime.now(),
                                        ),
                          ),
                          SizedBox(height: 25),
                          TextFormField(
                            controller: scheduleDetails,
                            maxLines: null,
                            minLines: 5,
                            decoration: underlineAndFilled.copyWith(
                              labelText: 'Schedule Details...'
                            ),
                          ),
                          SizedBox(height: 35),
                          Row(
                            children: [
                              Text('Repeat: ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
                              SizedBox(width: 10),
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
                ],
              ),
            ),
          ),
          bottomNavigationBar: GestureDetector(
            onTap: () async => addToDbAndSetAlarmSchedule(
              scheduleDate: date.text,
              startTime: startTime.text,
              endTime: endTime.text,
              scheduleDetails: scheduleDetails.text,
              repeatSchedule: repeatSchedule),
            child: Container(
                height: 50,
                color: lightModeBottomNavColor.withOpacity(1),
                child: Center(
                  child: Text('Save',style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.w700)),
                ),),
          ),
        ),
      ),
    );
  }
 }
// ElevatedButton(
//                     onPressed: () async => addToDbAndSetAlarmSchedule(
//                       scheduleDate: date.text,
//                       startTime: startTime.text,
//                       endTime: endTime.text,
//                       scheduleDetails: scheduleDetails.text,
//                       repeatSchedule: repeatSchedule),
//                     child: Text('Save')),
//                     ElevatedButton(
//                     onPressed: () async { 
//                       await cancelAlarm(uniqueAlarmId: 200);
//                       },
//                     child: Text('Cancel')),