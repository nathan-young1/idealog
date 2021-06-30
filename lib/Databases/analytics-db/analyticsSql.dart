import 'package:idealog/Databases/analytics-db/analytics_config.dart';
import 'package:idealog/core-models/ideaModel.dart' show Task;
import 'package:sqflite/sqflite.dart';

class AnalyticChartData{
  DateTime date;
  int numberOfTasksCompleted;
  AnalyticChartData({required this.date,required this.numberOfTasksCompleted});
}

class AnalyticDB{

  AnalyticDB._();
  static final AnalyticDB instance = new AnalyticDB._();

  late Database _analyticsDb;

  Future<void> initialize() async =>
    _analyticsDb = await openDatabase("analytics.sqlite",version: 1);

  /// Record a task in the analytics table.
  Future<void> writeOrUpdate(Task taskRow) async {

    var now = DateTime.now();
    _analyticsDb.transaction((txn) async {
      var uniqueKey = await getUniqueId(txn, analyticsTable);
      // first get the unique id for the primary key
      await txn.insert(analyticsTable, {
        Column_year : now.year,
        Column_month : now.month,
        Column_day : now.day,
        Column_key : uniqueKey,
        Column_completedTasks : taskRow.task
      });
    });
  }

    /// Get the last primary key in the table ,then increment it by one for a new unique key.
  Future<int> getUniqueId(Transaction txn,String tableName) async {

    var queryResult = await txn.query(analyticsTable,orderBy: '$Column_key DESC LIMIT 1',columns: [Column_key]);

    List<int> keysInDb = queryResult.map((e) => e[Column_key] as int).toList();

    int newKey = (keysInDb.isEmpty)?0:++keysInDb.last;

    return newKey;
  }


  Future<List<AnalyticChartData>> readAnalytics() async {

    var now = DateTime.now();
    var dbResult = await _analyticsDb.transaction((txn) async {
        await txn.query(analyticsTable,where: '$Column_year == ? and $Column_month == ?',whereArgs: [now.year,now.month]);
      });

    //create a list of all the days recorded in the database
    var recordedDaysInDb = <int>[];
    
    dbResult.forEach((row) => recordedDaysInDb.add(row.day));
    //create a set to remove duplicate dates

    var activeDays = Set<int>.from(recordedDaysInDb);

    // To store the AnalyticChartData
    var fullChartData = <AnalyticChartData>[];

    // The number of times a day repeats is equilavent to the number of tasks completed that day

    activeDays.forEach((activeDay) { 
      var numberOfTasksCompleted = recordedDaysInDb.where((day) => day == activeDay).length;

      var newData = AnalyticChartData(
        date: DateTime(now.year,now.month,activeDay),
        numberOfTasksCompleted: numberOfTasksCompleted);

      fullChartData.add(newData);
      });
      return fullChartData;

  }


  /// Clear the data of all months that is not the current month.
  Future<void> clearObsoluteData() async {
    var now = DateTime.now();
    await _analyticsDb.transaction((txn) async {
        await txn.delete(analyticsTable,where: '$Column_month != ?',whereArgs: [now.month]);
    });
  }

  /// Remove a particular task from the analytics table.
  Future<void> removeTaskFromAnalytics(Task taskRow) async =>
    await _analyticsDb.transaction((txn) async {
        await txn.delete(analyticsTable,where: '$Column_completedTasks == ?',whereArgs: [taskRow.task]);
    });

}
