import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:idealog/settings/code/PremiumClass.dart';
import 'Databases/analytics-db/analyticsSql.dart';
import 'Databases/idealog-db/idealog_Db.dart';
import 'Prefs&Data/prefs.dart';
import 'nativeCode/bridge.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

// ignore: non_constant_identifier_names
Future<void> InitializeAppConfig() async {
  InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  await IdealogDb.instance.initialize();

  await Future.wait([ 
      Prefrences.instance.initialize(), 
      Firebase.initializeApp(),
      NativeCodeCaller.instance.initialize(),
      ]);

  debugPrint("Subscription status before plugin intialization ${await NativeCodeCaller.instance.getUserIsPremium()}");
  // Make sure to initialize this plugin only when there is network connectivity.
  await Premium.instance.initializePlugin();
  debugPrint("Subscription status after plugin intialization ${await NativeCodeCaller.instance.getUserIsPremium()}");
  await AnalyticDB.instance.clearObsoluteData();


  // await IdealogDb.instance.dropAllTablesInDb();

  // await BackupJson.instance.initialize();
  // await BackupJson.instance.deleteFile();
  // await BackupJson.instance.downloadFromDrive();
  
}


