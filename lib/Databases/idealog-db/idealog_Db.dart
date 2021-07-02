import 'dart:async';
import 'package:idealog/global/extension.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:idealog/global/typedef.dart';
import 'idealog_config.dart';

class IdealogDb {

  IdealogDb._();

  static final instance = new IdealogDb._();
  static final StreamController<String?> _controller = StreamController();
  static final Stream _updateStream = _controller.stream.asBroadcastStream();

  late final Database dbInstance;

  Future<void> close() async {
    await _controller.close();
    await dbInstance.close();
  }

  Future<void> initialize() async { 
    dbInstance = await openDatabase('idealog.sqlite',version: 1);
    notifyListeners();
  }

  
  static Function notifyListeners = ()=> _controller.add(null);

  Future<void> writeToDb({required Idea idea}) async {

    await dbInstance.transactionAndTrigger((txn) async {

      _createTablesIfNotExist(txn);

      List<Task> completedTasks = idea.completedTasks;
      List<Task> uncompletedTasks = idea.uncompletedTasks;

      // Insert the idea into the database
      int uniqueIdForIdea = await getUniqueId(txn,ideasTable);
      await txn.insert(ideasTable, {Column_ideaTitle: idea.ideaTitle,Column_moreDetails: idea.moreDetails??'',Column_ideaId: uniqueIdForIdea});
      _putTasksInTheirCorrespondingTable(txn: txn, uncompletedTasks: uncompletedTasks, completedTasks: completedTasks, ideaPrimaryKey: uniqueIdForIdea);
      });
  }

  Future<void> deleteIdea({required int ideaId}) async {

    await dbInstance.transactionAndTrigger((txn) async { 
      var batch = txn.batch();
      Function delete = (String tableName) => batch.delete(tableName,where: '$Column_ideaId = ?',whereArgs: [ideaId]);

      delete(ideasTable);
      delete(completedTable);
      delete(uncompletedTable);

      await batch.commit(noResult: true);
      });
  }

  Future<void> deleteTask({required Task task}) async {

    await dbInstance.transaction((txn) async { 
      var batch = txn.batch();
      String deleteSql = '$Column_taskId = ?';
      // I am deleting from the two tables because if the task does not exist in a table it won't cause any error
      batch.delete(completedTable,where: deleteSql,whereArgs: [task.primaryKey!]);
      batch.delete(uncompletedTable,where: deleteSql,whereArgs: [task.primaryKey!]);

      await batch.commit(noResult: true);
      });
  }

  Future<void> addTask({required Task taskRow, required int ideaId, required int lastUncompletedRowIndex}) async {

    await dbInstance.transaction((txn) async { 
      int uniqueIdForTask = await getUniqueId(txn,uncompletedTable);
      await txn.insert(uncompletedTable, {Column_ideaId: '$ideaId',Column_tasks: '${taskRow.task}',Column_taskOrder: '$lastUncompletedRowIndex',Column_taskId: '$uniqueIdForTask'});
      });
  }

