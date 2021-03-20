class Idea{
  final int uniqueId;
  String ideaTitle;
  String? moreDetails;
  int? deadline;
  _Tasks? tasks;
  
  Idea({required this.ideaTitle,this.moreDetails,this.deadline,List<List<int>> tasksToCreate = const[],required this.uniqueId}){
    tasks = _Tasks(listOfTasksToCreate: tasksToCreate);
    // // alarmText = 'Today is the deadline for $ideaTitle';
  }

  Idea.readFromDb({required this.ideaTitle,this.moreDetails,this.deadline,List<List<int>> completedTasks = const[],required this.uniqueId,List<List<int>> uncompletedTasks = const[]}){
    tasks = _Tasks.fromDb(completedTasks: completedTasks,uncompletedTasks: uncompletedTasks);
  }
}

class _Tasks{
  
  List<List<int>> completedTasks = [];
  List<List<int>> uncompletedTasks = [];

  List<List<int>> get allTasks => [...completedTasks,...uncompletedTasks];
  _Tasks({List<List<int>> listOfTasksToCreate = const[]}):uncompletedTasks = listOfTasksToCreate;
  _Tasks.fromDb({this.completedTasks = const[],this.uncompletedTasks = const[]});

  deleteTask(List<int> task){
    (uncompletedTasks.contains(task))
    ?uncompletedTasks.remove(task)
    :completedTasks.remove(task);
  }

  completeTask(List<int> task){
    uncompletedTasks.remove(task);
    completedTasks.add(task);
    }

  addNewTask(List<int> task)=>uncompletedTasks.add(task);
}