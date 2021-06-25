import 'package:idealog/core-models/ideasModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:idealog/global/extension.dart';

import 'idealog_variables.dart';

class IdealogDatabase{

  IdealogDatabase._();
  static final instance = new IdealogDatabase._();

  late final BriteDatabase briteDb;
  final String tableNameKeyForMap = "TableName";
  final String tasksKeyForMap = "Tasks";

  Future<void> initialize() async {
    final Database databaseInstance = await openDatabase('idealog.sqlite',version: 1);
    briteDb = BriteDatabase(databaseInstance, logger: null);
  }

  Future<void> writeToDb({required IdeaModel idea}) async {
    await briteDb.transactionAndTrigger((txn) async {

        var batch = txn.batch();
        createTablesIfNotExist(batch);

        List<List<int>> completedTasks = idea.completedTasks;
        List<List<int>> uncompletedTasks = idea.uncompletedTasks;

        batch.insert(ideasTableName, {
          Column_uniqueId:  '${idea.uniqueId}',
          Column_ideaTitle  :idea.ideaTitle,
          Column_moreDetails: idea.moreDetails
        });

        addTasksToTable(
          batch: batch,
          uniqueId: idea.uniqueId!,
          tables: [
              {
                tableNameKeyForMap: completedTasksTableName,
                tasksKeyForMap: completedTasks
              },
              {
                tableNameKeyForMap: uncompletedTasksTableName,
                tasksKeyForMap: uncompletedTasks
              },
          ]);

          await batch.commit(noResult: true);
      }
    );
  }

  void deleteFromDB({required String uniqueId}) async {

    await briteDb.transactionAndTrigger((txn) async { 
      var batch = txn.batch();

      batch.execute('delete from $ideasTableName where $Column_uniqueId = $uniqueId');
      batch.execute('delete from $completedTasksTableName where $Column_uniqueId = $uniqueId');
      batch.execute('delete from $uncompletedTasksTableName where $Column_uniqueId = $uniqueId');

      await batch.commit(noResult: true,continueOnError: true);
      });
  }

  void createTablesIfNotExist<T extends Batch>(T batch){    
    batch.execute(createIdeasTableSqlCommand);
    batch.execute(createCompletedTableSqlCommand);
    batch.execute(createUncompletedTableSqlCommand);
  }

// Add the tasks to their corresponding table using the idea's uniqueId as their uniqueId
  void addTasksToTable <T extends Batch>({required T batch,required int uniqueId,required List<Map<String, dynamic>> tables}) async {
              tables.forEach((table) {
                  List<List<int>> allTasksInTable = table[tasksKeyForMap];
                  String tableName = table[tableNameKeyForMap];
                  
                  allTasksInTable.forEach((task) async =>
                    batch.insert(tableName, {
                      Column_uniqueId: '$uniqueId',
                      Column_tasks: '$task'
                    })
                  );
              });
              
        }

    
    Future<List<IdeaModel>> readFromDb() async {
      List<IdeaModel> allIdeasFromDb = [];
      briteDb.execute(createIdeasTableSqlCommand);
      briteDb.execute(createCompletedTableSqlCommand);
      briteDb.execute(createUncompletedTableSqlCommand);

      var resIdeas = await briteDb.query(ideasTableName);

      for(var idea in resIdeas){
        int uniqueId = int.parse(idea['uniqueId'].toString());
        var com = (await briteDb.query(completedTasksTableName,where: 'uniqueId = ?',whereArgs: [uniqueId])).map((e) => e['tasks']);
        var uncom = (await briteDb.query(uncompletedTasksTableName,where: 'uniqueId = ?',whereArgs: [uniqueId])).map((e) => e['tasks']);
        allIdeasFromDb.add(IdeaModel.readFromDb(ideaTitle: idea['ideaTitle'].toString(), completedTasks: com.toList().toString().fromDbStringToListInt, uniqueId: uniqueId, uncompletedTasks: uncom.toList().toString().fromDbStringToListInt));
      }

      return allIdeasFromDb;
  }

  Future<void> drop() async {
    
          await briteDb.delete(ideasTableName);
          await briteDb.delete(completedTasksTableName);
          await briteDb.delete(uncompletedTasksTableName);
  }
  
}
