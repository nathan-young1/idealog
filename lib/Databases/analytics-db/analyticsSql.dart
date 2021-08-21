import 'package:idealog/Databases/analytics-db/analytics_config.dart';
import 'package:idealog/Databases/idealog-db/idealog_Db.dart';
import 'package:idealog/core-models/ideaModel.dart' show Task;
import 'package:sqflite/sqflite.dart';

class EfficiencyChartData{
  DateTime date;
  int numberOfTasksCompleted;
  EfficiencyChartData({required this.date,required this.numberOfTasksCompleted});
}

class AnalyticDB {

  AnalyticDB._(){notifyListeners();}
  static final AnalyticDB instance = new AnalyticDB._();
  /// This uses the IdealogDb instance.
  late final Database dbInstance = IdealogDb.instance.dbInstance;

  Future<void> close() async => await dbInstance.close();
  

  List<EfficiencyChartData> efficiencyChartData = [];

  /// updates the list containing the chart data everytime this method is called.
  Future<void> notifyListeners() async {
    efficiencyChartData = await _readAnalytics();
    /// sort the list by Date in ascending order.
    efficiencyChartData.sort((a,b)=> a.date.compareTo(b.date));
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

    int newKey = (keysInDb.isEmpty) ?0 :++keysInDb.last;

    return newKey;
  }

  /// Fetch all the analytics data from the database.
  Future<List<EfficiencyChartData>> _readAnalytics() async {

    var currentTime = DateTime.now();
    var dbResult = await dbInstance.transaction((txn) async {
        await _createTableIfNotExist(txn);
        return await txn.query(analyticsTable,where: '$Column_year == ? and $Column_month == ?',whereArgs: [currentTime.year,currentTime.month]);
      });

    //create a list of all the days recorded in the database
    var daysRecordedInDb = <int>[];
    
    dbResult.forEach((row) => daysRecordedInDb.add(int.parse(row["$Column_day"].toString())));
    //create a set to remove duplicate dates

    var activeDays = Set<int>.from(daysRecordedInDb);

    // To store the EfficiencyChartData
    var efficiencyDataList = <EfficiencyChartData>[];

    // The number of times a day repeats is equilavent to the number of tasks completed that day.
    activeDays.forEach((activeDay) { 
      var numberOfTasksCompleted = daysRecordedInDb.where((day) => day == activeDay).length;

      var chartData = EfficiencyChartData(
        date: DateTime(currentTime.year, currentTime.month, activeDay),
        numberOfTasksCompleted: numberOfTasksCompleted);

      efficiencyDataList.add(chartData);
      });

      return efficiencyDataList;

  }

  /// Clear the data of all months that is not the current month.
  Future<void> clearObsoluteData() async {
    var currentTime = DateTime.now();
    await dbInstance.transaction((txn) async {
        await _createTableIfNotExist(txn);
        await txn.delete(analyticsTable,where: '$Column_month != ?',whereArgs: [currentTime.month]);
    });
  }

  /// Remove a particular task from the analytics table.
  Future<void> removeTaskFromAnalytics(Task taskRow,{bool removeIdeaFromAnalytics = false}) async =>
    await dbInstance.transaction((txn) async {
        await _createTableIfNotExist(txn);
        await txn.delete(analyticsTable,where: '$Column_completedTasks == ?',whereArgs: [taskRow.task]);
        /// only notify listeners when this was called by ideaManager, this is because i don't want 
        /// it to call notify listeners() for every task deleted when we delete an idea.
        if(!removeIdeaFromAnalytics) notifyListeners();
    });

  /// remove all the completed tasks in the idea from the analytics table.
  Future<void> removeIdeaFromAnalytics(List<Task> allCompletedTasks) async {
    for(var task in allCompletedTasks) await removeTaskFromAnalytics(task, removeIdeaFromAnalytics: true);
    notifyListeners();
  }

  Future<void> _createTableIfNotExist(Transaction txn) async =>
      await txn.execute(createAnalyticsTable);
}
