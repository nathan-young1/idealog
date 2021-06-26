import 'package:idealog/core-models/ideaModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:idealog/global/extension.dart';
import 'package:idealog/global/typedef.dart';
import 'idealog_variables.dart';

class IdealogDb{

  IdealogDb._();
  static final instance = new IdealogDb._();

  late final BriteDatabase briteDb;

  Future<void> initialize() async {
    final Database databaseInstance = await openDatabase('idealog.sqlite',version: 1);
    briteDb = BriteDatabase(databaseInstance, logger: null);
  }

  Future<void> writeToDb({required Idea idea}) async {

    await briteDb.transactionAndTrigger((txn) async {

      var batch = txn.batch();
      _createTablesIfNotExist(batch);

      List<Task> completedTasks = idea.completedTasks;
      List<Task> uncompletedTasks = idea.uncompletedTasks;

      // Insert the idea into the database
      batch.insert(ideasTableName, {Column_uniqueId: '${idea.uniqueId}',Column_ideaTitle: idea.ideaTitle,Column_moreDetails: idea.moreDetails});

      _putTasksInTheirCorrespondingTable(batch: batch, uniqueId: idea.uniqueId!, uncompletedTasks: uncompletedTasks, completedTasks: completedTasks);

      await batch.commit(noResult: true);
      }
    );
  }

  void deleteFromDB({required String uniqueId}) async {

    await briteDb.transactionAndTrigger((txn) async { 
      var batch = txn.batch();
      Function delete = (String tableName) => 'delete from $tableName where $Column_uniqueId = $uniqueId';

      batch.execute(delete(ideasTableName));
      batch.execute(delete(completedTable));
      batch.execute(delete(uncompletedTable));

      await batch.commit(noResult: true);
      });
  }

  Future<List<Idea>> readFromDb() async {
      List<Idea> allIdeasFromDb = [];
      briteDb.execute(createIdeasTableSqlCommand);
      briteDb.execute(createCompletedTableSqlCommand);
      briteDb.execute(createUncompletedTableSqlCommand);

      var resIdeas = await briteDb.query(ideasTableName);

      for(var idea in resIdeas){
        int uniqueId = int.parse(idea['uniqueId'].toString());

        Map<String, DBTaskList> tasks = await getTasksForIdea(uniqueId: uniqueId);

        Idea test = Idea.readFromDb(ideaTitle: idea['ideaTitle'].toString(), completedTasks: tasks[completedTable]!, uniqueId: uniqueId, uncompletedTasks: tasks[uncompletedTable]!);
        
        allIdeasFromDb.add(test);
      }
      return allIdeasFromDb;
  }

  Future<void> drop() async {
    
          await briteDb.delete(ideasTableName);
          await briteDb.delete(completedTable);
          await briteDb.delete(uncompletedTable);
  }


// =====================================================Private class methods==================================================== //

  void _createTablesIfNotExist<T extends Batch>(T batch){    
    batch.execute(createIdeasTableSqlCommand);
    batch.execute(createCompletedTableSqlCommand);
    batch.execute(createUncompletedTableSqlCommand);
  }

// Add tasks to a specified table.
  void _addTasksToTable <T extends Batch>({required T batch,required int uniqueId,required DBTaskList tasks,required String tableName}) =>
        tasks.forEach((row) =>
          batch.insert(tableName, {Column_uniqueId: '$uniqueId',Column_tasks: '${row.task}',Column_taskOrder: '${row.orderIndex}'}));


// Calls the method _addTasksToTable for completed and uncompleted tasks.
  void _putTasksInTheirCorrespondingTable({required Batch batch,required int uniqueId,required DBTaskList uncompletedTasks,required DBTaskList completedTasks}){
        _addTasksToTable(batch: batch, uniqueId: uniqueId,tasks: completedTasks,tableName: completedTable);
        _addTasksToTable(batch: batch, uniqueId: uniqueId,tasks: uncompletedTasks,tableName: uncompletedTable);
  }

// Get the tasks from their corresponding table using the idea's uniqueId
  Future<Map<String, DBTaskList>> getTasksForIdea({required int uniqueId}) async {

    List<Task> completedTasks = await _taskQuery(completedTable, uniqueId);
    List<Task> uncompletedTasks = await _taskQuery(uncompletedTable, uniqueId);
    
    return {uncompletedTable: uncompletedTasks,completedTable: completedTasks};
  }

// Convert Db query to Task object
  Task _convertToTask(Map<String, Object?> e){
      var task = e[Column_tasks] as List<int>;
      var orderIndex = e[Column_taskOrder] as int;
      return Task(task: task, orderIndex: orderIndex);
  }

// Make query to database for the tasks
  Future<DBTaskList> _taskQuery(String tableName,int uniqueId) async =>
     (await briteDb.query(tableName,where: 'uniqueId = ?',whereArgs: [uniqueId])).map(_convertToTask).toList();
  
}





// class Sqlite{

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

// } 

