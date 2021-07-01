package databaseModels;

import java.util.ArrayList;
import java.util.List;

public class Task {
    public String task;
    public int primaryKey;
    public int orderIndex;

    public Task(String task, int primaryKey, int orderIndex){
        this.task = task;
        this.primaryKey = primaryKey;
        this.orderIndex = orderIndex;
    }
}
