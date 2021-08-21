import 'dart:async';
import 'package:flutter/material.dart';
import 'package:idealog/Prefs&Data/applicationInfo.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/paths.dart';
import 'package:idealog/global/routes.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Timer? timer;
  Future<dynamic> changeRoute() => Navigator.pushReplacementNamed(context,menuPageView);

  @override
    void initState() {
      super.initState();
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {

        timer = Timer(Duration(milliseconds: 800),() async {
          if(Prefrences.instance.fingerprintEnabled){
            // fingerprint authentication is enabled
              if(await authenticateWithBiometrics(calledFromLogin: true))
                changeRoute();
          }else
            // fingerprint authentication is not enabled
            changeRoute();
        });
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
              child: Image.asset(Provider.of<Paths>(context).pathToLogo,height: 240.h,width: 230.w)
              ),
            ),
            Text(ApplicationInfo.fullName_And_version,
              style: dosis.copyWith(fontSize: 28,color: Color.fromRGBO(112, 112, 112, 1))
              )
          ],
        ),
      ),);
  }
}
