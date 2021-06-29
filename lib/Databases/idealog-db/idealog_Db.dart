import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:idealog/global/extension.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:idealog/global/typedef.dart';
import 'idealog_config.dart';

class IdealogDb {

  IdealogDb._():_stream = _streamController.stream.asBroadcastStream();

  static final instance = new IdealogDb._();
  static final StreamController<String?> _streamController = StreamController();
  late Stream<String?> _stream;

  late final Database _dbInstance;

  void close(){
    
    _streamController.close();
  }

  Future<void> initialize() async { 
    _dbInstance = await openDatabase('idealog.sqlite',version: 1);
    notifyListeners();

    // _stream.asyncMap((event) async{
    //     int uniqueIdForTask = 8;
    //     return uniqueIdForTask;
    // }).listen(print);
  }

  
  notifyListeners()=> _streamController.add(null);

  Future<void> writeToDb({required Idea idea}) async {

    await _dbInstance.transaction((txn) async {

      _createTablesIfNotExist(txn);

      List<Task> completedTasks = idea.completedTasks;
      List<Task> uncompletedTasks = idea.uncompletedTasks;

      // Insert the idea into the database
      int uniqueIdForIdea = await getUniqueId(txn,ideasTable);
      await txn.insert(ideasTable, {Column_ideaTitle: idea.ideaTitle,Column_moreDetails: idea.moreDetails??'',Column_ideaId: uniqueIdForIdea});
      _putTasksInTheirCorrespondingTable(txn: txn, uncompletedTasks: uncompletedTasks, completedTasks: completedTasks, ideaPrimaryKey: uniqueIdForIdea);
      
      notifyListeners();
      }
    );
  }

  Future<void> deleteIdea({required int ideaId}) async {

    await _dbInstance.transaction((txn) async { 
      var batch = txn.batch();
      Function delete = (String tableName) => batch.delete(tableName,where: '$Column_ideaId = $ideaId');

      delete(ideasTable);
      delete(completedTable);
      delete(uncompletedTable);

      await batch.commit(noResult: true);
      notifyListeners();
      });
  }

  Future<void> deleteTask({required Task task}) async {

    await _dbInstance.transaction((txn) async { 
      var batch = txn.batch();
      String deleteSql = '$Column_taskId = ?';
      // I am deleting from the two tables because if the task does not exist in a table it won't cause any error
      batch.delete(completedTable,where: deleteSql,whereArgs: [task.primaryKey]);
      batch.delete(uncompletedTable,where: deleteSql,whereArgs: [task.primaryKey]);

      await batch.commit(noResult: true);
      });
  }

  Future<void> addTask({required Task taskRow, required int ideaId, required int lastUncompletedRowIndex}) async {

    await _dbInstance.transaction((txn) async { 
      int uniqueIdForTask = await getUniqueId(txn,uncompletedTable);
      await txn.insert(uncompletedTable, {Column_ideaId: '$ideaId',Column_tasks: '${taskRow.task}',Column_taskOrder: '$lastUncompletedRowIndex',Column_taskId: '$uniqueIdForTask'});
      });
  }

  Future<void> completeTask({required Task taskRow, required int ideaPrimaryKey, required int lastCompletedOrderIndex}) async {
    
       await _dbInstance.transaction((txn) async { 
      var batch = txn.batch();
      // get id that does not exist in completed table then use it for this task you are adding to the table
      int uniqueIdForTask = await getUniqueId(txn,completedTable);

      batch.delete(uncompletedTable,where: '$Column_taskId = ?',whereArgs: [taskRow.primaryKey]);
      // Add one to the last Order index before adding it to the completed table
      batch.insert(completedTable, {Column_ideaId: '$ideaPrimaryKey',Column_tasks: '${taskRow.task}',Column_taskOrder: '${++lastCompletedOrderIndex}',Column_taskId: uniqueIdForTask});

      await batch.commit(noResult: true);
      });

  }

