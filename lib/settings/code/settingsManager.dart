import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

test() async {
SharedPreferences pref = await SharedPreferences.getInstance();
print(pref.getString('LastSync'));

}