import 'package:idealog/analytics/analyticsColumn.dart';
import 'package:idealog/analytics/analyticsSqlStatements.dart';
import 'package:sqflite/sqflite.dart';

class AnalyticsSql {

  static writeOrUpdate(List<int> task)async{
    DateTime now = DateTime.now();
    final int year = now.year;
    // i minused one from month because dart months starts from 1-12 while java months starts from 0-11
    final int month = now.month-1;
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
    // i minused two from month because dart months starts from 1-12 while java months starts from 0-11 
    // and since this month is (month -1) last month will be (month -2)
    int lastMonth = DateTime.now().month-2;
    Database _analyticsDb = await openDatabase(Analytics_Db_Name,version: 1,onCreate: (_db,_version)=>print('Started Analytics'));
    await _analyticsDb.execute(createAnalyticsTable);
    await _analyticsDb.delete(Analytics_Table_Name,where: '$Column_Month = $lastMonth');
    await _analyticsDb.close();
  }

  static Future<List<AnalyticsData>> readAnalytics() async {
    DateTime now = DateTime.now();
    // i minused one from month because dart months starts from 1-12 while java months starts from 0-11
    int currentMonth = now.month-1;
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