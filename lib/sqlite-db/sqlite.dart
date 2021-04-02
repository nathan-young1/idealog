import 'dart:math';

import 'package:flutter/material.dart';
import 'package:idealog/global/int.dart';
import 'package:idealog/global/strings.dart';
import 'package:idealog/sqlite-db/sqlExecString.dart';
import 'package:sqflite/sqflite.dart';
import 'package:idealog/global/enums.dart';
import 'package:idealog/global/extension.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/core-models/scheduleModel.dart';
import 'ideasDbColumn.dart';
import 'scheduleDbColumn.dart';

class Sqlite{

  static writeToDb({required NotificationType notificationType,Idea? idea,Schedule? schedule}) async {

    Database _database = await openDatabase(sqliteDbName,version: 1,onCreate: (_db,_version)=>print('${_db.path} has been created'));
    if(notificationType == NotificationType.IDEAS){

      await _database.execute(createIdeasTableSqlCommand);
      List<List<int>> completedTasks = idea!.tasks!.completedTasks;
      List<List<int>> uncompletedTasks = idea.tasks!.uncompletedTasks;

      _database.insert(ideasTableName, {
        Column_uniqueId:  '${idea.uniqueId}',
        Column_ideaTitle  :idea.ideaTitle,
        Column_moreDetails: idea.moreDetails,
        Column_completedTasks:  (completedTasks.isEmpty)?null:'$completedTasks',
        Column_uncompletedTasks: (uncompletedTasks.isEmpty)?null:'$uncompletedTasks'
        });

    }else if(notificationType == NotificationType.SCHEDULE){
            
      // await _database.execute('Drop Table $scheduleTableName');
      await _database.execute(createScheduleTableSqlCommand);
      _database.insert(scheduleTableName, {
        Column_uniqueId:schedule!.uniqueId,
        Column_scheduleDetails:schedule.scheduleDetails,
        Column_scheduleDate:schedule.scheduleDate.toString(),
        Column_startTime:'${schedule.startTime}',
        Column_endTime:'${schedule.endTime}',
        Column_repeatSchedule:'${schedule.repeatSchedule}'
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
        
        Database _database = await openDatabase(sqliteDbName,version: 1,onCreate: (_db,_version)=>print('${_db.path} has been created'));
        if(type == NotificationType.IDEAS){
        await _database.execute(createIdeasTableSqlCommand);
        var result = await _database.query(ideasTableName);
        result.forEach((idea) { 
        Object? completedTasks = idea[Column_completedTasks];
        Object? uncompletedTasks = idea[Column_uncompletedTasks];
        allIdeasFromDb.add(
        Idea.readFromDb(
        ideaTitle: idea[Column_ideaTitle].toString(),
        uniqueId: int.parse(idea[Column_uniqueId].toString()),
        moreDetails: idea[Column_moreDetails].toString(),
        completedTasks: (completedTasks != null)?completedTasks.fromDbStringToListInt:[],
        uncompletedTasks: (uncompletedTasks != null)?uncompletedTasks.fromDbStringToListInt:[]
        ));});
        
        }else if(type == NotificationType.SCHEDULE){
        await _database.execute(createScheduleTableSqlCommand);
        var result = await _database.query(scheduleTableName);
        result.forEach((schedule) { 
          int startTimeHour = int.parse(schedule[Column_startTime].toString().split(':').first);
          int startTimeMinute = int.parse(schedule[Column_startTime].toString().split(':').last);
          int endTimeHour = int.parse(schedule[Column_endTime].toString().split(':').first);
          int endTimeMinute = int.parse(schedule[Column_endTime].toString().split(':').last);
          print('$startTimeHour $startTimeMinute\n $endTimeHour $endTimeMinute');
          print(schedule[Column_repeatSchedule]);
          print(schedule[Column_scheduleDate]);
          allScheduleFromDb.add(
            Schedule.fromDb(
              scheduleDate: schedule[Column_scheduleDate].toString(),
              repeatSchedule: schedule[Column_repeatSchedule].toString(),
              uniqueId: int.parse(schedule[Column_uniqueId].toString()),
              startTime: TimeOfDay(hour: startTimeHour,minute: startTimeMinute).toString(),
              endTime: TimeOfDay(hour: endTimeHour,minute: endTimeMinute).toString(),
              scheduleDetails: schedule[Column_moreDetails].toString(),
              )
          );
        });
        }
        
        await _database.close();

        return (type == NotificationType.IDEAS)?allIdeasFromDb:allScheduleFromDb;
  }

  static Future<int> getUniqueId({NotificationType? type}) async {
            int uniqueId = Random().nextInt(maxRandomNumber);
            Database _database = await openDatabase(sqliteDbName,version: 1,onCreate: (_db,_version)=>print('${_db.path} has been created'));
            await _database.execute(createScheduleTableSqlCommand);
            print('database has been initialized');
            var idsFromDb = await _database.query((type == NotificationType.IDEAS)?ideasTableName:scheduleTableName,columns: [Column_uniqueId]);
            List<int> unavailableIds = idsFromDb.map((map) => int.parse('${map[Column_uniqueId]}')).toList();
            //if it does not contain the id do not loop
            while(unavailableIds.contains(uniqueId)){
              uniqueId = Random().nextInt(maxRandomNumber);
            }
            return uniqueId;
  }
}