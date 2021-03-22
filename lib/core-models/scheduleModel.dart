import 'package:flutter/material.dart';
import 'package:idealog/Schedule/addSchedule/ui/addSchedule.dart';
import 'package:idealog/global/enums.dart';

class Schedule{
  late final int uniqueId;
  String scheduleTitle;
  String? moreDetails;
  int scheduleDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  RepeatSchedule? repeatSchedule;

  Schedule({required this.scheduleTitle,this.moreDetails,required this.scheduleDate,this.startTime,required this.repeatSchedule,this.endTime}){
      this.uniqueId = DateTime.now().millisecondsSinceEpoch;
  }
  Schedule.fromDb({required this.scheduleTitle,this.moreDetails,required this.scheduleDate,this.startTime,required String repeatSchedule,this.endTime,required this.uniqueId}){
    switch (repeatSchedule){
      case 'RepeatSchedule.NONE':
      this.repeatSchedule = RepeatSchedule.NONE;
      break;
      case 'RepeatSchedule.DAILY':
      this.repeatSchedule = RepeatSchedule.DAILY;
      break;
      case 'RepeatSchedule.WEEKLY':
      this.repeatSchedule = RepeatSchedule.WEEKLY;
      break;
      case 'RepeatSchedule.MONTHLY':
      this.repeatSchedule = RepeatSchedule.MONTHLY;
      break;
      case 'RepeatSchedule.YEARLY':
      this.repeatSchedule = RepeatSchedule.YEARLY;
      break;
    }
  }
}