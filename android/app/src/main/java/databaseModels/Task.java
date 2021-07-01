package databaseModels;

import java.util.ArrayList;
import java.util.List;

public class Task {
    String task;
    int primaryKey;
    int orderIndex;

    public Task(String task, int primaryKey, int orderIndex){
        this.task = task;
        this.primaryKey = primaryKey;
        this.orderIndex = orderIndex;
    }
}
