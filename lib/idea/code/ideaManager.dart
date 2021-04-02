import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/customWidget/alertDialog.dart';
import 'package:idealog/global/enums.dart';
import 'package:idealog/global/routes.dart';
import 'package:idealog/sqlite-db/sqlite.dart';

addToDbAndSetAlarmIdea({required String ideaTitle,String? moreDetails,List<String>? tasks,required BuildContext context}) async {
  showDialog(context: context, builder: (context) => progressAlertDialot);
  List<List<int>> tasksInCharCodes = tasks!.map((task) => task.codeUnits).toList();
  int uniqueId = await Sqlite.getUniqueId(type: NotificationType.IDEAS);
  Idea newIdea = Idea(ideaTitle: ideaTitle,moreDetails: moreDetails,tasksToCreate: tasksInCharCodes,uniqueId: uniqueId);
  try {
    await Sqlite.writeToDb(notificationType: NotificationType.IDEAS,idea: newIdea);
  } on Exception catch (e) {
    print(e);
  }
  Navigator.popAndPushNamed(context, menuPageView);
}

Future<List<Idea>> getListOfIdeas() async {
List<Idea> _ideasList = await Sqlite.readFromDb(type: NotificationType.IDEAS);
return _ideasList;
}