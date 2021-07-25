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

  late Database dbInstance;

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
      int uniqueIdForIdea = await getUniqueId(txn,ideaTable);
      await txn.insert(ideaTable, {
        Column_ideaTitle: idea.ideaTitle,
        Column_moreDetails: idea.moreDetails??'',
        Column_ideaId: uniqueIdForIdea,
        Column_favorite: idea.isFavorite.toString()
        });

      await _putTasksInTheirCorrespondingTable(txn: txn, uncompletedTasks: uncompletedTasks, completedTasks: completedTasks, ideaPrimaryKey: uniqueIdForIdea);

      });
  }

  Future<void> deleteIdea({required int ideaId}) async {

    await dbInstance.transactionAndTrigger((txn) async { 
      var batch = txn.batch();
      Function delete = (String tableName) => batch.delete(tableName,where: '$Column_ideaId = ?',whereArgs: [ideaId]);

      delete(ideaTable);
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

  Future<void> addNewTasks({required DBTaskList taskList, required int ideaId}) async {
    await dbInstance.transaction((txn) async =>
      await _addTasksToTable(txn: txn, tasks: taskList, tableName: uncompletedTable, ideaPrimaryKey: ideaId)
    );
  }

  Future<void> completeTask({required Task taskRow, required int ideaPrimaryKey, required int lastCompletedOrderIndex}) async {
        
      await dbInstance.transaction((txn) async { 
      var batch = txn.batch();
      // get id that does not exist in completed table then use it for this task you are adding to the table
      int uniqueIdForTask = await getUniqueId(txn,completedTable);

      batch.delete(uncompletedTable,where: '$Column_taskId = ?',whereArgs: [taskRow.primaryKey]);
      // Add one to the last Order index before adding it to the completed table
      batch.insert(completedTable, {Column_ideaId: '$ideaPrimaryKey',Column_task: '${taskRow.task}',Column_taskOrder: '${++lastCompletedOrderIndex}',Column_taskId: uniqueIdForTask});

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
      batch.insert(uncompletedTable, {Column_ideaId: '$ideaPrimaryKey',Column_task: '${taskRow.task}',Column_taskOrder: '${++lastUncompletedOrderIndex}',Column_taskId: uniqueIdForTask});

      await batch.commit(noResult: true);
    });

  }

  Future<void> changeMoreDetail({required int ideaId, required String newMoreDetail}) async {
      await dbInstance.transaction((txn) async {
        await txn.update(ideaTable,
          {Column_moreDetails : newMoreDetail},
          where: '$Column_ideaId = ?',
          whereArgs: [ideaId]);
      });
  }

  /// Watch the idea's table for updates. 
  Stream<List<Idea>> get readFromDb async* {

      // await for every new event in the stream then yield the current dbstate
      await for (var _ in _updateStream){
       yield await _dbIdeasGetter();
      }  
  }

  Future<List<Map<String, dynamic>>> get allIdeasForJson async => (await _dbIdeasGetter())
  .map((e) => e.toMap())
  .toList();

  /// The function that actually reads the Database for ideas.
  Future<List<Idea>> _dbIdeasGetter() async {
    List<Idea> allIdeasFromDb = [];
      await dbInstance.transaction((txn) async {
        await _createTablesIfNotExist(txn);

        var allIdeasFromQuery = await txn.query(ideaTable);
      
        for(var idea in allIdeasFromQuery){
          int ideaId = int.parse(idea[Column_ideaId].toString());

          Map<String, DBTaskList> tasks = await getTasksForIdea(ideaId: ideaId, txn: txn);

          // Idea test = Idea.readFromDb(
          //  ideaTitle: idea[Column_ideaTitle].toString(),
          //  completedTasks: tasks[completedTable]!,
          //  ideaId: ideaId,
          //  uncompletedTasks: tasks[uncompletedTable]!,
          //  moreDetails: idea[Column_moreDetails].toString()
          //  );

          Idea test = Idea.test()
              ..ideaTitle = idea[Column_ideaTitle].toString()
              ..completedTasks = tasks[completedTable]!
              ..ideaId = ideaId
              ..uncompletedTasks = tasks[uncompletedTable]!
              ..moreDetails = idea[Column_moreDetails].toString()
              ..isFavorite = (idea[Column_favorite].toString() == 'true') ? true : false;
          
          allIdeasFromDb.add(test);
        }
      });

      return allIdeasFromDb;
  }


  /// Drop all tables in the database
  Future<void> dropAllTablesInDb() async {
    await dbInstance.execute('Drop Table $ideaTable');
    await dbInstance.execute('Drop Table $completedTable');
    await dbInstance.execute('Drop Table $uncompletedTable');
    notifyListeners();
  }

  
  /// Get the last primary key in the table ,then increment it by one for a new unique key.
  Future<int> getUniqueId(Transaction txn,String tableName) async {
    String idColumn = (tableName == ideaTable)?Column_ideaId:Column_taskId;

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
  Future<void> _putTasksInTheirCorrespondingTable({required Transaction txn,required DBTaskList uncompletedTasks,required DBTaskList completedTasks,required int ideaPrimaryKey}) async {
        await _addTasksToTable(txn: txn,tasks: completedTasks,tableName: completedTable,ideaPrimaryKey: ideaPrimaryKey);
        await _addTasksToTable(txn: txn,tasks: uncompletedTasks,tableName: uncompletedTable,ideaPrimaryKey: ideaPrimaryKey);
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
      var task = e[Column_task]!.toString();
      var orderIndex = e[Column_taskOrder] as int;
      var primaryKey = e[Column_taskId] as int;
      var priority = e[Column_taskPriority] as int;
      // return Task(task: task, orderIndex: orderIndex,primaryKey: primaryKey);
      return Task.test()
                  ..task = task
                  ..orderIndex = orderIndex
                  ..primaryKey = primaryKey
                  ..priority = priority;
  }

  /// Add tasks to the specified table.
  Future<void> _addTasksToTable({required Transaction txn,required DBTaskList tasks,required String tableName,required int ideaPrimaryKey}) async {
        for(var row in tasks){
          int uniqueIdForTask = await getUniqueId(txn,tableName);
          await txn.insert(tableName, {
            Column_task: '${row.task}',
            Column_taskOrder: '${row.orderIndex}',
            Column_ideaId: '$ideaPrimaryKey',
            Column_taskId: uniqueIdForTask,
            Column_taskPriority: '${row.priority}'
            });
        }
  }

  /// Make query to the specified table for tasks
  Future<DBTaskList> _taskQuery(String tableName,int ideaId,Transaction txn) async =>
     (await txn.query(tableName,where: '$Column_ideaId = ?',whereArgs: [ideaId])).map(_convertToTask).toList();
  
}