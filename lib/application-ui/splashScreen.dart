import 'package:flutter/material.dart';
import 'package:idealog/global/strings.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
//   run flutter pub get
// flutter pub run flutter_launcher_icons:main
  //add redirect to login screen
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
        child: Image.asset(pathToAppLogo)
      ),),
    );
  }
}