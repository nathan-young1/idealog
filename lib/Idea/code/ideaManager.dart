import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:idealog/Databases/analytics-db/analyticsSql.dart';
import 'package:idealog/Databases/idealog-db/idealog_Db_Moor.dart';
import 'package:idealog/Idea/ui/Others/CreateIdea.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/customWidget/alertDialog.dart';
import 'package:idealog/global/routes.dart';
import 'package:provider/provider.dart';

class IdeaManager{

    static addToDbAndSetAlarmIdea({required String ideaTitle,String? moreDetails,required Set<String> tasks,required BuildContext context}) async {
      
      // if this idea title already exists show the already exists flushbar
      if(Provider.of<List<IdeaModel>>(context,listen: false).map((ideaModel) => ideaModel.ideaTitle).contains(ideaTitle)){
        return TitleAlreadyExists(pageContext: context);
      }

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

  static deleteTask(IdeaModel idea,List<int> task) async {
    // I am using delete task because analytics will not throw an error 
    // if you try to delete a non-existent uncompleted task
      idea.deleteTask(task);
      IdealogDb.instance.updateDb(updatedEntry: idea);
      await AnalyticDB.instance.removeTaskFromAnalytics(task);
  }

  static multiDelete(IdeaModel idea,List<List<int>> selectedTasks) => 
          selectedTasks.forEach((task) => deleteTask(idea, task));

  static deleteIdeaFromDb(IdeaModel idea) async { 
      IdealogDb.instance.deleteFromDb(uniqueId: idea.uniqueId!);
    // Delete all the completed tasks of this idea from analytics data
    idea.completedTasks.forEach((completedTask) async => await AnalyticDB.instance.removeTaskFromAnalytics(completedTask));
    }

  static Future<void> syncIdeasNow(List<IdeaModel> allIdeas) async{
    // call the deleting cloud function
    FirebaseFunctions functions = FirebaseFunctions.instance;

    await functions.httpsCallable("deleteFormerData").call().then((value) {
      FirebaseFirestore cloudDb = FirebaseFirestore.instance;
      var userUid = GoogleUserData.instance.user_uid;
      print(userUid);
      allIdeas.forEach((idea) async { 
      await cloudDb.collection('$userUid').doc('Database').collection('Ideas').doc(idea.uniqueId.toString()).set(idea.toMap());
    });
    });
    
  }
}