package com.mobile.idealog;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import databaseModels.AnalyticsData;

public class AnalyticsDatabase extends SQLiteOpenHelper {


    public static final String Analytics_Table_Name = "Analytics";
    public static final String Analytics_Db_Name = "analytics.db";

    public AnalyticsDatabase(@Nullable Context context, @Nullable String name, @Nullable SQLiteDatabase.CursorFactory factory, int version) {
        super(context, Analytics_Db_Name, null, 1);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {}

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) { }

    public List<AnalyticsData> readAnalyticsForAutoSync(){
        Calendar now = Calendar.getInstance();
//      i am adding one because dart months starts from 1-12 while java starts from 0-11, so one its added to be able to get the
//      current month from the database
        int currentMonth = now.get(Calendar.MONTH)+1;
        int currentYear = now.get(Calendar.YEAR);
        SQLiteDatabase _analyticsDb = this.getReadableDatabase();

        System.out.println("the current month is "+currentMonth);
        final String getCurrentMonthAnalyticsSql = "select * from "+Analytics_Table_Name+" WHERE month = "+currentMonth;
        Cursor analyticsData = _analyticsDb.rawQuery(getCurrentMonthAnalyticsSql,null);

        ArrayList<Integer> recordedDaysInDb = new ArrayList<Integer>();
        if(analyticsData.moveToFirst()) {
            do {
                int columnMonth = analyticsData.getColumnIndex("month");
                int columnDay = analyticsData.getColumnIndex("day");
                int month = analyticsData.getInt(columnMonth);
                int day = analyticsData.getInt(columnDay);
                System.out.println("month in db: "+month);
                //create a list of all the days recorded in the database
                recordedDaysInDb.add(day);
            }while (analyticsData.moveToNext());
        }
        System.out.println("days in db: "+recordedDaysInDb);
        //create a set to know the active days (so it does not repeat days in list)
        Set<Integer> activeDays = new HashSet<>(recordedDaysInDb);

        // to store the result of the analytics
        List<AnalyticsData> analyticsResult = new ArrayList<AnalyticsData>();
        //the number of times that active day repeat in the list is equivalent to the number of task completed on that day

        activeDays.forEach((activeDay) -> {
            int numberOfTasksCompleted = (int) recordedDaysInDb.stream().filter(day -> day == activeDay).count();
            System.out.println(activeDay + " "+numberOfTasksCompleted);
            AnalyticsData newData =  new AnalyticsData(currentYear,currentMonth,activeDay, numberOfTasksCompleted);
            analyticsResult.add(newData);
        });

        _analyticsDb.close();
        return analyticsResult;
    }

}
