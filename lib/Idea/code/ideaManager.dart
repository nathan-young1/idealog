import 'package:flutter/material.dart';
import 'package:idealog/Databases/analytics-db/analyticsSql.dart';
import 'package:idealog/Databases/idealog-db/idealog_Db.dart';
import 'package:idealog/Prefs&Data/backupJson.dart';
import 'package:idealog/authentication/authHandler.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/customWidget/alertDialog.dart';
import 'package:idealog/global/routes.dart';
import 'package:idealog/nativeCode/bridge.dart';


class IdeaManager{

  static Future<void> addIdeaToDb({required String ideaTitle,String? moreDetails,required BuildContext context, required List<Task> allNewTasks}) async {

    // ignore: unawaited_futures
    showDialog(context: context, builder: (context) => progressAlertDialog);
    
    // Create a new instance of idea.
    Idea newIdea = Idea(ideaTitle: ideaTitle, moreDetails: moreDetails, tasksToCreate: allNewTasks);

    await IdealogDb.instance.writeIdeaToDb(idea: newIdea);
    Navigator.popUntil(context, ModalRoute.withName(menuPageView));
  }

  static Future<void> changeIdeaDetail({required Idea idea, required String newMoreDetail}) async 
  {
    idea.changeIdeaDetail(newMoreDetail);
    await IdealogDb.instance.changeIdeaDetailInDb(ideaId: idea.ideaId!,newMoreDetail: newMoreDetail);
  }

  static Future<void> setFavorite({required Idea idea}) async 
  {
    // If the idea is favorite, unfavorite it else make it favorite.
    (idea.isFavorite)
    ?idea.unFavorite()
    :idea.makeFavorite();

    await IdealogDb.instance.setFavoriteInDb(idea: idea);
  }

  static Future<void> completeTask(Idea idea,Task uncompletedTask) async 
  {
    idea.completeTask(uncompletedTask);
    await IdealogDb.instance.completeTaskInDb(taskRow: uncompletedTask, ideaPrimaryKey: idea.ideaId!);
    await AnalyticDB.instance.writeOrUpdate(uncompletedTask);
  }

  static Future<void> uncheckCompletedTask(Idea idea,Task completedTask) async 
  {
      idea.uncheckCompletedTask(completedTask);
      await IdealogDb.instance.uncheckCompletedTaskInDb(taskRow: completedTask, ideaPrimaryKey: idea.ideaId!);
      await AnalyticDB.instance.removeTaskFromAnalytics(completedTask);
  }

  static Future<void> addNewTasksToExistingIdea({required Idea idea, required List<Task> newTasks}) async 
  {
    
    List<Task> modifiedTaskList = idea.SetOrderIndex_AddTaskToIdea(tasksList: newTasks); 

    await IdealogDb.instance.addNewTasksToDb(taskList: modifiedTaskList, ideaId: idea.ideaId!);
  }

  static Future<void> deleteTask(Idea idea,Task taskRow) async {
    // I am using delete task because analytics will not throw an error 
    // if you try to delete a non-existent uncompleted task
      idea.deleteTask(taskRow);
      await IdealogDb.instance.deleteTaskFromDb(task: taskRow);
      await AnalyticDB.instance.removeTaskFromAnalytics(taskRow);
  }

  static Future<void> deleteIdeaFromDb(Idea idea) async { 
    await IdealogDb.instance.deleteIdeaFromDb(ideaId: idea.ideaId!);
    // Delete all the completed tasks of this idea from analytics data
    await AnalyticDB.instance.removeIdeaFromAnalytics(idea.completedTasks);
    }

  /// Backup all the ideas to google drive.
  static Future<void> backupIdeasNow() async{
    
    await signInWithGoogle();
    await BackupJson.instance.initialize();
    
    // upload to google drive
    await BackupJson.instance.uploadToDrive();
   
    await NativeCodeCaller.instance.updateLastBackupTime();
    
    debugPrint('show alertDialog');
  }

}