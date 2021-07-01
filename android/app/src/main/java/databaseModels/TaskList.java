package databaseModels;

import java.util.ArrayList;

public abstract class TaskList {
    public ArrayList<Task> uncompletedTasks;
    public ArrayList<Task> completedTasks;

    TaskList(ArrayList<Task> uncompletedTasks, ArrayList<Task> completedTasks){
        this.uncompletedTasks = uncompletedTasks;
        this.completedTasks = completedTasks;
    }
}
