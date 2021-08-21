import 'package:firebase_core/firebase_core.dart';
import 'package:idealog/settings/code/PremiumClass.dart';
import 'Databases/analytics-db/analyticsSql.dart';
import 'Databases/idealog-db/idealog_Db.dart';
import 'Prefs&Data/applicationInfo.dart';
import 'Prefs&Data/prefs.dart';
import 'global/internetConnectionChecker.dart';
import 'nativeCode/bridge.dart';

// ignore: non_constant_identifier_names
Future<void> InitializeAppConfig() async {
  
  await ApplicationInfo.initialize();
  await UserInternetConnectionChecker.initialize();
  await IdealogDb.instance.initialize(); 
  // we will later intialize with internet when the user wants to buy a product.
  await Premium.instance.initializePluginWithoutInternetConnection();

  await Future.wait([ 
      Prefrences.instance.initialize(), 
      Firebase.initializeApp(),
      NativeCodeCaller.instance.initialize(),
      AnalyticDB.instance.clearObsoluteData()
      ]);
  
}


