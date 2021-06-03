import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:idealog/auth/code/authHandler.dart';
import 'package:idealog/nativeCode/bridge.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefrences with ChangeNotifier{

  late SharedPreferences pref;

  static bool? _DarkMode;
  static bool? _AutoSync;
  static bool? _FingerprintAuth;

  

  Prefrences._();
  static Prefrences instance = Prefrences._();

  Future<void> initialize() async {
    pref = await SharedPreferences.getInstance();
    _DarkMode = pref.containsKey('DarkMode')? pref.getBool('DarkMode') : false;
    _AutoSync = pref.containsKey('AutoSync')? pref.getBool('AutoSync') : false;
    _FingerprintAuth = pref.containsKey('FingerprintAuth')? pref.getBool('FingerprintAuth') : false;
    // notify listeners was called to update the providers after the data has been initialized
    notifyListeners();
  }

  Future<void> setFingerPrintAuth(bool allowFingerAuth) async {
    // Is the user authenticated to either ON or OFF biometric authentication
    bool userIsAuthenticated = await authenticateWithBiometrics();

    if (userIsAuthenticated == true){
    // if user is authenticated make the change to his/her prefrences
    await pref.setBool('FingerprintAuth', allowFingerAuth);
    _FingerprintAuth = allowFingerAuth;

    }

    notifyListeners();
  }

  Future<void> setDarkMode(bool onDarkMode) async {
    await pref.setBool('DarkMode', onDarkMode);
    _DarkMode = onDarkMode;
    notifyListeners();
  }

  Future<void> setAutoSync(bool onAutoSync) async {
    if (onAutoSync){
      // if auto sync is set to true and the user is not signed in , then sign the user in before it start auto sync
      // if the user is already signed in , there will be no need to sign in again
        if (GoogleUserData.instance.user_email == null)
        await signInWithGoogle();

      await NativeCodeCaller.startAutoSync();
    }else{
      // if auto sync is set to false then stop the auto sync feature
      await NativeCodeCaller.stopAutoSync();
    }

    await pref.setBool('AutoSync', onAutoSync);
    _AutoSync = onAutoSync;
    notifyListeners();
  }

  bool get isDarkMode => _DarkMode ?? false;
  bool get fingerprintEnabled => _FingerprintAuth ?? false;
  bool get autoSyncEnabled => _AutoSync ?? false;
  String get appLogoPath => !isDarkMode ?'assets/images/logo.png' :'assets/images/logo_Dark.png';

}

authenticateWithBiometrics({bool calledFromLogin = false}) async {
  LocalAuthentication androidAuth = new LocalAuthentication();
  bool phoneCanCheckBiometric = await androidAuth.canCheckBiometrics;

  if(phoneCanCheckBiometric){
    try{
      bool userIsAuthenticated = await androidAuth.authenticate(
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
      
    }on Exception{
      // show dialog an error occured
      print('An exception occured');
      return false;
    }
  }else{
    // show dialog , phone cannot check biometric
    return false;
  }
}