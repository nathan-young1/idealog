import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/global/enums.dart';
import 'package:idealog/global/extension.dart';
import 'package:idealog/nativeCode/bridge.dart';
import 'package:idealog/sqlite-db/sqlite.dart';

addToDbAndSetAlarmIdea({String? deadlineInString,required String ideaTitle,String? moreDetails,List<String>? tasks}) async {
  int? deadline = deadlineInString!.deadlineStringToMillisecondsSinceEponch;
  List<List<int>> tasksInCharCodes = tasks!.map((task) => task.codeUnits).toList();
  Idea newIdea = Idea(ideaTitle: ideaTitle,moreDetails: moreDetails,deadline: deadline,tasksToCreate: tasksInCharCodes);
  try {
    await Sqlite.writeToDb(notificationType: NotificationType.IDEAS,idea: newIdea);
    await createNewAlarm(alarmText: ideaTitle, typeOfNotification: NotificationType.IDEAS, uniqueAlarmId: newIdea.uniqueId, alarmTime: newIdea.deadline);
  } on Exception catch (e) {
    print(e);
  }
}