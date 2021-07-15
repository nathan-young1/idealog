package databaseModels;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

public class IdeaModel extends TaskList{
    public final int ideaId;
    public final String ideaTitle;
    public final String moreDetails;


    public IdeaModel(int IdeaId, String ideaTitle, String moreDetails, ArrayList<Task> uncompletedTasks, ArrayList<Task> completedTasks){
        super(uncompletedTasks,completedTasks);
        this.ideaId = IdeaId;
        this.ideaTitle = ideaTitle;
        this.moreDetails = moreDetails;
    }

    public Map<String, Object> toMap(){
        HashMap json = new HashMap();
        json.put("ideaId", ideaId);
        json.put("ideaTitle", ideaTitle);
        json.put("moreDetails",moreDetails);
        json.put("uncompletedTasks",uncompletedTasks.stream().map(Task::toMap).collect(Collectors.toList()));
        json.put("completedTasks",completedTasks.stream().map(Task::toMap).collect(Collectors.toList()));
        return json;
    }


}
