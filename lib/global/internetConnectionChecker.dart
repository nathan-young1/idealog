import 'package:internet_connection_checker/internet_connection_checker.dart';

class UserInternetConnectionChecker{

  /// Returns a boolean on whether the user has an internet connection.
  static late bool userHasInternetConnection;

  static Future<void> initialize() async {
     InternetConnectionChecker internetConnectionChecker = InternetConnectionChecker();
     
     /// intialize this variable at startup before there is any change in internet connection status.
     userHasInternetConnection = await internetConnectionChecker.hasConnection;

     /// This stream listens to internet connection status changes and then it updates the userHasInternetConnection variable.
     internetConnectionChecker.onStatusChange.listen((status) async {
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