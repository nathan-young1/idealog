package databaseModels;


public class IdeaModel {
    public final int uniqueId;
    public final String ideaTitle;
    public final String moreDetails;

    public final String completedTasks;
    public final String uncompletedTasks;

    public IdeaModel(int uniqueId,String ideaTitle, String moreDetails, String uncompletedTasks, String completedTasks){
        this.uniqueId = uniqueId;
        this.ideaTitle = ideaTitle;
        this.moreDetails = moreDetails;
        this.completedTasks = completedTasks;
        this.uncompletedTasks = uncompletedTasks;
    }
}
