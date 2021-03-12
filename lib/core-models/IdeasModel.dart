class Ideas{
  final int uniqueId;
  String ideaTitle;
  String? moreDetails;
  DateTime? deadline;
  _Tasks? tasks;
  Ideas({required this.ideaTitle,this.moreDetails,this.deadline,List<String> tasksToCreate = const[],required this.uniqueId}){
    tasks = _Tasks(listOfTasksToCreate: tasksToCreate);
  }
}

class _Tasks{
  List<String> completedTasks = [];
  List<String> uncompletedTasks = [];

  List<String> get allTasks => [...completedTasks,...uncompletedTasks];
  _Tasks({List<String> listOfTasksToCreate = const[]}):uncompletedTasks = listOfTasksToCreate;

  deleteTask(String task){}
  completeTask(String task){
    uncompletedTasks.remove(task);
    completedTasks.add(task);
    }
  addNewTask(String task)=>uncompletedTasks.add(task);
}