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

  static writeToDb({Idea? idea}) async {

    Database _database = await openDatabase(sqliteDbName,version: 1,onCreate: (_db,_version)=>print('${_db.path} has been created'));

      await _database.execute(createIdeasTableSqlCommand);
      List<List<int>> completedTasks = idea!.completedTasks;
      List<List<int>> uncompletedTasks = idea.uncompletedTasks;

      _database.insert(ideasTableName, {
        Column_uniqueId:  '${idea.uniqueId}',
        Column_ideaTitle  :idea.ideaTitle,
        Column_moreDetails: idea.moreDetails,
        Column_completedTasks:  (completedTasks.isEmpty)?null:'$completedTasks',
        Column_uncompletedTasks: (uncompletedTasks.isEmpty)?null:'$uncompletedTasks'
        });

    await _database.close();
  }

  static deleteFromDB({required String uniqueId}) async {
    Database _database = await openDatabase(sqliteDbName,onCreate: (_,__)=>print('${_.path} has been created'),version: 1);
    await _database.execute('delete from $ideasTableName where $Column_uniqueId = $uniqueId');
    await _database.close();
  }

  static Future<List<Idea>> readFromDb() async {
      List<Idea> allIdeasFromDb = [];
        
        Database _database = await openDatabase(sqliteDbName,version: 1,onCreate: (_db,_version)=>print('${_db.path} has been created'));

        await _database.execute(createIdeasTableSqlCommand);
        var result = await _database.query(ideasTableName);
        await _database.close();
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
            Database _database = await openDatabase(sqliteDbName,version: 1,onCreate: (_db,_version)=>print('${_db.path} has been created'));
            await _database.execute(createIdeasTableSqlCommand);
            print('database has been initialized');
            var idsFromDb = await _database.query(ideasTableName,columns: [Column_uniqueId]);
            List<int> unavailableIds = idsFromDb.map((map) => int.parse('${map[Column_uniqueId]}')).toList();
            //if it does not contain the id do not loop
            while(unavailableIds.contains(uniqueId)){
              uniqueId = Random().nextInt(maxRandomNumber);
            }
            return uniqueId;
  }

  static updateDb(int uniqueId,{required Idea idea}) async {
    Database _database = await openDatabase(sqliteDbName,version: 1,onCreate: (_db,_version)=>print('${_db.path} has been created'));
    await _database.execute(createIdeasTableSqlCommand);
    List<List<int>> completedTasks = idea.completedTasks;
    List<List<int>> uncompletedTasks = idea.uncompletedTasks;
    Map<String,Object?> updatedData = Map<String,Object?>();
    updatedData[Column_completedTasks] = (completedTasks.isEmpty)?null:'$completedTasks';
    updatedData[Column_uncompletedTasks] = (uncompletedTasks.isEmpty)?null:'$uncompletedTasks';
    updatedData[Column_moreDetails] = idea.moreDetails;
    await _database.update(ideasTableName, updatedData,where: '$Column_uniqueId = $uniqueId');
    await _database.close();
  }

  static Timer? periodicTimer;
  static initialize(){
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