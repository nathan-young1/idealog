import 'package:flutter/material.dart';
import 'package:idealog/Schedule/addSchedule/ui/addSchedule.dart';

class Schedule{
  final int uniqueId;
  String scheduleTitle;
  String? moreDetails;
  DateTime scheduleDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  RepeatSchedule repeatSchedule;
  bool setAlarmForTask;

  Schedule({required this.scheduleTitle,this.moreDetails,required this.scheduleDate,this.startTime,required this.repeatSchedule,this.endTime,required this.setAlarmForTask,required this.uniqueId});
}