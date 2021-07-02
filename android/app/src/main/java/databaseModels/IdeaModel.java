package databaseModels;


import java.util.ArrayList;

public class IdeaModel extends TaskList{
    public final int IdeaId;
    public final String ideaTitle;
    public final String moreDetails;


    public IdeaModel(int IdeaId, String ideaTitle, String moreDetails, ArrayList<Task> uncompletedTasks, ArrayList<Task> completedTasks){
        super(uncompletedTasks,completedTasks);
        this.IdeaId = IdeaId;
        this.ideaTitle = ideaTitle;
        this.moreDetails = moreDetails;
    }
}
