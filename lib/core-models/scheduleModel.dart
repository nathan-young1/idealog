import 'package:idealog/global/enums.dart';

class Schedule{
  int uniqueId;
  String? scheduleDetails;
  String? scheduleDate;
  String? startTime;
  String? endTime;
  RepeatSchedule? repeatSchedule;

  Schedule({this.scheduleDetails,required this.scheduleDate,required this.startTime,required this.repeatSchedule,this.endTime,required this.uniqueId});
  Schedule.fromDb({this.scheduleDetails,this.startTime,required String repeatSchedule,this.endTime,required this.uniqueId,required this.scheduleDate}){
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