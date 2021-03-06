import 'package:flutter/material.dart';
import 'package:idealog/global/strings.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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