  Future<void> uncheckCompletedTask({required Task taskRow, required int ideaPrimaryKey, required int lastUncompletedOrderIndex}) async {
    
    await _dbInstance.transaction((txn) async { 
      var batch = txn.batch();
      // get id that does not exist in uncompleted table then use it for this task you are adding to the table
      int uniqueIdForTask = await getUniqueId(txn,uncompletedTable);
      batch.delete(completedTable,where: '$Column_taskId = ?',whereArgs: [taskRow.primaryKey]);
      // Add one to the last Order index before adding it to the uncompleted table
      batch.insert(uncompletedTable, {Column_ideaId: '$ideaPrimaryKey',Column_tasks: '${taskRow.task}',Column_taskOrder: '${++lastUncompletedOrderIndex}',Column_taskId: uniqueIdForTask});

      await batch.commit(noResult: true);
    });

  }

  Future<void> changeMoreDetail({required Idea idea}) async {
      await _dbInstance.transaction((txn) async {
        await txn.update(ideasTable,
          {Column_moreDetails : idea.moreDetails},
          where: '$Column_ideaId = ?',
          whereArgs: [idea.uniqueId]);
      });
  }

   Stream<List<Idea>> get readFromDb async* {
     print("here");
       
      // _dbInstance.execute(createIdeasTableSqlCommand);
      // _dbInstance.execute(createCompletedTableSqlCommand);
      // _dbInstance.execute(createUncompletedTableSqlCommand);
      // List<Idea> allIdeasFromDb = [];

      // var resIdeas = await _dbInstance.query(ideasTable);
      
      // for(var idea in resIdeas){
      //   int uniqueId = int.parse(idea[Column_ideaId].toString());

      //   Map<String, DBTaskList> tasks = await getTasksForIdea(uniqueId: uniqueId);

      //   Idea test = Idea.readFromDb(ideaTitle: idea[Column_ideaTitle].toString(), completedTasks: tasks[completedTable]!, uniqueId: uniqueId, uncompletedTasks: tasks[uncompletedTable]!);
        
      //   allIdeasFromDb.add(test);
      // }
      // // return allIdeasFromDb;
      await for (var data in _stream){
        print('called');
      _dbInstance.execute(createIdeasTableSqlCommand);
      _dbInstance.execute(createCompletedTableSqlCommand);
      _dbInstance.execute(createUncompletedTableSqlCommand);
      List<Idea> allIdeasFromDb = [];

      var resIdeas = await _dbInstance.query(ideasTable);
      
      for(var idea in resIdeas){
        int uniqueId = int.parse(idea[Column_ideaId].toString());

        Map<String, DBTaskList> tasks = await getTasksForIdea(uniqueId: uniqueId);

        Idea test = Idea.readFromDb(ideaTitle: idea[Column_ideaTitle].toString(), completedTasks: tasks[completedTable]!, uniqueId: uniqueId, uncompletedTasks: tasks[uncompletedTable]!);
        
        allIdeasFromDb.add(test);
      }

      yield allIdeasFromDb;

      }  
  }

  Future<void> dropAllTablesInDb() async {
    await _dbInstance.execute('Drop Table $ideasTable');
    await _dbInstance.execute('Drop Table $completedTable');
    await _dbInstance.execute('Drop Table $uncompletedTable');
  }

  Future<int> getUniqueId(Transaction txn,String tableName) async {

    var queryResult = await txn.query(tableName);
    List<int> allPrimaryKeyInDb = queryResult.map((e) => e[(tableName == ideasTable)?Column_ideaId:Column_taskId]).map((e) => e as int).toList();
    int newUniqueKey = Random().nextInt(10000);

    while(allPrimaryKeyInDb.any((key) => key == newUniqueKey)){
      newUniqueKey = Random().nextInt(5000);
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
      var primaryKey = e[Column_taskId] as int;
      return Task(task: task, orderIndex: orderIndex,primaryKey: primaryKey);
  }

  // Add tasks to a specified table.
  void _addTasksToTable({required Transaction txn,required DBTaskList tasks,required String tableName,required int ideaPrimaryKey}) =>
        tasks.forEach((row) async {
          int uniqueIdForTask = await getUniqueId(txn,tableName);
          await txn.insert(tableName, {Column_tasks: '${row.task}',Column_taskOrder: '${row.orderIndex}',Column_ideaId: '$ideaPrimaryKey',Column_taskId: uniqueIdForTask});
          });

  
  // Make query to database for the tasks
  Future<DBTaskList> _taskQuery(String tableName,int uniqueId) async =>
     (await _dbInstance.query(tableName,where: '$Column_ideaId = ?',whereArgs: [uniqueId])).map(_convertToTask).toList();
  
}