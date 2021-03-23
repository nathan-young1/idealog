package databaseModels;

public class IdeaModel {
    public int uniqueId;
    public int deadline;
    public String alarmTitle;
    public IdeaModel(int uniqueId, int deadline,String alarmTitle){
        this.uniqueId = uniqueId;
        this.deadline = deadline;
        this.alarmTitle = alarmTitle;
    }
}
