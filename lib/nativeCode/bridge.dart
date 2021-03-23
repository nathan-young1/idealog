import 'package:flutter/services.dart';
import 'package:idealog/global/enums.dart';
import 'package:idealog/global/strings.dart';

const platform = const MethodChannel(javaToFlutterMethodChannelName);

  createNewAlarm({required NotificationType typeOfNotification,required int? uniqueAlarmId}) async{
    //remember to change configuaration to int in native java code
    Map<String,dynamic> alarmConfiguration = {
      'typeOfNotification': (typeOfNotification == NotificationType.IDEAS)?1:2,
      'uniqueAlarmId': uniqueAlarmId!
    };

    try{
      String result = await platform.invokeMethod("setAlarm",alarmConfiguration);
      print(result);
    }catch(e){
      print(e);
    }
  }

  cancelAlarm({required int? uniqueAlarmId}) async {
    Map<String,dynamic> alarmConfiguration = {
      'uniqueAlarmId': uniqueAlarmId!
    };
    try{
      String result = await platform.invokeMethod("cancelAlarm",alarmConfiguration);
      print(result);
    }catch(e){
      print(e);
    }
  }