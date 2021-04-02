import 'package:idealog/core-models/scheduleModel.dart';
import 'package:idealog/global/enums.dart';
import 'package:idealog/nativeCode/bridge.dart';
import 'package:idealog/sqlite-db/sqlite.dart';

addToDbAndSetAlarmSchedule({required String scheduleDate,required String startTime,required String endTime,required String scheduleDetails,required RepeatSchedule repeatSchedule}) async {
  int uniqueId = await Sqlite.getUniqueId(type: NotificationType.SCHEDULE);
  Schedule newSchedule = Schedule(uniqueId: uniqueId,repeatSchedule: repeatSchedule,scheduleDetails: scheduleDetails,startTime: startTime,endTime: endTime,scheduleDate: scheduleDate);
  try {
    await Sqlite.writeToDb(notificationType: NotificationType.SCHEDULE,schedule: newSchedule);
    await createNewAlarm(typeOfNotification: NotificationType.SCHEDULE, uniqueAlarmId: newSchedule.uniqueId);
  } on Exception catch (e) {
    print(e);
  }
}