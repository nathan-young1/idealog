import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/routes.dart';
import 'package:idealog/global/strings.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Timer? timer;
  changeRoute() =>Navigator.pushReplacementNamed(context,menuPageView);
  @override
    void initState() {
      super.initState();
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
        timer = Timer(Duration(seconds: 2),()=>changeRoute());
        await Firebase.initializeApp();
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
              child: Image.asset(pathToAppLogo,height: 240.h,width: 230.w,)
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