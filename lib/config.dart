import 'package:firebase_core/firebase_core.dart';
import 'Databases/analytics-db/analyticsSql.dart';
import 'Databases/idealog-db/idealog_Db.dart';
import 'Prefs&Data/backupJson.dart';
import 'Prefs&Data/prefs.dart';
import 'auth/code/authHandler.dart';
import 'nativeCode/bridge.dart';

// ignore: non_constant_identifier_names
Future<void> InitializeAppConfig() async {
  
  await IdealogDb.instance.initialize();

  await Future.wait([ 
      Prefrences.instance.initialize(), 
      Firebase.initializeApp(),
      NativeCodeCaller.instance.initialize(),
      ]);

  
  await signInWithGoogle();
  await AnalyticDB.instance.clearObsoluteData();
  await BackupJson.instance.initialize();
  await BackupJson.instance.listAllFiles();
  // await BackupJson.instance.deleteFile();
  // await BackupJson.instance.uploadToDrive();
  
}


