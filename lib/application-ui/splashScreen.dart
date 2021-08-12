import 'dart:async';
import 'package:flutter/material.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/application-menu/menuPageView.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/paths.dart';
import 'package:idealog/global/routes.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Timer? timer;
  Future<dynamic> changeRoute() =>Navigator.pushReplacementNamed(context,menuPageView);

  @override
    void initState() {
      super.initState();
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {

        timer = Timer(Duration(milliseconds: 800),() async {
        if(Prefrences.instance.fingerprintEnabled){
          // fingerprint authentication is enabled
            if(await authenticateWithBiometrics(calledFromLogin: true))
              changeRoute();
        } else
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
              child: GestureDetector(
                // create a login with fingerprint screen so that they can touch the center to authenticate again after 5 seconds
              // onTap: ()=> auth(useBiometric),
              child: Image.asset(Provider.of<Paths>(context).pathToLogo,height: 240.h,width: 230.w))
              ),
            ),
            Text('Idealog v1.2',
              style: overpass.copyWith(fontSize: 28,color: Color.fromRGBO(112, 112, 112, 1))
              )
          ],
        ),
      ),);
  }
}

class TabletTest extends StatelessWidget {
  const TabletTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      drawer: Container(
          height: MediaQuery.of(context).size.height,
          color: Color.fromRGBO(112, 112, 112, 1),
          width: 250
          ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: context.screenWidth,
        child: MenuPageView(),
      ),
    );
  }
}
