// extension DataFromSqliteDb on String{
  
//   //Extension to convert tasks from db to string.
//   List<String> get fromDbStringToStringList{
//   return this.substring(1,this.length-1)
//   .replaceAll('],', ']_')
//   .split('_')
//   .map((listOfString) => listOfString.trim()
//   .substring(1,listOfString.trim().length-1)
//   .split(',')
//   .map((stringElements) => int.parse(stringElements))
//   .toList())
//   .toList()
//   .map((listOfInt) => String.fromCharCodes(listOfInt))
//   .toList();
//   }

//   //Extension to convert direct to List<List<int>> for easier use
//   List<List<int>> get fromDbStringToListInt{

//   return this.substring(1,this.length-1)
//   .replaceAll('],', ']_')
//   .split('_')
//   .map((listOfString) => listOfString.trim()
//   .substring(1,listOfString.trim().length-1)
//   .split(',')
//   .map((stringElements) => int.parse(stringElements))
//   .toList())
//   .toList();
//   }

// }

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