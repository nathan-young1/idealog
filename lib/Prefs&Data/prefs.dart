import 'package:flutter/cupertino.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:idealog/authentication/authHandler.dart';
import 'package:idealog/customWidget/alertDialog/autoStartDialog.dart';
import 'package:idealog/customWidget/flushbar.dart';
import 'package:idealog/design/theme.dart';
import 'package:idealog/global/paths.dart';
import 'package:idealog/nativeCode/bridge.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_start_flutter/auto_start_flutter.dart' as autoStart;

class Prefrences with ChangeNotifier{

  late SharedPreferences pref;

  static bool? _darkMode;
  static bool? _autoSync;
  static bool? _fingerprintAuth;

  

  Prefrences._();
  static Prefrences instance = Prefrences._();

  Future<void> initialize() async {
    pref = await SharedPreferences.getInstance();
    _darkMode = pref.containsKey('DarkMode')? pref.getBool('DarkMode') : false;
    _autoSync = pref.containsKey('AutoSync')? pref.getBool('AutoSync') : false;
    _fingerprintAuth = pref.containsKey('FingerprintAuth')? pref.getBool('FingerprintAuth') : false;
    // notify listeners was called to update the providers after the data has been initialized
    notifyListeners();
  }

  Future<void> setFingerPrintAuth(bool allowFingerAuth) async {
      // Is the user authenticated to either ON or OFF biometric authentication
      var userIsAuthenticated = await authenticateWithBiometrics();

      if (userIsAuthenticated == true){
      // if user is authenticated make the change to his/her prefrences
      await pref.setBool('FingerprintAuth', allowFingerAuth);
      _fingerprintAuth = allowFingerAuth;

      }

      notifyListeners();
  }

  Future<void> setDarkMode(bool onDarkMode) async {
    await pref.setBool('DarkMode', onDarkMode);
    _darkMode = onDarkMode;
    notifyListeners();
    /// Notify the paths class of the change in theme.
    Paths.instance.notifyClassOnThemeChanged();
    /// Notify the AppTheme of change in theme.
    AppTheme.instance.notifyListeners();
  }

  Future<void> setAutoSync(bool onAutoSync, {BuildContext? context}) async {
    if (onAutoSync){

        bool phoneNeedsAutoStartPermission = await autoStart.isAutoStartAvailable;
  
        /// if the phone needs auto start permission then show the user the alertDialog. if the user
        /// dismisses the dialog then the guard statement (return;)will end this method.
        if (phoneNeedsAutoStartPermission) {
          bool userClickedEnableAutoStartNow = (await showAutoStartDialog(context: context!))!;
          if(userClickedEnableAutoStartNow) await autoStart.getAutoStartPermission();
          else return;
        }

      // if auto sync is set to true and the user is not signed in , then sign the user in before it start auto sync
      // if the user is already signed in , there will be no need to sign in again
        if (GoogleUserData.instance.userEmail == null) await signInWithGoogle();

        await NativeCodeCaller.instance.startAutoSync();

    }else{
      // if auto sync is set to false then stop the auto sync feature
      await NativeCodeCaller.stopAutoSync();
    }

    await pref.setBool('AutoSync', onAutoSync);
    _autoSync = onAutoSync;
    notifyListeners();
  }

  bool get isDarkMode => _darkMode ?? false;
  bool get fingerprintEnabled => _fingerprintAuth ?? false;
  bool get autoSyncEnabled => _autoSync ?? false;

}

Future<bool> authenticateWithBiometrics({bool calledFromLogin = false}) async {
  var androidAuth = LocalAuthentication();
  var phoneCanCheckBiometric = await androidAuth.canCheckBiometrics;

  if(phoneCanCheckBiometric){
    try{
      var userIsAuthenticated = await androidAuth.authenticate(
                    localizedReason: !calledFromLogin
                    ? 'Authenicate to perform this operation'
                    : 'Authenticate to access this app' ,
                    stickyAuth: true,
                    biometricOnly: true,
                    androidAuthStrings: AndroidAuthMessages(
                    signInTitle: 'Idealog Authentication',
                    biometricHint: ''
                  )
      );
      return userIsAuthenticated;
      
    }on Exception{throw Exception("Phone cannot check exception");}
  }else throw Exception("Phone cannot check exception");
  
}