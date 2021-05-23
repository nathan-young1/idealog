import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/routes.dart';
import 'package:idealog/global/strings.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool useBiometric = false;
  Timer? timer;
  changeRoute() =>Navigator.pushReplacementNamed(context,menuPageView);
  @override
    void initState() {
      super.initState();
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        useBiometric = pref.getBool('BiometricIsEnabled') ?? false;
        timer = Timer(Duration(seconds: 2),()=>auth(useBiometric));
        await Firebase.initializeApp();
      });
    }

    @override
      void dispose() {
        timer!.cancel();
        super.dispose();
      }

      void auth(bool useBiometric) async {
        if (useBiometric){
        bool authResult = await biometricAuth();
        authResult
        ?changeRoute()
        :print('An authentication error occured');
        }else{
        changeRoute();
        }
      }
      
      Future<bool> biometricAuth() async {
        LocalAuthentication androidAuth = new LocalAuthentication();
        // when the user stops the authentication
        // androidAuth.stopAuthentication();
        try {
          return await androidAuth.authenticate(localizedReason: 'Authenticate to access this app',
          stickyAuth: true,
          biometricOnly: true,
          androidAuthStrings: AndroidAuthMessages(
            signInTitle: 'Idealog Authentication',
            biometricHint: ''
          )
          );
        }on PlatformException{
          return false;
        }
      }
      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: 50.h),
        child: Column(
          children: [
            Expanded(
              child: Center(
              child: GestureDetector(
              onTap: ()=> auth(useBiometric),
              child: Image.asset(pathToAppLogo,height: 240.h,width: 230.w))
              ),
            ),
            Text('Idealog v1.2',
              style: Overpass.copyWith(fontSize: 28,color: Color.fromRGBO(112, 112, 112, 1))
              )
          ],
        ),
      ),);
  }
}