import 'package:flutter/services.dart';
import 'package:idealog/global/strings.dart';
import 'package:idealog/nativeCode/methodNames.dart';

const platform = MethodChannel(javaToFlutterMethodChannelName);

class NativeCodeCaller{

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

  static Future<void> syncNow() async{
    try{
      String result = await platform.invokeMethod(syncNowMethod);
      print(result);
    } catch (e){
      print(e);
    }
  }
}