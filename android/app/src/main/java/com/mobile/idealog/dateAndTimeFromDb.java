package com.mobile.idealog;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class dateAndTimeFromDb {
    public static final String Year = "Year";
    public static final String Month = "Month";
    public static final String Day = "Day";
    public static final String Hour = "Hour";
    public static final String Minute = "Minute";

    public static Map<String,Integer> getDateTime(String date,String startTime){
        Map<String,Integer> result = new HashMap<String, Integer>();

        List<String> dateFormat = Arrays.asList(date.split("-"));
        result.put(Year,Integer.parseInt(dateFormat.get(0)));
        //remember to minus one from month because january is 0 in the array
        result.put(Month,Integer.parseInt(dateFormat.get(1))-1);
        result.put(Day,Integer.parseInt(dateFormat.get(2)));

        List<String> timeFormat = Arrays.asList(startTime.split(":"));
        result.put(Hour,Integer.parseInt(timeFormat.get(0)));
        result.put(Minute,Integer.parseInt(timeFormat.get(1)));

        return result;
    }
}
