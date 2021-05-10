import 'dart:async';
import 'dart:math';
import 'package:idealog/global/int.dart';
import 'package:idealog/global/strings.dart';
import 'package:idealog/sqlite-db/sqlExecString.dart';
import 'package:sqflite/sqflite.dart';
import 'package:idealog/global/extension.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'ideasDbColumn.dart';

class Sqlite{
  // making database object static so that all operations uses one db object
  static late Database _database;

  static writeToDb({Idea? idea}) async {
    await _database.transaction((txn) async {
      await txn.execute(createIdeasTableSqlCommand);
      List<List<int>> completedTasks = idea!.completedTasks;
      List<List<int>> uncompletedTasks = idea.uncompletedTasks;

      await txn.insert(ideasTableName, {
        Column_uniqueId:  '${idea.uniqueId}',
        Column_ideaTitle  :idea.ideaTitle,
        Column_moreDetails: idea.moreDetails,
        Column_completedTasks:  (completedTasks.isEmpty)?null:'$completedTasks',
        Column_uncompletedTasks: (uncompletedTasks.isEmpty)?null:'$uncompletedTasks'
        });
    });
  }

  static deleteFromDB({required String uniqueId}) async {
    await _database.transaction((txn) async => await txn.execute('delete from $ideasTableName where $Column_uniqueId = $uniqueId'));
  }

  static Future<List<Idea>> readFromDb() async {
      List<Idea> allIdeasFromDb = [];

      var result = await _database.transaction((txn) async {
        await txn.execute(createIdeasTableSqlCommand);
        return await txn.query(ideasTableName);
        });
        
        result.forEach((idea) { 
        Object? completedTasks = idea[Column_completedTasks];
        Object? uncompletedTasks = idea[Column_uncompletedTasks];
        allIdeasFromDb.add(
        Idea.readFromDb(
        ideaTitle: idea[Column_ideaTitle].toString(),
        uniqueId: int.parse(idea[Column_uniqueId].toString()),
        moreDetails: idea[Column_moreDetails].toString(),
        completedTasks: (completedTasks != null)?completedTasks.fromDbStringToListInt:[],
        uncompletedTasks: (uncompletedTasks != null)?uncompletedTasks.fromDbStringToListInt:[]
        ));});
        
        return allIdeasFromDb;
  }


  static Future<int> getUniqueId() async {
            int uniqueId = Random().nextInt(maxRandomNumber);
            await _database.transaction((txn) => txn.execute(createIdeasTableSqlCommand));
            var idsFromDb = await _database.query(ideasTableName,columns: [Column_uniqueId]);
            List<int> unavailableIds = idsFromDb.map((map) => int.parse('${map[Column_uniqueId]}')).toList();
            //if it does not contain the id do not loop
            while(unavailableIds.contains(uniqueId)){
              uniqueId = Random().nextInt(maxRandomNumber);
            }
            return uniqueId;
  }

  static updateDb(int uniqueId,{required Idea idea}) async {
    await _database.transaction((txn) async {
    await txn.execute(createIdeasTableSqlCommand);
    List<List<int>> completedTasks = idea.completedTasks;
    List<List<int>> uncompletedTasks = idea.uncompletedTasks;
    Map<String,Object?> updatedData = Map<String,Object?>();
    updatedData[Column_completedTasks] = (completedTasks.isEmpty)?null:'$completedTasks';
    updatedData[Column_uncompletedTasks] = (uncompletedTasks.isEmpty)?null:'$uncompletedTasks';
    updatedData[Column_moreDetails] = idea.moreDetails;
    await txn.update(ideasTableName, updatedData,where: '$Column_uniqueId = $uniqueId');
    });
  }

  static Timer? periodicTimer;
  static initialize() async {
    _database = await openDatabase(sqliteDbName,version: 1,onCreate: (_db,_version)=>print('${_db.path} has been created'));
    periodicTimer = Timer.periodic(Duration(seconds: 1), (_) async {
        _dbStreamController.add(await Sqlite.readFromDb());
    });
  }

  static close() async {
      periodicTimer!.cancel();
      await _dbStreamController.close();
  }

  //The controller like a pipe for the stream through which i add the latest db check results
  static final StreamController<List<Idea>> _dbStreamController = StreamController<List<Idea>>();

  //The end of the pipe so we can listen to the stream updates
  static Stream<List<Idea>> get dbStream => _dbStreamController.stream;

}