package databaseModels;

import com.google.type.DateTime;

public class AnalyticsData {
        long date;
        int numberOfTasksCompleted;

        public AnalyticsData(long date, int numberOfTasksCompleted){
            this.date = date;
            this.numberOfTasksCompleted = numberOfTasksCompleted;
        };
}
