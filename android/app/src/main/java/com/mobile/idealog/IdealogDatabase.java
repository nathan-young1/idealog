package com.mobile.idealog;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import androidx.annotation.Nullable;

import com.google.type.DateTime;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import databaseModels.AnalyticsData;
import databaseModels.IdeaModel;

public class IdealogDatabase extends SQLiteOpenHelper {
    public static final String IDEAS = "IDEAS";
    public static final String SCHEDULE = "SCHEDULE";
    public static final String COLUMN_UNIQUE_ID = "uniqueId";
    public static final String COLUMN_IDEA_TITLE = "ideaTitle";
    public static final String Column_MoreDetails = "moreDetails";
    public static final String Column_CompletedTasks = "completedTasks";
    public static final String Column_UncompletedTasks = "uncompletedTasks";
    public static final String IdealogDbName = "idealog.db";

    public IdealogDatabase(@Nullable Context context, @Nullable String name, @Nullable SQLiteDatabase.CursorFactory factory, @Nullable int version) {
        super(context, IdealogDbName, null, 1);
    }

    //called the first time a database is accessed,there should be code in here to create a new database;
    @Override
    public void onCreate(SQLiteDatabase db) {}

    //this is called if your database version number changes ,it prevents previous users apps from breaking when you change the database design
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {}

    public List<IdeaModel> readFromDbForAutoSync() {
        List<IdeaModel> ideas = new ArrayList<>();

        SQLiteDatabase db = this.getReadableDatabase();
        String ideasQuery = "select * from " + IDEAS;
        Cursor ideasCursor = db.rawQuery(ideasQuery,null);

        if(ideasCursor.moveToFirst()){
            do{
                int columnUniqueId = ideasCursor.getColumnIndex(COLUMN_UNIQUE_ID);
                int columnIdeaTitle = ideasCursor.getColumnIndex(COLUMN_IDEA_TITLE);
                int columnMoreDetails = ideasCursor.getColumnIndex(Column_MoreDetails);
                int columnCompletedTasks = ideasCursor.getColumnIndex(Column_CompletedTasks);
                int columnUncompletedTasks = ideasCursor.getColumnIndex(Column_UncompletedTasks);
                int UniqueId = ideasCursor.getInt(columnUniqueId);
                String IdeaTitle = ideasCursor.getString(columnIdeaTitle);
                String MoreDetails = ideasCursor.getString(columnMoreDetails);
                String CompletedTasks = ideasCursor.getString(columnCompletedTasks);
                String UncompletedTasks = ideasCursor.getString(columnUncompletedTasks);
                IdeaModel newSchedule = new IdeaModel(UniqueId,IdeaTitle,MoreDetails,UncompletedTasks,CompletedTasks);
                ideas.add(newSchedule);
            }while (ideasCursor.moveToNext());
        }
        //close the database reference
        db.close();
        return ideas;
    }


}
