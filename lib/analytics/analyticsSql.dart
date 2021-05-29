import 'dart:io';
import 'dart:isolate';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
part 'analyticsSql.g.dart';

class AnalyticChartData{
  DateTime date;
  int numberOfTasksCompleted;
  AnalyticChartData({required this.date,required this.numberOfTasksCompleted});
}

@DataClassName('Analytic')
class AnalyticsSql extends Table{
  IntColumn get key => integer().autoIncrement()();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  IntColumn get day => integer()();
  TextColumn get completedTasks => text()();
}


LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getDatabasesPath();
    final file = File(p.join(dbFolder!, 'analytics_db.sqlite'));

    return VmDatabase(file);
  });
}


@UseMoor(tables: [AnalyticsSql])
class AnalyticDB extends _$AnalyticDB{
  AnalyticDB() : super(_openConnection());


  @override
  int get schemaVersion => 1;

  static final AnalyticDB instance = AnalyticDB();
  

  Future<void> writeOrUpdate(List<int> task) async {
    DateTime NOW = DateTime.now();
    await into(analyticsSql).insert(AnalyticsSqlCompanion(
    year: Value(NOW.year),
    month: Value(NOW.month),
    day: Value(NOW.day),
    completedTasks: Value(task.toString())
    ));
  }

  Future<List<AnalyticChartData>> readAnalytics() async {

    DateTime Now = DateTime.now();
    
    List<Analytic> dbResult = await (select(analyticsSql)..where((row) => row.month.equals(Now.month))).get();

    //create a list of all the days recorded in the database
    List<int> recordedDaysInDb = [];
    
    dbResult.forEach((row) => recordedDaysInDb.add(row.day));
    //create a set to remove duplicate dates

    Set<int> ActiveDays = Set.from(recordedDaysInDb);

    // To store the AnalyticChartData
    List<AnalyticChartData> fullChartData = [];

    // The number of times a day repeats is equilavent to the number of tasks completed that day

    ActiveDays.forEach((ActiveDay) { 
      int numberOfTasksCompleted = recordedDaysInDb.where((day) => day == ActiveDay).length;

      AnalyticChartData newData = AnalyticChartData(
        date: DateTime(Now.year,Now.month,ActiveDay),
        numberOfTasksCompleted: numberOfTasksCompleted);

      fullChartData.add(newData);
      // print('${newData.date} ${newData.numberOfTasksCompleted}');
      });
      return fullChartData;

  }

    Future<void> clearObsoluteData() async {
    DateTime Now = DateTime.now();
    await (delete(analyticsSql)..where((row) => row.month.isNotIn([Now.month]))).go();
    }

    Future<void> removeTaskFromAnalytics(List<int> task) async =>
      await (delete(analyticsSql)..where((row) => row.completedTasks.equals(task.toString()))).go();

}
