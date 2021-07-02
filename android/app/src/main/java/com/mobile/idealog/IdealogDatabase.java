package com.mobile.idealog;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.List;

import databaseModels.IdeaModel;
import databaseModels.Task;

public class IdealogDatabase extends SQLiteOpenHelper {

    public static final String IDEAS = "ideasTable";
    public static final String COLUMN_Idea_ID = "ideaId";
    public static final String COLUMN_IDEA_TITLE = "ideaTitle";
    public static final String Column_MoreDetails = "moreDetails";
    public static final String Column_tasks = "tasks";
    public static final String Column_taskOrder = "taskOrder";
    public static final String Column_taskId = "taskId";
    public static final String CompletedTable = "CompletedTable";
    public static final String UncompletedTable = "UncompletedTable";
    public static final String IdealogDbName = "idealog.sqlite";

    public IdealogDatabase(@Nullable Context context, @Nullable String name, @Nullable SQLiteDatabase.CursorFactory factory, @Nullable int version) {
        super(context, IdealogDbName, null, 1);
    }

    //called the first time a database is accessed,there should be code in here to create a new database;
    @Override
    public void onCreate(SQLiteDatabase db) {}

    //this is called if your database version number changes ,it prevents previous users apps from breaking when you change the database design
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {}

    public ArrayList<IdeaModel> readAllIdeasInDb(){ return _GetAllIdeasObjects(); }


    private ArrayList<Task> _GetTasksForIdea(String tableName,int IdeaId,SQLiteDatabase db){
        Cursor tableCursor = db.query(tableName, new String[]{Column_taskId, Column_taskOrder, Column_tasks},COLUMN_Idea_ID+" = ?",new String[]{String.valueOf(IdeaId)},null,null,null);
        ArrayList<Task> ListOfTasks = new ArrayList<>();

        if(tableCursor.moveToFirst()){
            do{
                int columnTaskId = tableCursor.getColumnIndex(Column_taskId);
                int columnTask = tableCursor.getColumnIndex(Column_tasks);
                int columnOrderIndex = tableCursor.getColumnIndex(Column_taskOrder);

                int taskId = tableCursor.getInt(columnTaskId);
                String task = tableCursor.getString(columnTask);
                int orderIndex = tableCursor.getInt(columnOrderIndex);
                Task taskRow = new Task(task, taskId, orderIndex);
                ListOfTasks.add(taskRow);
            } while (tableCursor.moveToNext());
        }

//      Close the cursor.
        tableCursor.close();

        return ListOfTasks;
    }

    private ArrayList<IdeaModel> _GetAllIdeasObjects(){
        ArrayList<IdeaModel> ListOfIdeas = new ArrayList<>();
        SQLiteDatabase db = this.getReadableDatabase();
        try {
            Cursor ideasCursor = db.query(IDEAS,null,null,null,null,null,null);

            if (ideasCursor.moveToFirst()) {
                do {
                    int columnUniqueId = ideasCursor.getColumnIndex(COLUMN_Idea_ID);
                    int columnIdeaTitle = ideasCursor.getColumnIndex(COLUMN_IDEA_TITLE);
                    int columnMoreDetails = ideasCursor.getColumnIndex(Column_MoreDetails);
                    int IdeaId = ideasCursor.getInt(columnUniqueId);
                    String IdeaTitle = ideasCursor.getString(columnIdeaTitle);
                    String MoreDetails = ideasCursor.getString(columnMoreDetails);

                    ArrayList<Task> completedTasks = _GetTasksForIdea(CompletedTable, IdeaId, db);
                    ArrayList<Task> uncompletedTasks = _GetTasksForIdea(UncompletedTable, IdeaId, db);

                    IdeaModel newSchedule = new IdeaModel(IdeaId, IdeaTitle, MoreDetails,uncompletedTasks,completedTasks);
                    ListOfIdeas.add(newSchedule);
                } while (ideasCursor.moveToNext());
            }

            //close the database reference
            db.close();
            ideasCursor.close();
            return ListOfIdeas;

        } catch (Exception e){
            System.out.println("An error occurred");
            return ListOfIdeas;
        }
    }

    public void writeLastSyncTime(String lastSyncTime){
        SQLiteDatabase db = this.getWritableDatabase();
        String createLastSyncTable = "create table if not exists LastSync (id_no Integer Primary Key, time Text Not Null)";
        db.execSQL(createLastSyncTable);
        ContentValues values = new ContentValues();
        values.put("id_no",1);
        values.put("time",lastSyncTime);
        db.insert("LastSync",null,values);
        db.close();
    }
}
