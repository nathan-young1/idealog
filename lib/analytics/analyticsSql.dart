import 'package:idealog/analytics/analyticsColumn.dart';
import 'package:idealog/analytics/analyticsSqlStatements.dart';
import 'package:sqflite/sqflite.dart';

class AnalyticsSql {
  // using one database object like i did in sql
  static late Database _analyticsDb;

  static void intialize() async {
    _analyticsDb = await openDatabase(Analytics_Db_Name,version: 1,onCreate: (_db,_version)=>print('Started Analytics'));
  }

  static writeOrUpdate(List<int> task)async{
    DateTime now = DateTime.now();
    final int year = now.year;
    final int month = now.month;
    final int day = now.day;
    await _analyticsDb.transaction((txn) async {
    await txn.execute(createAnalyticsTable);
    await txn.insert(Analytics_Table_Name,{
      Column_Completed_Analytics_Task: '$task',
      Column_Year: year,
      Column_Month: month,
      Column_day: day
    });
    });
  }

  static removeTaskFromAnalytics(List<int> task) async {
    await _analyticsDb.transaction((txn) async {
    await txn.execute(createAnalyticsTable);
    await txn.delete(Analytics_Table_Name,where: '$Column_Completed_Analytics_Task = ?',whereArgs: [task.toString()]);
    });
  }

  static clearLastMonthsRecord() async {
    DateTime currentDate = DateTime.now();
    // create a new dateTime object with one subtracted from month then get the int representing last month
    int lastMonth = new DateTime(currentDate.year,currentDate.month-1).month;
    await _analyticsDb.transaction((txn) async {
    await txn.execute(createAnalyticsTable);
    await txn.delete(Analytics_Table_Name,where: '$Column_Month = $lastMonth');
    });
  }

  static Future<List<AnalyticsData>> readAnalytics() async {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;
    
    List<Map<String,Object?>> dbResult = await _analyticsDb.transaction((txn) async {
      await txn.execute(createAnalyticsTable);
      // return the transcation query as the dbResult
      return await txn.query(Analytics_Table_Name,where: '$Column_Month = $currentMonth');
      });

    List<int> recordedDaysInDb = [];
    //create a list of all the days recorded in the database
    dbResult.forEach((row) => recordedDaysInDb.add(row[Column_day] as int));
    //create a set to know the active days (so it does not repeat days in list)
    Set<int> activeDays = Set.from(recordedDaysInDb);
    // to store the result of the analytics
    List<AnalyticsData> analyticsResult = [];
    //the number of times that active day repeat in the list is equilavent to the number of task completed on that day
    activeDays.forEach((activeDay) { 
      int numberOfTasksCompleted = 0;
      recordedDaysInDb.forEach((day) {if(day == activeDay){++numberOfTasksCompleted;}});

      AnalyticsData newData = AnalyticsData(date: DateTime(currentYear,currentMonth,activeDay), numberOfTasksCompleted: numberOfTasksCompleted);
      analyticsResult.add(newData);
      // print('${newData.date} ${newData.numberOfTasksCompleted}');
      });
      return analyticsResult;
  }

  static Future<void> close() async => await _analyticsDb.close();
}


class AnalyticsData{
  DateTime date;
  int numberOfTasksCompleted;
  AnalyticsData({required this.date,required this.numberOfTasksCompleted});
}