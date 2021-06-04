import 'dart:io';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:path/path.dart' as p;
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:sqflite/sqflite.dart';

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
    final file = File(p.join(dbFolder, 'idealog_db.sqlite'));

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

