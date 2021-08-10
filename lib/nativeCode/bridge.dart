import 'package:flutter/material.dart';
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
      debugPrint(result);
      
      // Notify the app to get the updated time whether worker is a success or not.
      instance.notifyListeners();
      
    } catch (e,s){
      debugPrint('$e \n\n $s');
    }
  }

  static Future<void> stopAutoSync() async {
    try{
      String result = await platform.invokeMethod(cancelAutoSyncMethod);
      debugPrint(result);
    } catch (e,s){
      debugPrint('$e \n\n $s');
    }
  }

/// Get the last backup time from native shared preference.
  Future<String> get getLastBackupTime async {
    String result = '';
    try{
      result = await platform.invokeMethod(getLastBackupTimeMethod);
    } catch (e,s){
      debugPrint('$e \n\n $s');
    }

    return result;
  }


  /// Write last backup time to native shared preference.
   Future<String> updateLastBackupTime() async {
    String result = '';

    try{
      result = await platform.invokeMethod(updateLastBackupTimeMethod);
    } catch (e,s){
      debugPrint('$e \n\n $s');
    }

    notifyListeners();
    return result;
  }

  /// Set the expirationDate of the current subscription plan, this is done in the native code.
  Future<String> setPremiumExpirationDate({required int premiumExpirationDateInMillis}) async {
    String result = '';
    try{
      /// The key i used for the object being passed to the native code is the same as the method name.
      /// I am passing the milliseconds as string to the native code because it is expecting a string.
      result = await platform.invokeMethod(setPremiumExpireDateMethod, {setPremiumExpireDateMethod : premiumExpirationDateInMillis.toString()});
    } catch(e, s) {
      debugPrint('$e \n\n $s');
    }
    debugPrint('The result gotten from native code by setting the expire date $result');
    notifyListeners();
    return result;
  }

  /// Check if the user is a premium user, this is done by the native code.
  Future<bool> getUserIsPremium() async {
    bool result = false;
    try{
      result = await platform.invokeMethod(getUserIsPremiumMethod);
    } catch(e,s) {
      debugPrint('$e \n\n $s');
    }
    debugPrint('The result for status gotten by native code caller $result');
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