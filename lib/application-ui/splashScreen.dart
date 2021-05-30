import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idealog/Databases/analytics-db/analyticsSql.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
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
        await AnalyticDB.instance.clearObsoluteData();
        await Prefrences.instance.initialize();
        await Firebase.initializeApp();
        timer = Timer(Duration(seconds: 2),()=>Prefrences.instance.fingerprintEnabled 
        ?authenticateWithBiometrics(calledFromLogin: true)
        :changeRoute());
      });
    }

    @override
      void dispose() {
        timer!.cancel();
        super.dispose();
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
                // create a login with fingerprint screen so that they can touch the center to authenticate again after 5 seconds
              // onTap: ()=> auth(useBiometric),
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