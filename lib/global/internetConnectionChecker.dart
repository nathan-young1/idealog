import 'package:internet_connection_checker/internet_connection_checker.dart';

class UserInternetConnectionChecker{

  /// Returns a boolean on whether the user has an internet connection.
  static bool userHasInternetConnection = false;

  static Future<void> initialize() async {
     InternetConnectionChecker internetConnectionChecker = InternetConnectionChecker();
     
     // check the internet connection asynchronously then set the variable, when the result is returned.
     internetConnectionChecker.hasConnection.then((hasConnection) => userHasInternetConnection = hasConnection);

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
