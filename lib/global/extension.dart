
extension CharCodes on List<int>{
  String get toAString => String.fromCharCodes(this);
}

extension DataFromSqliteDb on Object{

  //Extension to convert direct to List<List<int>> for easier use
  List<List<int>> get fromDbStringToListInt{
  String dataFromDb = this.toString();
  return dataFromDb.substring(1,dataFromDb.length-1)
  .replaceAll('],', ']_')
  .split('_')
  .map((listOfString) => listOfString.trim()
  .substring(1,listOfString.trim().length-1)
  .split(',')
  .map((stringElements) => int.parse(stringElements))
  .toList())
  .toList();
  }

}

extension stringToDateTime on String{
  int get deadlineStringToMillisecondsSinceEponch{
  List<String> deadlineDateTime = this.split('-');
  int year = int.parse(deadlineDateTime[0]);
  int month = int.parse(deadlineDateTime[1]);
  int day = int.parse(deadlineDateTime[2]);
  return DateTime(year,month,day).millisecondsSinceEpoch;
  }

  int get scheduleStartTimeToMillisecondsSinceEponch{
    List<String> dateAndTime = this.split(' ');
    List<String> dateInString = dateAndTime.first.split('-');
    List<String> timeInString = dateAndTime.last.split(':');
    int year = int.parse(dateInString[0]);
    int month = int.parse(dateInString[1]);
    int day = int.parse(dateInString[2]);
    int hour = int.parse(timeInString.first);
    int minute = int.parse(timeInString.last);
    return DateTime(year,month,day,hour,minute).millisecondsSinceEpoch;
  }
}