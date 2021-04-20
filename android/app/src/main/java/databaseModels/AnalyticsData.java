package databaseModels;

import com.google.type.DateTime;

import java.util.Calendar;

public class AnalyticsData {
        public Calendar date;
        public int numberOfTasksCompleted;

        public AnalyticsData(Calendar date, int numberOfTasksCompleted){
            this.date = date;
            this.numberOfTasksCompleted = numberOfTasksCompleted;
        };
}
