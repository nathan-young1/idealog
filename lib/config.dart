import 'package:auto_start_flutter/auto_start_flutter.dart' as autoStart;
import 'package:firebase_core/firebase_core.dart';
import 'package:idealog/settings/code/PremiumClass.dart';
import 'Databases/analytics-db/analyticsSql.dart';
import 'Databases/idealog-db/idealog_Db.dart';
import 'Prefs&Data/prefs.dart';
import 'global/internetConnectionChecker.dart';
import 'nativeCode/bridge.dart';

// ignore: non_constant_identifier_names
Future<void> InitializeAppConfig() async {
  // bool autoStartEnabled = await autoStart.isAutoStartAvailable;
  
  // debugPrint("auto start availablilty $autoStartEnabled");
  // if(autoStartEnabled)
  // autoStart.getAutoStartPermission();
  
  await UserInternetConnectionChecker.intialize();
  await IdealogDb.instance.initialize();
  // we will later intialize with internet when the user wants to buy a product.
  await Premium.instance.intializePluginWithoutInternetConnection();

  await Future.wait([ 
      Prefrences.instance.initialize(), 
      Firebase.initializeApp(),
      NativeCodeCaller.instance.initialize(),
      AnalyticDB.instance.clearObsoluteData()
      ]);
  
}


