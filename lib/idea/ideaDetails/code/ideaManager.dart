import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:idealog/Databases/analytics-db/analyticsSql.dart';
import 'package:idealog/Databases/idealog-db/idealog_Db_Moor.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/customWidget/alertDialog.dart';
import 'package:idealog/global/routes.dart';

class IdeaManager{

    static addToDbAndSetAlarmIdea({required String ideaTitle,String? moreDetails,required Set<String> tasks,required BuildContext context}) async {
      // ignore: unawaited_futures
      showDialog(context: context, builder: (context) => progressAlertDialog);
      
      var tasksInCharCodes = tasks.map((task) => task.codeUnits).toList();
      var newIdea = IdeaModel(ideaTitle: ideaTitle,moreDetails: moreDetails,tasksToCreate: tasksInCharCodes);
      IdealogDb.instance.insertToDb(newEntry: newIdea);
      Navigator.popAndPushNamed(context, menuPageView);
    }

    static completeTask(IdeaModel idea,List<int> uncompletedTask) async {

        idea.completeTask(uncompletedTask);
        IdealogDb.instance.updateDb(updatedEntry: idea);
        await AnalyticDB.instance.writeOrUpdate(uncompletedTask);
    }

  static uncheckCompletedTask(IdeaModel idea,List<int> completedTask) async {
    
      idea.uncheckCompletedTask(completedTask);
      IdealogDb.instance.updateDb(updatedEntry: idea);
      await AnalyticDB.instance.removeTaskFromAnalytics(completedTask);
  }

  static deleteUncompletedTask(IdeaModel idea,List<int> uncompletedTask) async {
    // We are not removing it from analytics data because it is an uncompleted task so it has not been recorded in analytics sql
      idea.deleteTask(uncompletedTask);
      IdealogDb.instance.updateDb(updatedEntry: idea);
  }

  static deleteCompletedTask(IdeaModel idea,List<int> completedTask) async {
      idea.deleteTask(completedTask);
      IdealogDb.instance.updateDb(updatedEntry: idea);
      await AnalyticDB.instance.removeTaskFromAnalytics(completedTask);
  }

  static deleteIdeaFromDb(IdeaModel idea) async { 
      IdealogDb.instance.deleteFromDb(uniqueId: idea.uniqueId!);
    // Delete all the completed tasks of this idea from analytics data
    idea.completedTasks.forEach((completedTask) async => await AnalyticDB.instance.removeTaskFromAnalytics(completedTask));
    }

  static Future<void> syncIdeasNow(List<IdeaModel> allIdeas) async{
    // call the deleting cloud function
    FirebaseFirestore cloudDb = FirebaseFirestore.instance;
    var userUid = GoogleUserData.instance.user_uid;
    allIdeas.forEach((idea) async { 
      await cloudDb.collection('$userUid').doc('Database').collection('Ideas').doc(idea.uniqueId.toString()).set(idea.toMap());
    });
    
  }
}