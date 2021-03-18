extension DataFromSqliteDb on String{
  
  //Extension to convert tasks from db to string.
  List<String> get fromDbStringToStringList{
  return this.substring(1,this.length-1)
  .replaceAll('],', ']_')
  .split('_')
  .map((listOfString) => listOfString.trim()
  .substring(1,listOfString.trim().length-1)
  .split(',')
  .map((stringElements) => int.parse(stringElements))
  .toList())
  .toList()
  .map((listOfInt) => String.fromCharCodes(listOfInt))
  .toList();
  }

}