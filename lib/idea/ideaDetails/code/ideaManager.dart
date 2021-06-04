import 'package:flutter/material.dart';
import 'package:idealog/Databases/analytics-db/analyticsSql.dart';
import 'package:idealog/Databases/idealog-db/idealog_Db_Moor.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/customWidget/alertDialog.dart';
import 'package:idealog/global/routes.dart';

class IdeaManager{

    static Future<void> addToDbAndSetAlarmIdea({required String ideaTitle,String? moreDetails,required Set<String> tasks,required BuildContext context}) async {
      await showDialog(context: context, builder: (context) => progressAlertDialog);
      
      var tasksInCharCodes = tasks.map((task) => task.codeUnits).toList();
      var newIdea = IdeaModel(ideaTitle: ideaTitle,moreDetails: moreDetails,tasksToCreate: tasksInCharCodes);
      await IdealogDb.instance.insertToDb(newEntry: newIdea);
      await Navigator.popAndPushNamed(context, menuPageView);
    }

    static Future<void> completeTask(IdeaModel idea,List<int> uncompletedTask) async {

        idea.completeTask(uncompletedTask);
        await IdealogDb.instance.updateDb(updatedEntry: idea);
        await AnalyticDB.instance.writeOrUpdate(uncompletedTask);
    }

  static Future<void> uncheckCompletedTask(IdeaModel idea,List<int> completedTask) async {
    
      idea.uncheckCompletedTask(completedTask);
      await IdealogDb.instance.updateDb(updatedEntry: idea);
      await AnalyticDB.instance.removeTaskFromAnalytics(completedTask);
  }

  static Future<void> deleteUncompletedTask(IdeaModel idea,List<int> uncompletedTask) async {
    // We are not removing it from analytics data because it is an uncompleted task so it has not been recorded in analytics sql
      idea.deleteTask(uncompletedTask);
      await IdealogDb.instance.updateDb(updatedEntry: idea);
  }

  static Future<void> deleteCompletedTask(IdeaModel idea,List<int> completedTask) async {
      idea.deleteTask(completedTask);
      await IdealogDb.instance.updateDb(updatedEntry: idea);
      await AnalyticDB.instance.removeTaskFromAnalytics(completedTask);
  }

  static Future<void> deleteIdeaFromDb(IdeaModel idea) async { 
    await IdealogDb.instance.deleteFromDb(uniqueId: idea.uniqueId!);
    // Delete all the completed tasks of this idea from analytics data
    idea.completedTasks.forEach((completedTask) async => await AnalyticDB.instance.removeTaskFromAnalytics(completedTask));
    }
}