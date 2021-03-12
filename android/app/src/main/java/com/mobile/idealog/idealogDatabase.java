package com.mobile.idealog;

import android.content.ContentValues;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class idealogDatabase extends SQLiteOpenHelper {
    public static final String IDEAS = "IDEAS";
    public static final String SCHEDULE = "SCHEDULE";
    public static final String COLUMN_UNIQUE_ID = "uniqueId";
    public static final String COLUMN_IDEA_TITLE = "ideaTitle";
    public static final String COLUMN_MORE_DETAILS = "moreDetails";
    public static final String COLUMN_DEADLINE = "deadline";

    public idealogDatabase(@Nullable Context context, @Nullable String name, @Nullable SQLiteDatabase.CursorFactory factory, @Nullable int version) {
        super(context, "idealog.db", null, 1);
    }

    //called the first time a database is accessed,there should be code in here to create a new database;
    @Override
    public void onCreate(SQLiteDatabase db) {
        final String _createTableStatementForIdeas = "CREATE TABLE " + IDEAS + " (" + COLUMN_UNIQUE_ID + " INTEGER PRIMARY KEY," + COLUMN_IDEA_TITLE + " TEXT," + COLUMN_MORE_DETAILS + " TEXT," + COLUMN_DEADLINE + " NUMBER)";
        //final String _createTableStatementForSchedule = "CREATE TABLE " + SCHEDULE + " (uniqueId INTEGER PRIMARY KEY)";

        db.execSQL(_createTableStatementForIdeas);
        //db.execSQL(_createTableStatementForSchedule);
    }

    //this is called if your database version number changes ,it prevents previous users apps from breaking when you change the database design
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }

    public boolean addOne(int uniqueId){
        List<String> strings = new LinkedList<>();
        strings.add("joe");
        strings.add("me");
        String test = String.valueOf(strings);
        System.out.println(test);
        System.out.println(test.substring(1,test.length()).split(","));
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues contentValues = new ContentValues();
        contentValues.put(COLUMN_IDEA_TITLE, String.valueOf(strings));
        contentValues.put(COLUMN_IDEA_TITLE,"title");
        contentValues.put(COLUMN_DEADLINE,"789");
        contentValues.put(COLUMN_UNIQUE_ID,uniqueId);
        final long insert = db.insert(IDEAS, null, contentValues);
        if(insert == -1){
            return false;
        }else {
            return true;
        }

    }
}
