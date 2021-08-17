import 'dart:io';

import 'package:flutter/material.dart';
import 'package:idealog/settings/code/PremiumClass.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class UserInternetConnectionChecker{

  /// Returns a boolean on whether the user has an internet connection.
  static late bool userHasInternetConnection;

  static Future<void> intialize() async {
     InternetConnectionChecker internet_connection_checker = InternetConnectionChecker();
     
     /// intialize this variable at startup before there is any change in internet connection status.
     userHasInternetConnection = await internet_connection_checker.hasConnection;

     /// This stream listens to internet connection status changes and then it updates the userHasInternetConnection variable.
     internet_connection_checker.onStatusChange.listen((status) async {
       switch (status) {
         
         case InternetConnectionStatus.connected:
           userHasInternetConnection = true;
           break;

         case InternetConnectionStatus.disconnected:
           userHasInternetConnection = false;
           break;
       }
     });
  }
}