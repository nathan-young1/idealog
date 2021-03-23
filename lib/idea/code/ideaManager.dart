import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/global/enums.dart';
import 'package:idealog/global/extension.dart';
import 'package:idealog/nativeCode/bridge.dart';
import 'package:idealog/sqlite-db/sqlite.dart';

addToDbAndSetAlarmIdea({String? deadlineInString,required String ideaTitle,String? moreDetails,List<String>? tasks}) async {
  List<List<int>> tasksInCharCodes = tasks!.map((task) => task.codeUnits).toList();
  Idea newIdea = Idea(ideaTitle: ideaTitle,moreDetails: moreDetails,tasksToCreate: tasksInCharCodes);
  try {
    await Sqlite.writeToDb(notificationType: NotificationType.IDEAS,idea: newIdea);
    await createNewAlarm(typeOfNotification: NotificationType.IDEAS, uniqueAlarmId: newIdea.uniqueId);
  } on Exception catch (e) {
    print(e);
  }
}