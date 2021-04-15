import 'package:flutter/services.dart';
import 'package:idealog/global/enums.dart';
import 'package:idealog/global/strings.dart';
import 'package:idealog/nativeCode/methodNames.dart';

const platform = const MethodChannel(javaToFlutterMethodChannelName);

class NativeCodeCaller{
  static Future<void> createNewAlarm({required NotificationType typeOfNotification,required int? uniqueAlarmId}) async{
    //remember to change configuaration to int in native java code
    Map<String,dynamic> alarmConfiguration = {
      'typeOfNotification': (typeOfNotification == NotificationType.IDEAS)?1:2,
      'uniqueAlarmId': uniqueAlarmId!
    };

    try{
      String result = await platform.invokeMethod(setAlarmMethod,alarmConfiguration);
      print(result);
    }catch(e){
      print(e);
    }
  }

  static Future<void> cancelAlarm({required int? uniqueAlarmId}) async {
    Map<String,dynamic> alarmConfiguration = {'uniqueAlarmId': uniqueAlarmId!};
    try{
      String result = await platform.invokeMethod(cancelAlarmMethod,alarmConfiguration);
      print(result);
    }catch(e){
      print(e);
    }
  }

  static Future<void> startAutoSync() async {
    try{
      String result = await platform.invokeMethod(startAutoSyncMethod);
      print(result);
    }catch(e){
      print(e);
    }
  }

  static Future<void> stopAutoSync() async {
    try{
      String result = await platform.invokeMethod(cancelAutoSyncMethod);
      print(result);
    }catch(e){
      print(e);
    }
  }
}