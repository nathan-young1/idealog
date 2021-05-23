package databaseModels;

import com.google.type.DateTime;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class AnalyticsData {
        public Map<String , Integer> customDateObject = new HashMap<String ,Integer>();
        public int numberOfTasksCompleted;

        public AnalyticsData(int year, int month, int date, int numberOfTasksCompleted){
            customDateObject.put("Year",year);
            customDateObject.put("Month",month);
            customDateObject.put("Date", date);
            this.numberOfTasksCompleted = numberOfTasksCompleted;
        };
}
