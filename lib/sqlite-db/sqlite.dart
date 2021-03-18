import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idealog/global/strings.dart';
import 'package:sqflite/sqflite.dart';
import 'package:idealog/global/enums.dart';
import 'package:idealog/global/extension.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/core-models/scheduleModel.dart';
import 'ideasDbColumn.dart';
import 'scheduleDbColumn.dart';

class Sqlite{
  static writeToDb({required NotificationType notificationType,Idea? idea,Schedule? schedule}) async {

    Database _database = await openDatabase(sqliteDbName,onCreate: (_,__)=>print('${_.path} has been created'));
    if(notificationType == NotificationType.IDEAS){
      await _database.execute('create table if not exists $ideasTableName ($Column_uniqueId INTEGER PRIMARY_KEY,$Column_ideaTitle TEXT,$Column_moreDetails TEXT,$Column_deadline INTEGER,$Column_completedTasks TEXT,$Column_uncompletedTasks TEXT)');
      _database.insert(ideasTableName, {
        Column_uniqueId:idea!.uniqueId.toString(),
        Column_ideaTitle:idea.ideaTitle,
        Column_moreDetails:idea.moreDetails,
        Column_deadline:idea.deadline,
        Column_completedTasks:idea.tasks!.completedTasks.toString(),
        Column_uncompletedTasks:idea.tasks!.uncompletedTasks.toString()
        });

    }else if(notificationType == NotificationType.SCHEDULE){
      await _database.execute('create table if not exists $scheduleTableName ($Column_uniqueId INTEGER PRIMARY_KEY,$Column_scheduleTitle TEXT,$Column_moreDetails TEXT,$Column_scheduleDate INTEGER,$Column_startTime INTEGER,$Column_endTime INTEGER,$Column_repeatSchedule TEXT)');
      _database.insert(scheduleTableName, {
        Column_uniqueId:schedule!.uniqueId,
        Column_scheduleTitle:schedule.scheduleTitle,
        Column_moreDetails:schedule.moreDetails,
        Column_scheduleDate:schedule.scheduleDate,
        Column_startTime:schedule.startTime,
        Column_endTime:schedule.endTime,
        Column_repeatSchedule:schedule.repeatSchedule.toString()
      });
    }
    await _database.close();
  }

  static deleteFromDB({required String uniqueId,required NotificationType type}) async {
    Database _database = await openDatabase(sqliteDbName,onCreate: (_,__)=>print('${_.path} has been created'));
      (type == NotificationType.IDEAS)
      ?await _database.execute('delete from $ideasTableName where $Column_uniqueId = $uniqueId')
      :await _database.execute('delete from $scheduleTableName where $Column_uniqueId = $uniqueId');
    await _database.close();
  }

  static readFromDb({required NotificationType type}) async {
      List<Idea>? allIdeasFromDb = [];
      List<Schedule>? allScheduleFromDb = [];
        Database _database = await openDatabase(sqliteDbName,onCreate: (_,__)=>print('${_.path} has been created'));
        if(type == NotificationType.IDEAS){
        var result = await _database.query(ideasTableName);
        result.forEach((idea) { allIdeasFromDb.add(
        Idea.readFromDb(
        ideaTitle: idea[Column_ideaTitle].toString(),
        uniqueId: int.parse(idea[Column_uniqueId].toString()),
        moreDetails: idea[Column_moreDetails].toString(),
        deadline: int.parse(idea[Column_deadline].toString()),
        completedTasks: idea[Column_completedTasks].toString().fromDbStringToStringList,
        uncompletedTasks: idea[Column_uncompletedTasks].toString().fromDbStringToStringList
        ));});
        }else if(type == NotificationType.SCHEDULE){
        var result = await _database.query(scheduleTableName);
        result.forEach((schedule) { 
          int startTimeHour = int.parse(schedule[Column_startTime].toString().split(':').first);
          int startTimeMinute = int.parse(schedule[Column_startTime].toString().split(':').last);
          int endTimeHour = int.parse(schedule[Column_endTime].toString().split(':').first);
          int endTimeMinute = int.parse(schedule[Column_endTime].toString().split(':').last);
          allScheduleFromDb.add(
            Schedule.fromDb(
              scheduleTitle: schedule[Column_scheduleTitle].toString(),
              scheduleDate: int.parse(Column_scheduleDate.toString()),
              repeatSchedule: schedule[Column_repeatSchedule].toString(),
              uniqueId: int.parse(schedule[Column_uniqueId].toString()),
              startTime: TimeOfDay(hour: startTimeHour,minute: startTimeMinute),
              endTime: TimeOfDay(hour: endTimeHour,minute: endTimeMinute),
              moreDetails: schedule[Column_moreDetails].toString(),
              )
          );
        });
        }
        
        await _database.close();

        return (type == NotificationType.IDEAS)?allIdeasFromDb:allScheduleFromDb;
  }
  
}