import 'dart:math';
import 'package:flutter/material.dart';
import 'package:idealog/Databases/analytics-db/analyticsSql.dart';
import 'package:idealog/Databases/idealog-db/idealog_Db.dart';
import 'package:idealog/Prefs&Data/backupJson.dart';
import 'package:idealog/auth/code/authHandler.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/customWidget/alertDialog.dart';
import 'package:idealog/global/routes.dart';
import 'package:idealog/nativeCode/bridge.dart';


class IdeaManager{

  static Future<void> addIdeaToDb({required String ideaTitle,String? moreDetails,required Set<String> tasks,required BuildContext context}) async {

    // ignore: unawaited_futures
    showDialog(context: context, builder: (context) => progressAlertDialog);
    
    var newIdea = Idea(ideaTitle: ideaTitle,moreDetails: moreDetails,tasksToCreate: tasks.toList());

    await IdealogDb.instance.writeToDb(idea: newIdea);
    Navigator.popUntil(context, ModalRoute.withName(menuPageView));
  }

  static Future<void> changeMoreDetail({required Idea idea, required String newMoreDetail}) async {
    idea.changeMoreDetail(newMoreDetail);
    await IdealogDb.instance.changeMoreDetail(ideaId: idea.ideaId!,newMoreDetail: newMoreDetail);
  }

  static Future<void> completeTask(Idea idea,Task uncompletedTask,List<Task> allcompletedTasks) async {
    // Get the last completed task order index which is the maximum order index
    int lastCompletedOrderIndex = allcompletedTasks.map((e) => e.orderIndex).fold(0, (previousValue, currentValue) => max(previousValue, currentValue));
      
    idea.completeTask(uncompletedTask);
    await IdealogDb.instance.completeTask(taskRow: uncompletedTask, ideaPrimaryKey: idea.ideaId!, lastCompletedOrderIndex: lastCompletedOrderIndex);
    await AnalyticDB.instance.writeOrUpdate(uncompletedTask);
  }

  static Future<void> uncheckCompletedTask(Idea idea,Task completedTask,List<Task> allUncompletedTasks) async {
    // Get the last Uncompleted task order index which is the maximum order index
    int lastUncompletedOrderIndex = allUncompletedTasks.map((e) => e.orderIndex).fold(0, (previousValue, currentValue) => max(previousValue, currentValue));
    
      idea.uncheckCompletedTask(completedTask);
      await IdealogDb.instance.uncheckCompletedTask(taskRow: completedTask, ideaPrimaryKey: idea.ideaId!, lastUncompletedOrderIndex: lastUncompletedOrderIndex);
      await AnalyticDB.instance.removeTaskFromAnalytics(completedTask);
  }

  static Future<void> deleteTask(Idea idea,Task taskRow) async {
    // I am using delete task because analytics will not throw an error 
    // if you try to delete a non-existent uncompleted task
      idea.deleteTask(taskRow);
      await IdealogDb.instance.deleteTask(task: taskRow);
      await AnalyticDB.instance.removeTaskFromAnalytics(taskRow);
  }

  static multiDelete(Idea idea,List<Task> selectedTasks) => 
          selectedTasks.forEach((task) => deleteTask(idea, task));

  static Future<void> deleteIdeaFromDb(Idea idea) async { 
    await IdealogDb.instance.deleteIdea(ideaId: idea.ideaId!);
    // Delete all the completed tasks of this idea from analytics data
    idea.completedTasks.forEach((completedTask) async => await AnalyticDB.instance.removeTaskFromAnalytics(completedTask));
    }


  static Future<void> backupIdeasNow() async{
    
    await signInWithGoogle();
    
    // upload to google drive
    await BackupJson.instance.uploadToDrive();
   
    await NativeCodeCaller.instance.updateLastBackupTime();
    
    print('sync now clicked');
  }

}