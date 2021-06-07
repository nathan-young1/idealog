import 'dart:io';
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
    final file = File(p.join(dbFolder, 'analytics.db'));

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
    var now = DateTime.now();
    await into(analyticsSql).insert(AnalyticsSqlCompanion(
    year: Value(now.year),
    month: Value(now.month),
    day: Value(now.day),
    completedTasks: Value(task.toString())
    ));
  }

  Future<List<AnalyticChartData>> readAnalytics() async {

    var now = DateTime.now();
    
    var dbResult = await (select(analyticsSql)..where((row) => row.month.equals(now.month) & row.year.equals(now.year))).get();

    //create a list of all the days recorded in the database
    var recordedDaysInDb = <int>[];
    
    dbResult.forEach((row) => recordedDaysInDb.add(row.day));
    //create a set to remove duplicate dates

    var ActiveDays = Set<int>.from(recordedDaysInDb);

    // To store the AnalyticChartData
    var fullChartData = <AnalyticChartData>[];

    // The number of times a day repeats is equilavent to the number of tasks completed that day

    ActiveDays.forEach((ActiveDay) { 
      var numberOfTasksCompleted = recordedDaysInDb.where((day) => day == ActiveDay).length;

      var newData = AnalyticChartData(
        date: DateTime(now.year,now.month,ActiveDay),
        numberOfTasksCompleted: numberOfTasksCompleted);

      fullChartData.add(newData);
      });
      return fullChartData;

  }

    Future<void> clearObsoluteData() async {
    var now = DateTime.now();
    await (delete(analyticsSql)..where((row) => row.month.isNotIn([now.month]))).go();
    }

    Future<void> removeTaskFromAnalytics(List<int> task) async =>
      await (delete(analyticsSql)..where((row) => row.completedTasks.equals(task.toString()))).go();

}
