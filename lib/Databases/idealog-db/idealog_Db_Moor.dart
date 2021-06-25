import 'dart:io';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:path/path.dart' as p;
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlbrite/sqlbrite.dart';

import 'idealog_variables.dart';

// assuming that your file is called filename.dart. This will give an error at first,
// but it's needed for moor to know about the generated code
part 'idealog_Db_Moor.g.dart';

@DataClassName('Idea')
class Ideas extends Table {
  IntColumn get uniqueId => integer().autoIncrement()();
  TextColumn get ideaTitle => text()();
  TextColumn get moreDetails => text().nullable()();
  TextColumn get completedTasks => text().nullable()();
  TextColumn get uncompletedTasks => text().nullable()();
}



LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getDatabasesPath();
    final file = File(p.join(dbFolder, 'idealog.db'));

    return VmDatabase(file);
  });
}


@UseMoor(tables: [Ideas])
class IdealogDb extends _$IdealogDb{
  // we tell the database where to store the data with this constructor
  IdealogDb() : super(_openConnection());

  // you should bump this number up whenever you change or add a table definition.
  @override
  int get schemaVersion => 1;

  Stream<List<IdeaModel>> get watchIdeasInDb => select(ideas).watch().map((listOfIdeas) => 
  listOfIdeas.map((idea) => IdeaModel.readDb(idea: idea)).toList());

  Future<void> deleteFromDb({required int uniqueId}) async =>
       await (delete(ideas)..where((row) => row.uniqueId.equals(uniqueId))).go();

  Future<void> insertToDb({required IdeaModel newEntry}) async { 
    var companionData = IdeasCompanion(
    ideaTitle: Value(newEntry.ideaTitle),
    uncompletedTasks: Value(newEntry.uncompletedTasks.toString()),
    completedTasks: Value(newEntry.completedTasks.toString()),
    moreDetails: Value(newEntry.moreDetails));
    await into(ideas).insert(companionData);
  }

  Future<void> updateDb({required IdeaModel updatedEntry}) async { 
    var companionData = IdeasCompanion(
    ideaTitle: Value(updatedEntry.ideaTitle),
    uniqueId: Value(updatedEntry.uniqueId!),
    uncompletedTasks: Value(updatedEntry.uncompletedTasks.toString()),
    completedTasks: Value(updatedEntry.completedTasks.toString()),
    moreDetails: Value(updatedEntry.moreDetails));
    await update(ideas).replace(companionData);
    }

    static final IdealogDb instance = IdealogDb();

}



// class Sqlite{
//   // making database object static so that all operations uses one db object
//   static late Database _database;
//   static Future<List<Idea>> readFromDb() async {
//       List<Idea> allIdeasFromDb = [];

//       var result = await _database.transaction((txn) async {
//         await txn.execute(createIdeasTableSqlCommand);
//         return await txn.query(ideasTableName);
//         });

//         result.forEach((idea) { 
//         Object? completedTasks = idea[Column_completedTasks];
//         Object? uncompletedTasks = idea[Column_uncompletedTasks];
//         allIdeasFromDb.add(
//         Idea.readFromDb(
//         ideaTitle: idea[Column_ideaTitle].toString(),
//         uniqueId: int.parse(idea[Column_uniqueId].toString()),
//         moreDetails: idea[Column_moreDetails].toString(),
//         completedTasks: (completedTasks != null)?completedTasks.fromDbStringToListInt:[],
//         uncompletedTasks: (uncompletedTasks != null)?uncompletedTasks.fromDbStringToListInt:[]
//         ));});

//         return allIdeasFromDb;
//   }

//   static updateDb(int uniqueId,{required Idea idea}) async {
//     await _database.transaction((txn) async {
//     await txn.execute(createIdeasTableSqlCommand);
//     List<List<int>> completedTasks = idea.completedTasks;
//     List<List<int>> uncompletedTasks = idea.uncompletedTasks;
//     Map<String,Object?> updatedData = Map<String,Object?>();
//     updatedData[Column_completedTasks] = (completedTasks.isEmpty)?null:'$completedTasks';
//     updatedData[Column_uncompletedTasks] = (uncompletedTasks.isEmpty)?null:'$uncompletedTasks';
//     updatedData[Column_moreDetails] = idea.moreDetails;
//     await txn.update(ideasTableName, updatedData,where: '$Column_uniqueId = $uniqueId');
//     });
//   }

//   static Timer? periodicTimer;
//   static initialize() async {
//     _database = await openDatabase(sqliteDbName,version: 1,onCreate: (_db,_version)=>print('${_db.path} has been created'));
//     periodicTimer = Timer.periodic(Duration(seconds: 1), (_) async {
//         _dbStreamController.add(await Sqlite.readFromDb());
//     });
//   }

// } 

