import 'dart:async';
import 'package:flutter/material.dart';
import 'package:idealog/Prefs&Data/applicationInfo.dart';
import 'package:idealog/Prefs&Data/phoneSizeInfo.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/application-menu/menuPageView.dart';
import 'package:idealog/customWidget/alertDialog/autoStartDialog.dart';
import 'package:idealog/customWidget/alertDialog/deleteDialog.dart';
import 'package:idealog/customWidget/alertDialog/logOutDialog.dart';
import 'package:idealog/customWidget/alertDialog/multiTaskDeleteDialog.dart';
import 'package:idealog/customWidget/alertDialog/premiumDialog.dart';
import 'package:idealog/customWidget/alertDialog/syncNowDialog.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/paths.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:idealog/intro-pages/introPages.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Timer? timer;
  Future<dynamic> changeRoute() => Navigator.pushReplacement(context, PageTransition(child: MenuPageView(), type: PageTransitionType.fade));

  @override
    void initState() {
      super.initState(); 
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
        /// initialize the phone size.
        PhoneSizeInfo.instance.initialize(context);
        timer = Timer(Duration(milliseconds: 800),() async {

          if(await Prefrences.instance.isUserFirstTimeOpeningTheApp){
            // navigate to the introPages on user first time opening the app.
            Navigator.pushReplacement(context, PageTransition(child: IntroPages(), type: PageTransitionType.fade));
            return;
          }

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
              style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.large, color: Color.fromRGBO(112, 112, 112, 1))
              )
          ],
        ),
      ),);
  }
}
