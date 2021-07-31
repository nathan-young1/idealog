import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:idealog/settings/code/PremiumClass.dart';
import 'Databases/analytics-db/analyticsSql.dart';
import 'Databases/idealog-db/idealog_Db.dart';
import 'Prefs&Data/prefs.dart';
import 'nativeCode/bridge.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

// ignore: non_constant_identifier_names
Future<void> InitializeAppConfig() async {
  // InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  await IdealogDb.instance.initialize();

  await Future.wait([ 
      Prefrences.instance.initialize(), 
      Firebase.initializeApp(),
      NativeCodeCaller.instance.initialize(),
      ]);

  // await Premium.instance.initializePlugin();
  await AnalyticDB.instance.clearObsoluteData();


  // await IdealogDb.instance.dropAllTablesInDb();

  // await BackupJson.instance.initialize();
  // await BackupJson.instance.deleteFile();
  // await BackupJson.instance.downloadFromDrive();
  
}


