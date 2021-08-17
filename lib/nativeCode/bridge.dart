import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idealog/global/top_level_methods.dart';
import 'package:idealog/nativeCode/methodNames.dart';

const platform = MethodChannel(javaToFlutterMethodChannelName);

class NativeCodeCaller with ChangeNotifier{

  NativeCodeCaller._();
  static NativeCodeCaller instance = NativeCodeCaller._();

  String? lastBackupTime;

  /// Start auto sync in native code by enqueuing a periodic work to work manager.
  Future<void> startAutoSync() async {
    try{
      String result = await platform.invokeMethod(startAutoSyncMethod);
      debugPrint("result from auto sync: " + result);
      
      // Notify the app that work has been enqueued then wait 10 seconds before notifyListeners so that if work was a success the new time can be seen without leaving and reentering the page.
      Future.delayed(Duration(seconds: 10), ()=> notifyListeners());
      
    } catch (e,s){
      debugPrint('$e \n\n $s');
    }
  }

  /// Stop the work manager from executing the auto sync periodic work.
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
    
    notifyListeners();
    return result;
  }

  /// Ask the native code to return the expiration date of the premium plan subscription stored in the shared pref , if there is any.
  Future<DateTime?> getPremiumExpirationDate() async {
    int result = 0;
    try{

      result = await platform.invokeMethod(getPremiumExpireDateMethod);
    } catch(e, s) {
      debugPrint('$e \n\n $s');
    }

    // if the expire date in milliseconds is 0 return null;
    if (result == 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(result);
  }

  /// Calls the convertDateTimeObjToAFormattedString() method on the expiration date gotten from the native code to a string.
  Future<String> getPremiumExpirationDateAsFormattedString() async {
    final DateTime? premiumPlanExpireDate = await getPremiumExpirationDate();
    /// if the dateTime obj is null then return a empty string ("");
    if (premiumPlanExpireDate == null) return "";
    return convertDateTimeObjToAFormattedString(premiumPlanExpireDate);
  }

  /// Check if the user is a premium user, this is done by the native code.
  Future<bool> getUserIsPremium() async {
    bool result = false;
    try{
      result = await platform.invokeMethod(getUserIsPremiumMethod);
    } catch(e,s) {
      debugPrint('$e \n\n $s');
    }

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