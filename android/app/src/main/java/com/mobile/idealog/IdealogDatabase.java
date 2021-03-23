package com.mobile.idealog;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import databaseModels.IdeaModel;
import databaseModels.ScheduleModel;

public class IdealogDatabase extends SQLiteOpenHelper {
    public static final String IDEAS = "IDEAS";
    public static final String SCHEDULE = "SCHEDULE";
    public static final String COLUMN_UNIQUE_ID = "uniqueId";
    public static final String COLUMN_IDEA_TITLE = "ideaTitle";
    public static final String COLUMN_SCHEDULE_DETAILS = "scheduleDetails";
    public static final String COLUMN_DEADLINE = "deadline";
    public static final String COLUMN_REPEATSCHEDULE = "repeatSchedule";
    public static final String COLUMN_DATE = "date";
    public static final String COLUMN_STARTTIME = "startTime";

    public IdealogDatabase(@Nullable Context context, @Nullable String name, @Nullable SQLiteDatabase.CursorFactory factory, @Nullable int version) {
        super(context, "idealog.db", null, 1);
    }

    //called the first time a database is accessed,there should be code in here to create a new database;
    @Override
    public void onCreate(SQLiteDatabase db) {}

    //this is called if your database version number changes ,it prevents previous users apps from breaking when you change the database design
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {}


    public Map<String, List> readFromDbAfterReboot() {
        List<IdeaModel> ideas = new ArrayList<>();
        List<ScheduleModel> schedule = new ArrayList<>();
        Map<String,List> dbResult = new HashMap<>();

        SQLiteDatabase db = this.getReadableDatabase();
        String ideasQuery = "SELECT * FROM " + IDEAS;
        String scheduleQuery = "SELECT * FROM " + SCHEDULE;
        final Cursor ideasCursor = db.rawQuery(ideasQuery,null);
        final Cursor scheduleCursor = db.rawQuery(scheduleQuery,null);
        if(ideasCursor.moveToFirst()){
            do{
               int columnUniqueId = ideasCursor.getColumnIndex(COLUMN_UNIQUE_ID);
               int columnDeadline = ideasCursor.getColumnIndex(COLUMN_DEADLINE);
               int columnAlarmTitle = ideasCursor.getColumnIndex(COLUMN_IDEA_TITLE);
               int uniqueId = ideasCursor.getInt(columnUniqueId);
               int deadline = ideasCursor.getInt(columnDeadline);
               String alarmTitle = ideasCursor.getString(columnAlarmTitle);
               IdeaModel idea = new IdeaModel(uniqueId,deadline,alarmTitle);
               ideas.add(idea);
            }while(ideasCursor.moveToNext());
        }

        if(scheduleCursor.moveToFirst()){
            do{
            int columnUniqueId = scheduleCursor.getColumnIndex(COLUMN_UNIQUE_ID);
            int columnStartTime = scheduleCursor.getColumnIndex(COLUMN_STARTTIME);
            int columnDate = scheduleCursor.getColumnIndex(COLUMN_DATE);
            int columnAlarmTitle = scheduleCursor.getColumnIndex(COLUMN_SCHEDULE_DETAILS);
            int columnRepeatSchedule = scheduleCursor.getColumnIndex(COLUMN_REPEATSCHEDULE);
            int uniqueId = scheduleCursor.getInt(columnUniqueId);
            String date = scheduleCursor.getString(columnDate);
            String startTime = scheduleCursor.getString(columnStartTime);
            String alarmTitle = scheduleCursor.getString(columnAlarmTitle);
            String repeatSchedule = scheduleCursor.getString(columnRepeatSchedule);
            ScheduleModel newSchedule = new ScheduleModel(uniqueId,date,startTime,alarmTitle,repeatSchedule);
            schedule.add(newSchedule);
            }while (scheduleCursor.moveToNext());
        }
        //add the list to map in other to return all result once
        dbResult.put(IDEAS,ideas);
        dbResult.put(SCHEDULE,schedule);

        return dbResult;
    }

    public void updateTime(String newDate,int uniqueId){
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues contentValues = new ContentValues();
        contentValues.put(COLUMN_DATE,newDate);
        String[] whereArgs = {Integer.toString(uniqueId)};
        db.update(SCHEDULE,contentValues,COLUMN_UNIQUE_ID+" = ?",whereArgs);
    }
}
