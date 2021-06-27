import 'dart:math';
import 'package:flutter/material.dart';
import 'package:idealog/global/extension.dart';
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

      _createTablesIfNotExist(txn);

      List<Task> completedTasks = idea.completedTasks;
      List<Task> uncompletedTasks = idea.uncompletedTasks;

      // Insert the idea into the database
      int uniqueIdForIdea = await getUniqueId(txn,ideasTableName);
      await txn.insert(ideasTableName, {Column_ideaTitle: idea.ideaTitle,Column_moreDetails: idea.moreDetails??'',Column_ideaPrimaryKey: uniqueIdForIdea});
      _putTasksInTheirCorrespondingTable(txn: txn, uncompletedTasks: uncompletedTasks, completedTasks: completedTasks, ideaPrimaryKey: uniqueIdForIdea);

      }
    );
  }

  Future<void> deleteIdea({required int uniqueId}) async {

    await briteDb.transactionAndTrigger((txn) async { 
      var batch = txn.batch();
      Function delete = (String tableName) => batch.delete(tableName,where: '$Column_ideaPrimaryKey = $uniqueId');

      delete(ideasTableName);
      delete(completedTable);
      delete(uncompletedTable);

      await batch.commit(noResult: true);
      });
  }

  Future<void> deleteTask({required Task task}) async {

    await briteDb.transactionAndTrigger((txn) async { 
      var batch = txn.batch();
      String deleteSql = '$Column_taskPrimaryKey = ?';
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
      // get id that does not exist in completed table then use it for this task you are adding to the table
      int uniqueIdForTask = await getUniqueId(txn,completedTable);

      batch.delete(uncompletedTable,where: '$Column_taskPrimaryKey = ?',whereArgs: [taskRow.primaryKey]);
      // Add one to the last Order index before adding it to the completed table
      batch.insert(completedTable, {Column_ideaPrimaryKey: '$ideaPrimaryKey',Column_tasks: '${taskRow.task}',Column_taskOrder: '${++lastCompletedOrderIndex}',Column_taskPrimaryKey: uniqueIdForTask});

      await batch.commit(noResult: true);
      });

  }

  Future<void> uncheckCompletedTask({required Task taskRow, required int ideaPrimaryKey, required int lastUncompletedOrderIndex}) async {
    
    await briteDb.transactionAndTrigger((txn) async { 
      var batch = txn.batch();
      // get id that does not exist in uncompleted table then use it for this task you are adding to the table
      int uniqueIdForTask = await getUniqueId(txn,uncompletedTable);
      batch.delete(completedTable,where: '$Column_taskPrimaryKey = ?',whereArgs: [taskRow.primaryKey]);
      // Add one to the last Order index before adding it to the uncompleted table
      batch.insert(uncompletedTable, {Column_ideaPrimaryKey: '$ideaPrimaryKey',Column_tasks: '${taskRow.task}',Column_taskOrder: '${++lastUncompletedOrderIndex}',Column_taskPrimaryKey: uniqueIdForTask});

      await batch.commit(noResult: true);
    });

  }

  Future<void> changeMoreDetail({required Idea idea}) async {
      await briteDb.transactionAndTrigger((txn) async {
        await txn.update(ideasTableName,
          {Column_moreDetails : idea.moreDetails},
          where: '$Column_ideaPrimaryKey = ?',
          whereArgs: [idea.uniqueId]);
      });
  }

  Stream<List<Idea>> get readFromDb {
      briteDb.execute(createIdeasTableSqlCommand);
      briteDb.execute(createCompletedTableSqlCommand);
      briteDb.execute(createUncompletedTableSqlCommand);

      // var resIdeas = await briteDb.query(ideasTableName);
      // ignore: cancel_subscriptions
      return briteDb.createQuery(ideasTableName).asyncMap((res) => res()).asyncMap((event) async { 
        List<Idea> allIdeasFromDb = [];

        event.forEach((idea) async {
          int uniqueId = int.parse(idea[Column_ideaPrimaryKey].toString());

          Map<String, DBTaskList> tasks = await getTasksForIdea(uniqueId: uniqueId);
          Idea test = Idea.readFromDb(ideaTitle: idea[Column_ideaTitle].toString(),moreDetails: idea[Column_moreDetails].toString(), completedTasks: tasks[completedTable]!, uniqueId: uniqueId, uncompletedTasks: tasks[uncompletedTable]!);
          allIdeasFromDb.add(test);
        });

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
          // await briteDb.delete(ideasTableName);
          // await briteDb.delete(completedTable);
          // // // await briteDb.delete(uncompletedTable);
          // await briteDb.execute('Drop Table $ideasTableName');
          // await briteDb.execute('Drop Table $completedTable');
          // await briteDb.execute('Drop Table $uncompletedTable');
            //  print('dropped');
  }

  Future<int> getUniqueId(Transaction txn,String tableName) async {
    var queryResult = await txn.query(tableName);
    List<int> allPrimaryKeyInDb = queryResult.map((e) => e[(tableName == ideasTableName)?Column_ideaPrimaryKey:Column_taskPrimaryKey]).map((e) => e as int).toList();
    Random generator = new Random();
    int newUniqueKey = generator.nextInt(10000);
    print(newUniqueKey);
    print(allPrimaryKeyInDb.any((key) => key == newUniqueKey));
    while(allPrimaryKeyInDb.any((key) => key == newUniqueKey)){
      newUniqueKey = generator.nextInt(5000);
    }
    return newUniqueKey;
  }


// =====================================================Private class methods==================================================== //

  Future<void> _createTablesIfNotExist(Transaction txn) async {    
    await txn.execute(createIdeasTableSqlCommand);
    await txn.execute(createCompletedTableSqlCommand);
    await txn.execute(createUncompletedTableSqlCommand);
  }

// Calls the method _addTasksToTable for completed and uncompleted tasks.
  void _putTasksInTheirCorrespondingTable({required Transaction txn,required DBTaskList uncompletedTasks,required DBTaskList completedTasks,required int ideaPrimaryKey}){
        _addTasksToTable(txn: txn,tasks: completedTasks,tableName: completedTable,ideaPrimaryKey: ideaPrimaryKey);
        _addTasksToTable(txn: txn,tasks: uncompletedTasks,tableName: uncompletedTable,ideaPrimaryKey: ideaPrimaryKey);
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
      var task = e[Column_tasks]!.StringToListInt;
      var orderIndex = e[Column_taskOrder] as int;
      var primaryKey = e[Column_taskPrimaryKey] as int;
      return Task(task: task, orderIndex: orderIndex,primaryKey: primaryKey);
  }

  // Add tasks to a specified table.
  void _addTasksToTable({required Transaction txn,required DBTaskList tasks,required String tableName,required int ideaPrimaryKey}) =>
        tasks.forEach((row) async {
          int uniqueIdForTask = await getUniqueId(txn,tableName);
          await txn.insert(tableName, {Column_tasks: '${row.task}',Column_taskOrder: '${row.orderIndex}',Column_ideaPrimaryKey: '$ideaPrimaryKey',Column_taskPrimaryKey: uniqueIdForTask});
          });

  
  // Make query to database for the tasks
  Future<DBTaskList> _taskQuery(String tableName,int uniqueId) async =>
     (await briteDb.query(tableName,where: '$Column_ideaPrimaryKey = ?',whereArgs: [uniqueId])).map(_convertToTask).toList();
  
}