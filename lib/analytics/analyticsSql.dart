import 'package:idealog/analytics/analyticsColumn.dart';
import 'package:idealog/analytics/analyticsSqlStatements.dart';
import 'package:sqflite/sqflite.dart';

class AnalyticsSql {

  static writeOrUpdate(List<int> task)async{
    DateTime now = DateTime.now();
    final int year = now.year;
    final int month = now.month;
    final int day = now.day;
    Database _analyticsDb = await openDatabase(Analytics_Db_Name,version: 1,onCreate: (_db,_version)=>print('Started Analytics'));
    await _analyticsDb.execute(createAnalyticsTable);
    await _analyticsDb.insert(Analytics_Table_Name,{
      Column_Completed_Analytics_Task: '$task',
      Column_Year: year,
      Column_Month: month,
      Column_day: day
    });
    await _analyticsDb.close();
  }

  static removeTaskFromAnalytics(List<int> task) async {
    Database _analyticsDb = await openDatabase(Analytics_Db_Name,version: 1,onCreate: (_db,_version)=>print('Started Analytics'));
    await _analyticsDb.execute(createAnalyticsTable);
    await _analyticsDb.delete(Analytics_Table_Name,where: '$Column_Completed_Analytics_Task = ?',whereArgs: [task.toString()]);
    await _analyticsDb.close();
  }

  static clearLastMonthsRecord() async {
    DateTime currentDate = DateTime.now();
    // create a new dateTime object with one subtracted from month then get the int representing last month
    int lastMonth = new DateTime(currentDate.year,currentDate.month-1).month;
    Database _analyticsDb = await openDatabase(Analytics_Db_Name,version: 1,onCreate: (_db,_version)=>print('Started Analytics'));
    await _analyticsDb.execute(createAnalyticsTable);
    await _analyticsDb.delete(Analytics_Table_Name,where: '$Column_Month = $lastMonth');
    await _analyticsDb.close();
  }

  static Future<List<AnalyticsData>> readAnalytics() async {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;
    Database _analyticsDb = await openDatabase(Analytics_Db_Name,version: 1,onCreate: (_db,_version)=>print('Started Analytics'));
    await _analyticsDb.execute(createAnalyticsTable);
    List<Map<String,Object?>> dbResult = await _analyticsDb.query(Analytics_Table_Name,where: '$Column_Month = $currentMonth');
    await _analyticsDb.close();
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
}


class AnalyticsData{
  DateTime date;
  int numberOfTasksCompleted;
  AnalyticsData({required this.date,required this.numberOfTasksCompleted});
}