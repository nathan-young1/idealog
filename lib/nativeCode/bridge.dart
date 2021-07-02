import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:idealog/global/strings.dart';
import 'package:idealog/nativeCode/methodNames.dart';

const platform = MethodChannel(javaToFlutterMethodChannelName);

class NativeCodeCaller with ChangeNotifier{

  NativeCodeCaller._();
  static NativeCodeCaller instance = NativeCodeCaller._();

  String? lastBackupTime;

  static Future<void> startAutoSync() async {
    try{
      String result = await platform.invokeMethod(startAutoSyncMethod);
      print(result);

    } catch (e,s){
      print('$e \n\n $s');
    }
  }

  static Future<void> stopAutoSync() async {
    try{
      String result = await platform.invokeMethod(cancelAutoSyncMethod);
      print(result);
    } catch (e,s){
      print('$e \n\n $s');
    }
  }

/// Get the last backup time from native shared preference.
  Future<String> get getLastBackupTime async {
    String result = '';
    try{
      result = await platform.invokeMethod(getLastBackupTimeMethod);
    } catch (e,s){
      print('$e \n\n $s');
    }

    return result;
  }


/// Write last backup time to native shared preference.
   Future<String> updateLastBackupTime() async {
    String result = '';

    try{
      result = await platform.invokeMethod(updateLastBackupTimeMethod);
    } catch (e,s){
      print('$e \n\n $s');
    }

    notifyListeners();
    return result;
  }

  @override
  Future<void> notifyListeners() async {
    lastBackupTime = await getLastBackupTime;
    super.notifyListeners();
  }

  Future<void> initialize() async =>
    lastBackupTime = await getLastBackupTime;

}