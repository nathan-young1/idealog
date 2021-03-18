import 'package:flutter/cupertino.dart';
import 'package:idealog/global/strings.dart';
import 'package:sqflite/sqflite.dart';
import 'package:idealog/global/enums.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/core-models/scheduleModel.dart';
import 'ideasDbColumn.dart';
import 'scheduleDbColumn.dart';

class Sqlite{
  static writeToDb({required NotificationType notificationType,Idea? idea,Schedule? schedule}) async {

    Database _database = await openDatabase(sqliteDbName,onCreate: (_,__)=>print('${_.path} has been created'));
    if(notificationType == NotificationType.IDEAS){
      _database.insert(ideasTableName, {
        Column_uniqueId:idea!.uniqueId.toString(),
        Column_ideaTitle:idea.ideaTitle,
        Column_moreDetails:idea.moreDetails,
        Column_deadline:idea.deadline.toString(),
        Column_completedTasks:idea.tasks!.completedTasks.toString(),
        Column_uncompletedTasks:idea.tasks!.uncompletedTasks.toString()
        });

    }else if(notificationType == NotificationType.SCHEDULE){
      _database.insert(scheduleTableName, {
        Column_uniqueId:schedule!.uniqueId,
        Column_scheduleTitle:schedule.scheduleTitle,
        Column_moreDetails:schedule.moreDetails,
        Column_scheduleDate:schedule.scheduleDate,
        Column_startTime:schedule.startTime,
        Column_endTime:schedule.endTime,
        Column_repeatSchedule:schedule.repeatSchedule,
        Column_setAlarmForSchedule:schedule.setAlarmForSchedule
      });
    }
    await _database.close();
  }
}