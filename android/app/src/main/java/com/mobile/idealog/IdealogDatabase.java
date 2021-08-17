package com.mobile.idealog;

import android.content.Context;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import androidx.annotation.Nullable;
import androidx.security.crypto.EncryptedSharedPreferences;
import androidx.security.crypto.MasterKeys;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import databaseModels.IdeaModel;
import databaseModels.Task;

public class IdealogDatabase extends SQLiteOpenHelper {
//  Database variables
    public static final String IDEAS = "ideaTable";
    public static final String COLUMN_Idea_ID = "ideaId";
    public static final String COLUMN_IDEA_TITLE = "ideaTitle";
    public static final String Column_MoreDetails = "moreDetails";
    public static final String Column_task = "task";
    public static final String Column_taskOrder = "taskOrder";
    public static final String Column_taskId = "taskId";
    public static final String Column_taskPriority = "taskPriority";
    public static final String CompletedTable = "CompletedTable";
    public static final String UncompletedTable = "UncompletedTable";
    public static final String IdealogDbName = "idealog.sqlite";
    public static final String Column_favorite = "favorite";


//  SharedPreferences variables
    public static final String LAST_SYNC_SHARED_PREFERENCES_PAGE = "Backup";
    public static final String LAST_SYNC_STRING_KEY = "LastSync";
    public static final String USER_IS_PREMIUM_SHARED_PREFERENCES_PAGE_ENCRYPTED = "IsPremiumUserEncryptedPage";
    public static final String USER_IS_PREMIUM_SHARED_PREFERENCES_PAGE_NORMAL = "IsPremiumUserNormalPage";
    public static final String PREMIUM_EXPIRATION_DATE_KEY = "PremiumExpirationDate";



