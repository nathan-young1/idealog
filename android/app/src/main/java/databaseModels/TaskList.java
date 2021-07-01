package databaseModels;

import java.util.ArrayList;

public class TaskList {
    ArrayList<Task> uncompletedTasks = new ArrayList<>();
    ArrayList<Task> completedTasks = new ArrayList<>();

    TaskList(ArrayList<Task> uncompletedTasks, ArrayList<Task> completedTasks){
        this.uncompletedTasks = uncompletedTasks;
        this.completedTasks = completedTasks;
    }
}
