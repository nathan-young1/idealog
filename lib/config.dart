import 'package:firebase_core/firebase_core.dart';
import 'package:workmanager/workmanager.dart';
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
  await BackupJson.instance.deleteFile();
  

            //   Workmanager().initialize(kk,isInDebugMode: true);
            // Workmanager().registerPeriodicTask(
            //   "uniqueName",
            //   "PeriodicTask",
            //   tag: "autoSync",
            //   frequency: Duration(minutes: 16),
            //   constraints: Constraints(networkType: NetworkType.connected),
            //   backoffPolicy: BackoffPolicy.linear,
            //   backoffPolicyDelay: Duration(minutes: 10),
            //   existingWorkPolicy: ExistingWorkPolicy.replace
            //   );
            
            // Workmanager().cancelByTag("autoSync");
}


void syncData(){
  Workmanager().executeTask((task, inputData) async {
    
    print('called workmanager');
    await IdealogDb.instance.initialize();
      await Future.wait([ 
      Prefrences.instance.initialize(), 
      Firebase.initializeApp(),
      NativeCodeCaller.instance.initialize(),
      ]);

    
    await signInWithGoogle();
    await AnalyticDB.instance.clearObsoluteData();
    await BackupJson.instance.initialize();

    await BackupJson.instance.uploadToDrive();
    return Future.value(true);
  });
}