    public IdealogDatabase(@Nullable Context context, @Nullable String name, @Nullable SQLiteDatabase.CursorFactory factory, int version) {
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
        Cursor tableCursor = db.query(tableName, new String[]{Column_taskId, Column_taskOrder, Column_task, Column_taskPriority},COLUMN_Idea_ID+" = ?",new String[]{String.valueOf(IdeaId)},null,null,null);
        ArrayList<Task> ListOfTasks = new ArrayList<>();

        if(tableCursor.moveToFirst()){
            do{
                int columnTaskId = tableCursor.getColumnIndex(Column_taskId);
                int columnTask = tableCursor.getColumnIndex(Column_task);
                int columnOrderIndex = tableCursor.getColumnIndex(Column_taskOrder);
                int columnPriority = tableCursor.getColumnIndex(Column_taskPriority);

                int taskId = tableCursor.getInt(columnTaskId);
                String task = tableCursor.getString(columnTask);
                int orderIndex = tableCursor.getInt(columnOrderIndex);
                int priority = tableCursor.getInt(columnPriority);

                // Create an instance of the task.
                Task taskRow = new Task(task, taskId, orderIndex, priority);
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
                    int columnIsFavorite = ideasCursor.getColumnIndex(Column_favorite);

                    int IdeaId = ideasCursor.getInt(columnUniqueId);
                    String IdeaTitle = ideasCursor.getString(columnIdeaTitle);
                    String MoreDetails = ideasCursor.getString(columnMoreDetails);
                    String isFavorite = ideasCursor.getString(columnIsFavorite);

                    ArrayList<Task> completedTasks = _GetTasksForIdea(CompletedTable, IdeaId, db);
                    ArrayList<Task> uncompletedTasks = _GetTasksForIdea(UncompletedTable, IdeaId, db);

                    IdeaModel newSchedule = new IdeaModel(IdeaId, IdeaTitle, MoreDetails, isFavorite, uncompletedTasks,completedTasks);
                    ListOfIdeas.add(newSchedule);
                } while (ideasCursor.moveToNext());
            }

            //close the database reference
            db.close();
            ideasCursor.close();
            return ListOfIdeas;

        } catch (Exception e){
            System.out.println("An error occurred" + e);
            return ListOfIdeas;
        }
    }

    /**
        Method that records the last backup time in shared preferences.
        @param  applicationContext - The context of the application to access shared preferences
     */
    public static String WriteLastSyncTime(Context applicationContext){
        LocalDateTime localDateTime = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM dd yyyy hh:mm a");

        String lastSyncTime = localDateTime.format(formatter);
        SharedPreferences sharedPreferences = applicationContext.getSharedPreferences(LAST_SYNC_SHARED_PREFERENCES_PAGE,Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString(LAST_SYNC_STRING_KEY,lastSyncTime);
        editor.apply();

        return "Success";
    }

    /**
     Method that gets the last backup time from shared preferences.
     @param  applicationContext - The context of the application to access shared preferences
     */
    public static String GetLastBackUpTime(Context applicationContext){
        SharedPreferences pref = applicationContext.getSharedPreferences(LAST_SYNC_SHARED_PREFERENCES_PAGE,Context.MODE_PRIVATE);
        return pref.getString(LAST_SYNC_STRING_KEY,"0");
    }

    /**
     This returns an instance of the encrypted shared preference if possible but if there was an error it returns the normal shared pref.
     * @param applicationContext - The context of the application.
     * @return SharedPreferences - An instance of shared preference either encrypted or not.
     */
    private static SharedPreferences getEncryptedSharedPreferencesInstance(Context applicationContext){
        try {
            String masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC);

            SharedPreferences sharedPreferences = EncryptedSharedPreferences.create(
                    USER_IS_PREMIUM_SHARED_PREFERENCES_PAGE_ENCRYPTED,
                    masterKeyAlias,
                    applicationContext,
                    EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                    EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
            );

            return sharedPreferences;

        } catch (GeneralSecurityException | IOException e){
            return applicationContext.getSharedPreferences(USER_IS_PREMIUM_SHARED_PREFERENCES_PAGE_NORMAL,Context.MODE_PRIVATE);
        }
    }


    /**
     * This sets the expirationDate of the user subscription in both encrypted sharedPref and normal sharedPreference so that incase there
     * is an error you can get the expirationDate from normal sharedPref, but if there is no error it is gotten from encrypted sharedPref
     * @param millisecondsSinceEpoch
     * @param applicationContext
     */
    public static String setExpirationDateForPremiumSubscription(String millisecondsSinceEpoch, Context applicationContext) {

        SharedPreferences.Editor encryptedEditor = getEncryptedSharedPreferencesInstance(applicationContext).edit();
        SharedPreferences.Editor normalEditor = applicationContext.getSharedPreferences(USER_IS_PREMIUM_SHARED_PREFERENCES_PAGE_NORMAL,Context.MODE_PRIVATE).edit();

        normalEditor.putLong(PREMIUM_EXPIRATION_DATE_KEY, Long.parseLong(millisecondsSinceEpoch));
        encryptedEditor.putLong(PREMIUM_EXPIRATION_DATE_KEY, Long.parseLong(millisecondsSinceEpoch));
        encryptedEditor.apply();
        normalEditor.apply();

        return "success";
    }

    /**
     * Check if the user has a premium subscription.
     * @param applicationContext
     * @return
     */
    public static boolean UserIsSubscribedToPremium(Context applicationContext){

        SharedPreferences sharedPreferencesInstance = getEncryptedSharedPreferencesInstance(applicationContext);
        long expirationDateInMilliseconds = sharedPreferencesInstance.getLong(PREMIUM_EXPIRATION_DATE_KEY,0);

        // if the expirationDate is not set , return false meaning the user is not subscribed.
        if(expirationDateInMilliseconds == 0) return false;

        Calendar premiumExpirationDate = Calendar.getInstance();
        // set the premium expiration date calender object.
        premiumExpirationDate.setTimeInMillis(expirationDateInMilliseconds);

        // if the current time is before the expirationDate return true meaning user is still subscribed, else return false.
        return Calendar.getInstance().before(premiumExpirationDate);
    }

    /**
     * This method get the expiration date of the user's premium plan in shared pref as <long>, we will only ask for this date if the user is
     * subscribed to premium plan.
     * @param applicationContext
     * @return
     */
    public static long getExpirationDateForPremiumSubscription(Context applicationContext){
        SharedPreferences sharedPreferencesInstance = getEncryptedSharedPreferencesInstance(applicationContext);
        long expirationDateInMilliseconds = sharedPreferencesInstance.getLong(PREMIUM_EXPIRATION_DATE_KEY,0);

        // if the expirationDate is not set , return false meaning the user is not subscribed.
        if(expirationDateInMilliseconds == 0) return 0;
        return expirationDateInMilliseconds;
    }
}
