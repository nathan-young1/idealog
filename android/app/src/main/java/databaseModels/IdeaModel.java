package databaseModels;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

public class IdeaModel extends TaskList{
    public final int ideaId;
    public final String ideaTitle;
    public final String moreDetails;
    // I am making it a string here because it was stored as a string in the database.
    public final String isFavorite;


    public IdeaModel(int IdeaId, String ideaTitle, String moreDetails,String isFavorite, ArrayList<Task> uncompletedTasks, ArrayList<Task> completedTasks){
        super(uncompletedTasks,completedTasks);
        this.ideaId = IdeaId;
        this.ideaTitle = ideaTitle;
        this.moreDetails = moreDetails;
        this.isFavorite = isFavorite;
    }

    public Map<String, Object> toMap(){
        HashMap json = new HashMap();
        json.put("ideaId", ideaId);
        json.put("ideaTitle", ideaTitle);
        json.put("moreDetails",moreDetails);
        json.put("favorite", isFavorite);
        json.put("uncompletedTasks",uncompletedTasks.stream().map(Task::toMap).collect(Collectors.toList()));
        json.put("completedTasks",completedTasks.stream().map(Task::toMap).collect(Collectors.toList()));
        return json;
    }


}
