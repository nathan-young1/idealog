import 'package:idealog/Databases/analytics-db/analytics_config.dart';
import 'package:idealog/Databases/idealog-db/idealog_Db.dart';
import 'package:idealog/core-models/ideaModel.dart' show Task;
import 'package:sqflite/sqflite.dart';

class AnalyticChartData{
  DateTime date;
  int numberOfTasksCompleted;
  AnalyticChartData({required this.date,required this.numberOfTasksCompleted});
}

class AnalyticDB {

  AnalyticDB._(){
    notifyListeners();
  }
  static final AnalyticDB instance = new AnalyticDB._();
  /// This uses the IdealogDb instance.
  late final Database dbInstance = IdealogDb.instance.dbInstance;

  Future<void> close() async {
    await dbInstance.close();
  }

  List<AnalyticChartData> analyticsChartData = [];

  /// updates the list containing the analytics data everytime this method is called.
  Future<void> notifyListeners() async {
    analyticsChartData = await _readAnalytics();
    /// sort the list by Date in ascending order.
    analyticsChartData.sort((a,b)=> a.date.compareTo(b.date));
  }

  /// Record a task in the analytics table.
  Future<void> writeOrUpdate(Task taskRow) async {

    var now = DateTime.now();
    await dbInstance.transaction((txn) async {
      await _createTableIfNotExist(txn);
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

    notifyListeners();
  }

    /// Get the last primary key in the table ,then increment it by one for a new unique key.
  Future<int> getUniqueId(Transaction txn,String tableName) async {
    await _createTableIfNotExist(txn);
    var queryResult = await txn.query(analyticsTable,orderBy: '$Column_key DESC LIMIT 1',columns: [Column_key]);

    List<int> keysInDb = queryResult.map((e) => e[Column_key] as int).toList();

    int newKey = (keysInDb.isEmpty)?0:++keysInDb.last;

    return newKey;
  }

  /// Fetch all the analytics data from the database.
  Future<List<AnalyticChartData>> _readAnalytics() async {

    var now = DateTime.now();
    var dbResult = await dbInstance.transaction((txn) async {
        await _createTableIfNotExist(txn);
        return await txn.query(analyticsTable,where: '$Column_year == ? and $Column_month == ?',whereArgs: [now.year,now.month]);
      });

    //create a list of all the days recorded in the database
    var recordedDaysInDb = <int>[];
    
    dbResult.forEach((row) => recordedDaysInDb.add(int.parse(row["$Column_day"].toString())));
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
    await dbInstance.transaction((txn) async {
        await _createTableIfNotExist(txn);
        await txn.delete(analyticsTable,where: '$Column_month != ?',whereArgs: [now.month]);
    });
  }

  /// Remove a particular task from the analytics table.
  Future<void> removeTaskFromAnalytics(Task taskRow,{bool calledByRemoveIdeaFromAnalytics = false}) async =>
    await dbInstance.transaction((txn) async {
        await _createTableIfNotExist(txn);
        await txn.delete(analyticsTable,where: '$Column_completedTasks == ?',whereArgs: [taskRow.task]);
        /// only notify listeners when this was called by ideaManager, this is because i don't want 
        /// it to be calling notify listeners() for every task deleted when we delete an idea.
        if(!calledByRemoveIdeaFromAnalytics) notifyListeners();
    });

  /// remove all the completed tasks in the idea from the analytics table.
  Future<void> removeIdeaFromAnalytics(List<Task> allCompletedTasks) async {
    for(var task in allCompletedTasks) await removeTaskFromAnalytics(task, calledByRemoveIdeaFromAnalytics: true);
    notifyListeners();
  }

  Future<void> _createTableIfNotExist(Transaction txn) async =>
      await txn.execute(createAnalyticsTable);
}
