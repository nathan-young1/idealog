package databaseModels;


import java.util.ArrayList;

public class IdeaModel extends TaskList{
    public final int IdeaId;
    public final String ideaTitle;
    public final String moreDetails;
//    public ArrayList<Task> uncompletedTasks = new ArrayList<>();
//    public ArrayList<Task> completedTasks = new ArrayList<>();


    public IdeaModel(int IdeaId, String ideaTitle, String moreDetails, ArrayList<Task> uncompletedTasks, ArrayList<Task> completedTasks){
        super(uncompletedTasks,completedTasks);
//        this.uncompletedTasks = uncompletedTasks;
//        this.completedTasks = completedTasks;
        this.IdeaId = IdeaId;
        this.ideaTitle = ideaTitle;
        this.moreDetails = moreDetails;
    }
}
