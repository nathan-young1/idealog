import 'package:shared_preferences/shared_preferences.dart';

class TrackTasksCompletedToday{
  
  static late SharedPreferences _sharedPreferences;

  static initalize() async =>_sharedPreferences = await SharedPreferences.getInstance();

  static recordANewTask(){
    DateTime now = DateTime.now();
    final int year = now.year;
    final int month = now.month;
    final int day = now.day;
    final String key = '$year-$month-$day';
    final bool containsKey = _sharedPreferences.containsKey(key);
    int currentTasksCompleted = (containsKey)?_sharedPreferences.getInt(key)!:0;
    _sharedPreferences.setInt(key, ++currentTasksCompleted);
  }

  static removeATask(){
    DateTime now = DateTime.now();
    final int year = now.year;
    final int month = now.month;
    final int day = now.day;
    final String key = '$year-$month-$day';
    final bool containsKey = _sharedPreferences.containsKey(key);
    int currentTasksCompleted = (containsKey)?_sharedPreferences.getInt(key)!:0;
    _sharedPreferences.setInt(key, --currentTasksCompleted);
  }
}