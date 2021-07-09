package databaseModels;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Task {
    public String task;
    public int primaryKey;
    public int orderIndex;

    public Task(String task, int primaryKey, int orderIndex){
        this.task = task;
        this.primaryKey = primaryKey;
        this.orderIndex = orderIndex;
    }

    public Map toMap(){
        Map json = new HashMap();
        json.put("task",task);
        json.put("primaryKey",primaryKey);
        json.put("orderIndex",orderIndex);
        return json;
    }



}
