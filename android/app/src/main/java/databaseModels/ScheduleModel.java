package databaseModels;

public class ScheduleModel {
    public int uniqueId;
    public String date;
    public String startTime;
    public String scheduleDetails;
    public RepeatSchedule repeatSchedule;

    public ScheduleModel(int uniqueId,String date,String startTime,String scheduleDetails,String repeatSchedule){
        this.uniqueId = uniqueId;
        this.date = date;
        this.startTime = startTime;
        this.scheduleDetails = scheduleDetails;
        switch (repeatSchedule){
            case "RepeatSchedule.NONE":
                this.repeatSchedule = RepeatSchedule.NONE;
                break;
            case "RepeatSchedule.DAILY":
                this.repeatSchedule = RepeatSchedule.DAILY;
                break;
            case "RepeatSchedule.WEEKLY":
                this.repeatSchedule = RepeatSchedule.WEEKLY;
                break;
            case "RepeatSchedule.MONTHLY":
                this.repeatSchedule = RepeatSchedule.MONTHLY;
                break;
            case "RepeatSchedule.YEARLY":
                this.repeatSchedule = RepeatSchedule.YEARLY;
                break;
        }
    };
}
