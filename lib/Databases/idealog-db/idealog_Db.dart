import 'package:flutter/cupertino.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:idealog/global/typedef.dart';
import 'idealog_variables.dart';

class IdealogDb with ChangeNotifier{

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
      batch.insert(ideasTableName, {Column_ideaPrimaryKey: '${idea.uniqueId}',Column_ideaTitle: idea.ideaTitle,Column_moreDetails: idea.moreDetails??''});

      _putTasksInTheirCorrespondingTable(batch: batch, uniqueId: idea.uniqueId!, uncompletedTasks: uncompletedTasks, completedTasks: completedTasks);

      await batch.commit(noResult: true);
      }
    );
  }

  Future<void> deleteIdea({required int uniqueId}) async {

    await briteDb.transactionAndTrigger((txn) async { 
      var batch = txn.batch();
      Function delete = (String tableName) => 'delete from $tableName where $Column_ideaPrimaryKey = $uniqueId';

      batch.execute(delete(ideasTableName));
      batch.execute(delete(completedTable));
      batch.execute(delete(uncompletedTable));

      await batch.commit(noResult: true);
      });
  }

  Future<void> deleteTask({required Task task}) async {

    await briteDb.transactionAndTrigger((txn) async { 
      var batch = txn.batch();
      String deleteSql = 'where $Column_taskPrimaryKey = ?';
      // I am deleting from the two tables because if the task does not exist in a table it won't cause any error
      batch.delete(completedTable,where: deleteSql,whereArgs: [task.primaryKey]);
      batch.delete(uncompletedTable,where: deleteSql,whereArgs: [task.primaryKey]);

      await batch.commit(noResult: true);
      });
  }

  Future<void> addTask({required Task taskRow, required int ideaPrimaryKey, required int lastUncompletedRowIndex}) async {

    await briteDb.transactionAndTrigger((txn) async { 

      await txn.insert(uncompletedTable, {Column_ideaPrimaryKey: '$ideaPrimaryKey',Column_tasks: '${taskRow.task}',Column_taskOrder: '$lastUncompletedRowIndex'});
      });
  }

  Future<void> completeTask({required Task taskRow, required int ideaPrimaryKey, required int lastCompletedOrderIndex}) async {
    
       await briteDb.transactionAndTrigger((txn) async { 
      var batch = txn.batch();

      batch.delete(uncompletedTable,where: '$Column_taskPrimaryKey = ?',whereArgs: [taskRow.primaryKey]);
      // Add one to the last Order index before adding it to the completed table
      batch.insert(completedTable, {Column_ideaPrimaryKey: '$ideaPrimaryKey',Column_tasks: '${taskRow.task}',Column_taskOrder: '${++lastCompletedOrderIndex}'});

      await batch.commit(noResult: true);
      });

  }

  Future<void> uncheckCompletedTask({required Task taskRow, required int ideaPrimaryKey, required int lastUncompletedOrderIndex}) async {
    
    await briteDb.transactionAndTrigger((txn) async { 
      var batch = txn.batch();
      
      batch.delete(completedTable,where: '$Column_taskPrimaryKey = ?',whereArgs: [taskRow.primaryKey]);
      // Add one to the last Order index before adding it to the uncompleted table
      batch.insert(uncompletedTable, {Column_ideaPrimaryKey: '$ideaPrimaryKey',Column_tasks: '${taskRow.task}',Column_taskOrder: '${++lastUncompletedOrderIndex}'});

      await batch.commit(noResult: true);
    });

  }

  Future<void> changeMoreDetail({required Idea idea}) async {
      await briteDb.transactionAndTrigger((txn) async {
        await txn.update(ideasTableName,
          {Column_moreDetails : idea.moreDetails??''},
          where: 'where $Column_ideaPrimaryKey = ?',
          whereArgs: [idea.uniqueId]);
      });
  }

  Stream<List<Idea>> get readFromDb {
      List<Idea> allIdeasFromDb = [];
      briteDb.execute(createIdeasTableSqlCommand);
      briteDb.execute(createCompletedTableSqlCommand);
      briteDb.execute(createUncompletedTableSqlCommand);

      // var resIdeas = await briteDb.query(ideasTableName);
      // ignore: cancel_subscriptions
      return briteDb.createQuery(ideasTableName).asyncMap((res) async => await res()).asyncMap((event) async { 

        for(var idea in event){
          int uniqueId = int.parse(idea[Column_ideaPrimaryKey].toString());

          Map<String, DBTaskList> tasks = await getTasksForIdea(uniqueId: uniqueId);

          Idea test = Idea.readFromDb(ideaTitle: idea[Column_ideaTitle].toString(), completedTasks: tasks[completedTable]!, uniqueId: uniqueId, uncompletedTasks: tasks[uncompletedTable]!);
          
          allIdeasFromDb.add(test);
        }
        return allIdeasFromDb;
      
      });
      
      // for(var idea in resIdeas){
      //   int uniqueId = int.parse(idea[Column_ideaPrimaryKey].toString());

      //   Map<String, DBTaskList> tasks = await getTasksForIdea(uniqueId: uniqueId);

      //   Idea test = Idea.readFromDb(ideaTitle: idea[Column_ideaTitle].toString(), completedTasks: tasks[completedTable]!, uniqueId: uniqueId, uncompletedTasks: tasks[uncompletedTable]!);
        
      //   allIdeasFromDb.add(test);
      // }
      // return allIdeasFromDb;
  }

  Future<void> dropAllTablesInDb() async {
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


// ==============================================================Functions for methods============================================== //

  // Convert Db query to Task object
  Task _convertToTask(Map<String, Object?> e){
      var task = e[Column_tasks] as List<int>;
      var orderIndex = e[Column_taskOrder] as int;
      return Task(task: task, orderIndex: orderIndex);
  }

  // Add tasks to a specified table.
  void _addTasksToTable <T extends Batch>({required T batch,required int uniqueId,required DBTaskList tasks,required String tableName}) =>
        tasks.forEach((row) =>
          batch.insert(tableName, {Column_ideaPrimaryKey: '$uniqueId',Column_tasks: '${row.task}',Column_taskOrder: '${row.orderIndex}'}));

  
  // Make query to database for the tasks
  Future<DBTaskList> _taskQuery(String tableName,int uniqueId) async =>
     (await briteDb.query(tableName,where: 'uniqueId = ?',whereArgs: [uniqueId])).map(_convertToTask).toList();
  
}