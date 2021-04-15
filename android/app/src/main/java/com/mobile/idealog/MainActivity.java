package com.mobile.idealog;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.os.PersistableBundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.work.BackoffPolicy;
import androidx.work.Constraints;
import androidx.work.NetworkType;
import androidx.work.OneTimeWorkRequest;
import androidx.work.PeriodicWorkRequest;
import androidx.work.WorkManager;
import androidx.work.WorkRequest;

import dataSyncronization.AutoSync;
import databaseModels.RepeatSchedule;
import databaseModels.ScheduleModel;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import java.util.*;
import java.util.concurrent.TimeUnit;

import static com.mobile.idealog.IdealogDatabase.COLUMN_DATE;
import static com.mobile.idealog.IdealogDatabase.COLUMN_REPEAT_SCHEDULE;
import static com.mobile.idealog.IdealogDatabase.COLUMN_SCHEDULE_DETAILS;
import static com.mobile.idealog.IdealogDatabase.COLUMN_START_TIME;
import static com.mobile.idealog.IdealogDatabase.COLUMN_UNIQUE_ID;
import static com.mobile.idealog.IdealogDatabase.IDEAS;
import static com.mobile.idealog.IdealogDatabase.SCHEDULE;

public class MainActivity extends FlutterActivity {
    final String AutoSyncWorkRequestTag = "AutoSync";
    AlarmManager alarmManager;
    private static final String CHANNEL = "com.idealog.alarmServiceCaller";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                //intialize alarm manager
                alarmManager = (AlarmManager)getSystemService(ALARM_SERVICE);
                final Map<String,Object> configuration = call.arguments();
                int uniqueIdForAlarm = (int) configuration.get("uniqueAlarmId");
                if(call.method.equals("setAlarm")){
                    NotificationType typeOfNotification = ((int)configuration.get("typeOfNotification") == 1)?NotificationType.IDEAS:NotificationType.SCHEDULE;
                    setAlarm(typeOfNotification,uniqueIdForAlarm);
                    result.success("Set Alarm Successfully");
                }else if(call.method.equals("cancelAlarm")){
                    cancelAlarm(uniqueIdForAlarm);
                    result.success("Canceled successfully");
                }
            }
        });
    }

    public void setAlarm(NotificationType notificationType,int uniqueAlarmId){
        IdealogDatabase db = new IdealogDatabase(MainActivity.this,null,null,1);
        SQLiteDatabase database = db.getReadableDatabase();
        String table = (notificationType == NotificationType.IDEAS)?IDEAS:SCHEDULE;
        Cursor cursor = database.rawQuery("SELECT * FROM "+table+" WHERE "+COLUMN_UNIQUE_ID+" = "+uniqueAlarmId,null);
        String alarmTitle = "";
        String repeatSchedule = "";
        Calendar calendar = Calendar.getInstance();
        int year,month,day,hour,minute;

        if(notificationType == NotificationType.SCHEDULE){
            int columnStartTime = cursor.getColumnIndex(COLUMN_START_TIME);
            int columnDate = cursor.getColumnIndex(COLUMN_DATE);
            int columnAlarmTitle = cursor.getColumnIndex(COLUMN_SCHEDULE_DETAILS);
            int columnRepeatSchedule = cursor.getColumnIndex(COLUMN_REPEAT_SCHEDULE);
            if(cursor.moveToFirst()) {
                do {
                    Map<String,Integer> dateAndTime = dateAndTimeFromDb.getDateTime(cursor.getString(columnDate),cursor.getString(columnStartTime));
                    year = dateAndTime.get(dateAndTimeFromDb.Year);
                    month = dateAndTime.get(dateAndTimeFromDb.Month);
                    day = dateAndTime.get(dateAndTimeFromDb.Day);
                    hour = dateAndTime.get(dateAndTimeFromDb.Hour);
                    minute = dateAndTime.get(dateAndTimeFromDb.Minute);

                    calendar.set(year, month, day, hour, minute);

                    alarmTitle = cursor.getString(columnAlarmTitle);
                    repeatSchedule = cursor.getString(columnRepeatSchedule);
                }while (cursor.moveToNext());
            }
        }
        //close the database reference
        db.close();

        PendingIntent pendingIntent = alarmIntent.createPendingIntent(MainActivity.this,alarmTitle,notificationType,uniqueAlarmId);
        customSetAlarmManager.setAlarmManagerRepeatingOnCondition(alarmManager,customSetAlarmManager.changeRepeatScheduleFromStringToObject(repeatSchedule),calendar,pendingIntent);
    }

    public void cancelAlarm(int uniqueAlarmId){
        Intent toCallTheBroadcastReceiver = new Intent(this,ListenForAlarm.class);
        toCallTheBroadcastReceiver.setAction("com.alarm.broadcast_notification");

        PendingIntent pendingIntent = PendingIntent.getBroadcast(this,uniqueAlarmId,toCallTheBroadcastReceiver,0);
        //TO CANCEL THE ALARM
        alarmManager.cancel(pendingIntent);
        System.out.println("The alarm has been canceled");
    }

//    work manager code added below
    public void addTaskToWorkManager(){
        Constraints workRequestConstraints = new Constraints.Builder()
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .setRequiresBatteryNotLow(true)
                .build();

//        do the periodic work every 2 hours if there is internet connection and battery is not low
//        reduce the time later, though The interval period is defined as the minimum time between repetitions.
//        The exact time that the worker is going to be executed depends on the constraints that you are using in your WorkRequest object
//        and on the optimizations performed by the system.

//        incase of error the backoff criteria for result.retry has been set to try again in the next 10 minutes
        PeriodicWorkRequest autoSyncWorkRequest = new PeriodicWorkRequest.Builder(AutoSync.class,2, TimeUnit.HOURS)
                .setConstraints(workRequestConstraints)
                .setBackoffCriteria(BackoffPolicy.LINEAR,10,TimeUnit.MINUTES)
                .addTag(AutoSyncWorkRequestTag)
                .build();

//        Add work request to work manager
        WorkManager
                .getInstance(this)
                .enqueue(autoSyncWorkRequest);

    }

    public void cancelAutoSync(){
//        cancel the autoSync work request
        WorkManager.getInstance(this).cancelAllWorkByTag(AutoSyncWorkRequestTag);
    }
}
