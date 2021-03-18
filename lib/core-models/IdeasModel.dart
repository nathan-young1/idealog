class Idea{
  final int uniqueId;
  String ideaTitle;
  String? moreDetails;
  int? deadline;
  _Tasks? tasks;
  
  Idea({required this.ideaTitle,this.moreDetails,this.deadline,List<String> tasksToCreate = const[],required this.uniqueId}){
    tasks = _Tasks(listOfTasksToCreate: tasksToCreate);
    // alarmText = 'Today is the deadline for $ideaTitle';
  }

  Idea.readFromDb({required this.ideaTitle,this.moreDetails,this.deadline,List<String> completedTasks = const[],required this.uniqueId,List<String> uncompletedTasks = const[]}){
    tasks = _Tasks.fromDb(completedTasks: completedTasks,uncompletedTasks: uncompletedTasks);
  }
}

class _Tasks{
  List<String> completedTasks = [];
  List<String> uncompletedTasks = [];

  List<String> get allTasks => [...completedTasks,...uncompletedTasks];
  _Tasks({List<String> listOfTasksToCreate = const[]}):uncompletedTasks = listOfTasksToCreate;
  _Tasks.fromDb({this.completedTasks = const[],this.uncompletedTasks = const[]});

  deleteTask(String task){}
  completeTask(String task){
    uncompletedTasks.remove(task);
    completedTasks.add(task);
    }
  addNewTask(String task)=>uncompletedTasks.add(task);
}