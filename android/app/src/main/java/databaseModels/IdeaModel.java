package databaseModels;

public class IdeaModel {
    public int uniqueId;
    public String alarmTitle;
    public IdeaModel(int uniqueId, int deadline,String alarmTitle){
        this.uniqueId = uniqueId;
        this.alarmTitle = alarmTitle;
    }
}
