package databaseModels;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Task {
    public String task;
    public int primaryKey;
    public int orderIndex;
    public int priority;

    public Task(String task, int primaryKey, int orderIndex, int priority) {
        this.task = task;
        this.primaryKey = primaryKey;
        this.orderIndex = orderIndex;
        this.priority = priority;
    }

    public Map toMap(){
        Map json = new HashMap();
        json.put("task",task);
        json.put("primaryKey",primaryKey);
        json.put("orderIndex",orderIndex);
        json.put("priority",priority);
        return json;
    }



}
