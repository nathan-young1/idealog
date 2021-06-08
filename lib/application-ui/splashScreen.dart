import 'dart:async';
import 'package:flutter/material.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/design/textStyles.dart';
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
  Future<Object?> changeRoute() =>Navigator.pushReplacementNamed(context,menuPageView);

  @override
    void initState() {
      super.initState();
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
        timer = Timer(Duration(milliseconds: 800),()=>Prefrences.instance.fingerprintEnabled 
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
              child: Image.asset(Provider.of<Prefrences>(context).appLogoPath,height: 240.h,width: 230.w))
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