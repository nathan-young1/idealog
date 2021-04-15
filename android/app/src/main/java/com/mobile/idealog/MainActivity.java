package com.mobile.idealog;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import androidx.annotation.NonNull;
import androidx.work.BackoffPolicy;
import androidx.work.Constraints;
import androidx.work.NetworkType;
import androidx.work.PeriodicWorkRequest;
import androidx.work.WorkManager;

import dataSyncronization.AutoSync;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import java.util.*;
import java.util.concurrent.TimeUnit;
import static com.mobile.idealog.IdealogDatabase.COLUMN_UNIQUE_ID;
import static com.mobile.idealog.IdealogDatabase.IDEAS;
import static com.mobile.idealog.IdealogDatabase.SCHEDULE;

public class MainActivity extends FlutterActivity {
    final private String AutoSyncWorkRequestTag = "AutoSync";
    final private String setAlarmMethod = "setAlarm";
    final private String cancelAlarmMethod = "cancelAlarm";
    final private String startAutoSyncMethod = "startAutoSync";
    final private String cancelAutoSyncMethod = "cancelAutoSync";
    AlarmManager alarmManager;
    private static final String CHANNEL = "com.idealog.alarmServiceCaller";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

//              all this will be initialize when i add alarm to tasks
//                alarmManager = (AlarmManager)getSystemService(ALARM_SERVICE);
//                final Map<String,Object> configuration = call.arguments();
//                int uniqueIdForAlarm = (int) configuration.get("uniqueAlarmId");
//                if(call.method.equals(setAlarmMethod)){
//                    NotificationType typeOfNotification = ((int)configuration.get("typeOfNotification") == 1)?NotificationType.IDEAS:NotificationType.SCHEDULE;
//                    setAlarm(typeOfNotification,uniqueIdForAlarm);
//                    result.success("Set Alarm Successfully");
//                }else if(call.method.equals(cancelAlarmMethod)){
//                    cancelAlarm(uniqueIdForAlarm);
//                    result.success("Canceled successfully");
//                }
                if(call.method.equals(startAutoSyncMethod)){
                    startAutoSync();
                    result.success("Auto Sync Started");
                }else if(call.method.equals(cancelAutoSyncMethod)){
                    cancelAutoSync();
                    result.success("Auto Sync has been canceled");
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
            int columnStartTime = cursor.getColumnIndex("");
            int columnDate = cursor.getColumnIndex("");
            int columnAlarmTitle = cursor.getColumnIndex("");
            int columnRepeatSchedule = cursor.getColumnIndex("");
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
    public void startAutoSync(){
        Constraints workRequestConstraints = new Constraints.Builder()
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .setRequiresBatteryNotLow(true)
                .build();

//        do the periodic work every 2 hours if there is internet connection and battery is not low
//        reduce the time later, though The interval period is defined as the minimum time between repetitions.
//        The exact time that the worker is going to be executed depends on the constraints that you are using in your WorkRequest object
//        and on the optimizations performed by the system.

//        incase of error the backoff criteria for result.retry has been set to try again in the next 10 minutes
//        I am changing time unit to minutes for testing purposes
        PeriodicWorkRequest autoSyncWorkRequest = new PeriodicWorkRequest.Builder(AutoSync.class,2, TimeUnit.MINUTES)
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
