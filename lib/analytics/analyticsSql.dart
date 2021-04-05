import 'package:idealog/analytics/analyticsColumn.dart';
import 'package:idealog/analytics/analyticsSqlStatements.dart';
import 'package:sqflite/sqflite.dart';

class AnalyticsSql {

  static writeOrUpdate(List<int> task)async{
    DateTime now = DateTime.now();
    final int year = now.year;
    final int month = now.month;
    final int day = now.day;
    Database _analyticsDb = await openDatabase(Analytics_Table_Name,version: 1,onCreate: (_db,_version)=>print('Started Analytics'));
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
    Database _analyticsDb = await openDatabase(Analytics_Table_Name,version: 1,onCreate: (_db,_version)=>print('Started Analytics'));
    await _analyticsDb.execute(createAnalyticsTable);
    await _analyticsDb.delete(Analytics_Table_Name,where: '$Column_Completed_Analytics_Task = ?',whereArgs: [task.toString()]);
    await _analyticsDb.close();
  }

  static clearLastMonthsRecord() async {
    int lastMonth = DateTime.now().month-1;
    Database _analyticsDb = await openDatabase(Analytics_Table_Name,version: 1,onCreate: (_db,_version)=>print('Started Analytics'));
    await _analyticsDb.execute(createAnalyticsTable);
    await _analyticsDb.delete(Analytics_Table_Name,where: '$Column_Month = $lastMonth');
    await _analyticsDb.close();
  }

  static readAnalytics() async {
    int currentMonth = DateTime.now().month;
    Database _analyticsDb = await openDatabase(Analytics_Table_Name,version: 1,onCreate: (_db,_version)=>print('Started Analytics'),readOnly: true);
    await _analyticsDb.execute(createAnalyticsTable);
    List<Map<String,Object?>> result = await _analyticsDb.query(Analytics_Table_Name,where: '$Column_Month = $currentMonth');
    await _analyticsDb.close();
    List<int> allDays = [];
    result.forEach((row) { allDays.add(int.parse(row[Column_day].toString()));});
    Set<int> activeDays = Set.from(allDays);
    print(result.length);
    print(result);
    activeDays.forEach((day) { 
      int numberOfTasks = 0;
      allDays.forEach((element) {if(element == day){++numberOfTasks;}});
      Data newD = Data(date: DateTime(2021,4,day), numberOfTasksCompleted: numberOfTasks);
      print('${newD.date} ${newD.numberOfTasksCompleted}');});
    print('$allDays   $activeDays');
  }
}

class Data{
  DateTime date;
  int numberOfTasksCompleted;
  Data({required this.date,required this.numberOfTasksCompleted});
}