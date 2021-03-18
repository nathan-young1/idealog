import 'package:idealog/global/strings.dart';
import 'package:sqflite/sqflite.dart';
import 'package:idealog/global/enums.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/core-models/scheduleModel.dart';

class Sqlite{
  static writeToDb({required NotificationType notificationType,Idea? idea,Schedule? schedule}) async {
    Database _database = await openDatabase(sqliteDbName,onCreate: (_,__)=>print('${_.path} has been created'));
    if(notificationType == NotificationType.IDEAS){

    }else if(notificationType == NotificationType.SCHEDULE){

    }
    await _database.close();
  }
}