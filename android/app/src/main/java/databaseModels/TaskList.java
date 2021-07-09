package databaseModels;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public abstract class TaskList {
    public ArrayList<Task> uncompletedTasks;
    public ArrayList<Task> completedTasks;

    TaskList(ArrayList<Task> uncompletedTasks, ArrayList<Task> completedTasks){
        this.uncompletedTasks = uncompletedTasks;
        this.completedTasks = completedTasks;
    }

    /**
     * Parse the JSONArray list to an ArrayList<Task> for either uncompleted or completed task of idea.
     * @param list
     * @return
     * @throws JSONException
     */
    public static ArrayList<Task> FromJsonArray(JSONArray list) throws JSONException {
        ArrayList<Task> allTasks = new ArrayList<>();
        for(int i = 0; i < list.length(); i++){
//          Each task in the array of either completed or uncompleted tasks.
            JSONObject eachTask = list.getJSONObject(i);
            allTasks.add(
                    new Task(
                            eachTask.getString("task"),
                            eachTask.getInt("primaryKey"),
                            eachTask.getInt("orderIndex"))
            );
        }

        return allTasks;
    }
}
