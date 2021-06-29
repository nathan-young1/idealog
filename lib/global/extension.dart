import 'package:idealog/Databases/idealog-db/idealog_Db.dart';
import 'package:sqflite/sqflite.dart';

extension CharCodes on List<int>{
  String get toAString => String.fromCharCodes(this);
}

extension Trigger on Database{
  Future<void> transactionAndTrigger(Future Function(Transaction) action) async {
    await this.transaction(action);
    IdealogDb.notifyListeners();
  }
}

extension DataFromSqliteDb on Object{

  //Extension to convert direct to List<List<int>> for easier use
  List<List<int>> get fromDbStringToListInt{
  var dataFromDb = toString();

  // if the list is empty
  if (dataFromDb == '[]') {
    return <List<int>>[];
  } else {
    return dataFromDb.substring(1,dataFromDb.length-1)
  .replaceAll('],', ']_')
  .split('_')
  .map((listOfString) =>
      listOfString.trim()
      .substring(1,listOfString.trim().length-1)
      .split(',')
      .map((stringElements) => int.parse(stringElements))
      .toList())
  .toList();
  }
  }

    //Extension to convert direct to List<List<int>> for easier use
  List<int> get StringToListInt{
  var dataFromDb = toString();

  // if the list is empty
  if (dataFromDb == '[]') {
    return <int>[];
  } else {
    return dataFromDb.substring(1,dataFromDb.length-1)
  .split(',')
  .map((char) => int.parse(char))
  .toList();
  }
  }

}

extension StringToDateTime on String{
  int get deadlineStringToMillisecondsSinceEponch{
  var deadlineDateTime = split('-');
  var year = int.parse(deadlineDateTime[0]);
  var month = int.parse(deadlineDateTime[1]);
  var day = int.parse(deadlineDateTime[2]);
  return DateTime(year,month,day).millisecondsSinceEpoch;
  }

  int get scheduleStartTimeToMillisecondsSinceEponch{
    var dateAndTime = split(' ');
    var dateInString = dateAndTime.first.split('-');
    var timeInString = dateAndTime.last.split(':');
    var year = int.parse(dateInString[0]);
    var month = int.parse(dateInString[1]);
    var day = int.parse(dateInString[2]);
    var hour = int.parse(timeInString.first);
    var minute = int.parse(timeInString.last);
    return DateTime(year,month,day,hour,minute).millisecondsSinceEpoch;
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month
           && day == other.day;
  }
}