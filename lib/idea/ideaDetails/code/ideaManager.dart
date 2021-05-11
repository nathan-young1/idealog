import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idealog/analytics/analyticsSql.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/customWidget/alertDialog.dart';
import 'package:idealog/global/routes.dart';
import 'package:idealog/sqlite-db/sqlite.dart';

class IdeaManager{

    static addToDbAndSetAlarmIdea({required String ideaTitle,String? moreDetails,required Set<String> tasks,required BuildContext context}) async {
      showDialog(context: context, builder: (context) => progressAlertDialog);
      
      List<List<int>> tasksInCharCodes = tasks.map((task) => task.codeUnits).toList();
      int uniqueId = await Sqlite.getUniqueId();
      Idea newIdea = Idea(ideaTitle: ideaTitle,moreDetails: moreDetails,tasksToCreate: tasksInCharCodes,uniqueId: uniqueId);
      try {
        await Sqlite.writeToDb(idea: newIdea);
      } on Exception catch (e) {
        print(e);
      }
      Navigator.popAndPushNamed(context, menuPageView);
    }

    static completeTask(Idea idea,List<int> uncompletedTask) async {

        idea.completeTask(uncompletedTask);
        await Sqlite.updateDb(idea.uniqueId, idea: idea);
        await AnalyticsSql.writeOrUpdate(uncompletedTask);
    }

  static uncheckCompletedTask(Idea idea,List<int> completedTask) async {
    
      idea.uncheckCompletedTask(completedTask);
      await Sqlite.updateDb(idea.uniqueId, idea: idea);
      await AnalyticsSql.removeTaskFromAnalytics(completedTask);
  }

  static deleteUncompletedTask(Idea idea,List<int> uncompletedTask) async {
    // We are not removing it from analytics data because it is an uncompleted task so it has not been recorded in analytics sql
      idea.deleteTask(uncompletedTask);
      await Sqlite.updateDb(idea.uniqueId, idea: idea);
  }

  static deleteCompletedTask(Idea idea,List<int> completedTask) async {
      idea.deleteTask(completedTask);
      await Sqlite.updateDb(idea.uniqueId, idea: idea);
      await AnalyticsSql.removeTaskFromAnalytics(completedTask);
  }

  static deleteIdeaFromDb(Idea idea) async { 
    await Sqlite.deleteFromDB(uniqueId: '${idea.uniqueId}');
    // Delete all the completed tasks of this idea from analytics data
    idea.completedTasks.forEach((completedTask) async => await AnalyticsSql.removeTaskFromAnalytics(completedTask));
    }
}