  Future<void> completeTask({required Task taskRow, required int ideaPrimaryKey, required int lastCompletedOrderIndex}) async {
        
      await dbInstance.transaction((txn) async { 
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
    
    await dbInstance.transaction((txn) async { 
      var batch = txn.batch();
      // get id that does not exist in uncompleted table then use it for this task you are adding to the table
      int uniqueIdForTask = await getUniqueId(txn,uncompletedTable);
      batch.delete(completedTable,where: '$Column_taskId = ?',whereArgs: [taskRow.primaryKey]);
      // Add one to the last Order index before adding it to the uncompleted table
      batch.insert(uncompletedTable, {Column_ideaId: '$ideaPrimaryKey',Column_tasks: '${taskRow.task}',Column_taskOrder: '${++lastUncompletedOrderIndex}',Column_taskId: uniqueIdForTask});

      await batch.commit(noResult: true);
    });

  }

  Future<void> changeMoreDetail({required int ideaId, required String newMoreDetail}) async {
      await dbInstance.transaction((txn) async {
        await txn.update(ideasTable,
          {Column_moreDetails : newMoreDetail},
          where: '$Column_ideaId = ?',
          whereArgs: [ideaId]);
      });
  }

  /// Watch the idea's table for updates. 
  Stream<List<Idea>> get readFromDb async* {

      // await for every new event in the stream then yield the current dbstate
      await for (var _ in _updateStream){
        List<Idea> allIdeasFromDb = [];
      await dbInstance.transaction((txn) async {
        await _createTablesIfNotExist(txn);

        var allIdeasFromQuery = await txn.query(ideasTable);
      
        for(var idea in allIdeasFromQuery){
          int ideaId = int.parse(idea[Column_ideaId].toString());

          Map<String, DBTaskList> tasks = await getTasksForIdea(ideaId: ideaId, txn: txn);

          Idea test = Idea.readFromDb(
           ideaTitle: idea[Column_ideaTitle].toString(),
           completedTasks: tasks[completedTable]!,
           ideaId: ideaId,
           uncompletedTasks: tasks[uncompletedTable]!,
           moreDetails: idea[Column_moreDetails].toString()
           );
          
          allIdeasFromDb.add(test);
        }
      });
      
      yield allIdeasFromDb;
      }  
  }

  /// Drop all tables in the database
  Future<void> dropAllTablesInDb() async {
    await dbInstance.execute('Drop Table $ideasTable');
    await dbInstance.execute('Drop Table $completedTable');
    await dbInstance.execute('Drop Table $uncompletedTable');
    notifyListeners();
  }

  
  /// Get the last primary key in the table ,then increment it by one for a new unique key.
  Future<int> getUniqueId(Transaction txn,String tableName) async {
    String idColumn = (tableName == ideasTable)?Column_ideaId:Column_taskId;

    var queryResult = await txn.query(tableName,orderBy: '$idColumn DESC LIMIT 1',columns: [idColumn]);

    List<int> keysInDb = queryResult.map((e) => e[idColumn] as int).toList();

    int newKey = (keysInDb.isEmpty)?0:++keysInDb.last;

    return newKey;
  }


// =====================================================Private class methods==================================================== //

  /// Creates the following tables [Ideas,CompletedTable,UncompletedTable] if they don't already exist.
  Future<void> _createTablesIfNotExist(Transaction txn) async {    
    await txn.execute(createIdeasTableSqlCommand);
    await txn.execute(createCompletedTableSqlCommand);
    await txn.execute(createUncompletedTableSqlCommand);
  }

  /// Calls the method _addTasksToTable for both completed and uncompleted tasks.
  void _putTasksInTheirCorrespondingTable({required Transaction txn,required DBTaskList uncompletedTasks,required DBTaskList completedTasks,required int ideaPrimaryKey}){
        _addTasksToTable(txn: txn,tasks: completedTasks,tableName: completedTable,ideaPrimaryKey: ideaPrimaryKey);
        _addTasksToTable(txn: txn,tasks: uncompletedTasks,tableName: uncompletedTable,ideaPrimaryKey: ideaPrimaryKey);
  }

  /// Get the tasks from their corresponding table using the idea's Id
  Future<Map<String, DBTaskList>> getTasksForIdea({required int ideaId,required Transaction txn}) async {

    List<Task> completedTasks = await _taskQuery(completedTable, ideaId, txn);
    List<Task> uncompletedTasks = await _taskQuery(uncompletedTable, ideaId, txn);
    
    return {uncompletedTable: uncompletedTasks,completedTable: completedTasks};
  }


// ==============================================================Functions for methods============================================== //

  /// Convert the Db query result to a Task object
  Task _convertToTask(Map<String, Object?> e){
      var task = e[Column_tasks]!.toString();
      var orderIndex = e[Column_taskOrder] as int;
      var primaryKey = e[Column_taskId] as int;
      return Task(task: task, orderIndex: orderIndex,primaryKey: primaryKey);
  }

  /// Add tasks to the specified table.
  void _addTasksToTable({required Transaction txn,required DBTaskList tasks,required String tableName,required int ideaPrimaryKey}) =>
        tasks.forEach((row) async {
          int uniqueIdForTask = await getUniqueId(txn,tableName);
          await txn.insert(tableName, {Column_tasks: '${row.task}',Column_taskOrder: '${row.orderIndex}',Column_ideaId: '$ideaPrimaryKey',Column_taskId: uniqueIdForTask});
          });

  
  /// Make query to the specified table for tasks
  Future<DBTaskList> _taskQuery(String tableName,int ideaId,Transaction txn) async =>
     (await txn.query(tableName,where: '$Column_ideaId = ?',whereArgs: [ideaId])).map(_convertToTask).toList();
  
}