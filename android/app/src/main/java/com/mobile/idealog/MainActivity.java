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

import databaseModels.RepeatSchedule;
import databaseModels.ScheduleModel;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import java.util.*;

import static com.mobile.idealog.IdealogDatabase.COLUMN_DATE;
import static com.mobile.idealog.IdealogDatabase.COLUMN_REPEAT_SCHEDULE;
import static com.mobile.idealog.IdealogDatabase.COLUMN_SCHEDULE_DETAILS;
import static com.mobile.idealog.IdealogDatabase.COLUMN_START_TIME;
import static com.mobile.idealog.IdealogDatabase.COLUMN_UNIQUE_ID;
import static com.mobile.idealog.IdealogDatabase.IDEAS;
import static com.mobile.idealog.IdealogDatabase.SCHEDULE;

public class MainActivity extends FlutterActivity {

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
        int year = 0;
        int month = 0;
        int day = 0;
        int hour = 0;
        int minute = 0;
        if(notificationType == NotificationType.SCHEDULE){
            int columnStartTime = cursor.getColumnIndex(COLUMN_START_TIME);
            int columnDate = cursor.getColumnIndex(COLUMN_DATE);
            int columnAlarmTitle = cursor.getColumnIndex(COLUMN_SCHEDULE_DETAILS);
            int columnRepeatSchedule = cursor.getColumnIndex(COLUMN_REPEAT_SCHEDULE);
            if(cursor.moveToFirst()) {
                do {
                    String date = cursor.getString(columnDate);
                    String startTime = cursor.getString(columnStartTime);

                    List<String> dateFormat = Arrays.asList(date.split("-"));
                    year = Integer.parseInt(dateFormat.get(0));
                    month = Integer.parseInt(dateFormat.get(1))-1;
                    day = Integer.parseInt(dateFormat.get(2));

                    List<String> timeFormat = Arrays.asList(startTime.split(":"));
                    hour = Integer.parseInt(timeFormat.get(0));
                    minute = Integer.parseInt(timeFormat.get(1));

                    calendar.set(year, month, day, hour, minute);

                    alarmTitle = cursor.getString(columnAlarmTitle);
                    repeatSchedule = cursor.getString(columnRepeatSchedule);
                }while (cursor.moveToNext());
            }
        }

        Intent toCallTheBroadcastReceiver = new Intent(MainActivity.this,ListenForAlarm.class);
        toCallTheBroadcastReceiver.setAction("com.alarm.broadcast_notification");
        toCallTheBroadcastReceiver.putExtra("alarmText",alarmTitle);
        toCallTheBroadcastReceiver.putExtra("notificationType",notificationType);
        toCallTheBroadcastReceiver.putExtra("id",uniqueAlarmId);

        PendingIntent pendingIntent = PendingIntent.getBroadcast(this,uniqueAlarmId,toCallTheBroadcastReceiver,0);
        if(notificationType == NotificationType.SCHEDULE){
            switch (repeatSchedule){
                case "RepeatSchedule.DAILY":
                    alarmManager.setRepeating(AlarmManager.RTC_WAKEUP,calendar.getTimeInMillis(),86400000,pendingIntent);
                    break;
                case "RepeatSchedule.WEEKLY":
                    alarmManager.setRepeating(AlarmManager.RTC_WAKEUP,calendar.getTimeInMillis(),604800000,pendingIntent);
                    break;
                default:
                    alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), pendingIntent);
                    break;
            }
        }
        List<Integer> monthsWith31days = new ArrayList<Integer>(Arrays.asList(0,2,4,6,7,9,11));
        List<Integer> monthsWith30days = new ArrayList<Integer>(Arrays.asList(3,5,8,10));
        Calendar testingY = Calendar.getInstance();
        Calendar testingM = Calendar.getInstance();
        Calendar testingW = Calendar.getInstance();
        Calendar testingD = Calendar.getInstance();
        testingD.set(year,month,day+1,hour,minute);
        testingW.set(year,month,day+7,hour,minute);
        testingY.set(year+1,month,day,hour,minute);

        if(year%4==0 && month == 0){
            //if it is a leap year and the month is january
            List<Integer> dateToLoopBackTo29 = new ArrayList<Integer>(Arrays.asList(30,31));
            if(dateToLoopBackTo29.contains(day)){
                //since it is a leap year move to the next month (febuary) but set the date to 29
               day=29;
            }
        }else if(year%4 != 0 && month == 0){
            //if it is no a leap year and the month is january
            List<Integer> dateToLoopBackTo28 = new ArrayList<Integer>(Arrays.asList(29,30,31));
            if(dateToLoopBackTo28.contains(day)){
                //move to the next month (febuary) but set the day to 28
               day=28;
            }
        }
        if(monthsWith30days.contains(month+1) && day == 31){
            //if current month has 31days and next month has 30 days go to the ending of next month
            month+=1;day = 30;
        }else {month+=1;}

        testingM.set(year, month, day, hour, minute);
        System.out.println("year \n"+testingY.getTime()+"\n\n");
        System.out.println("month \n"+testingM.getTime()+"\n\n");
        System.out.println("week \n"+testingW.getTime()+"\n\n");
        System.out.println("daily \n"+testingD.getTime()+"\n\n");
        System.out.println("\nThe alarm has been scheduled at "+ calendar.getTime());
    }

    public void cancelAlarm(int uniqueAlarmId){
        Intent toCallTheBroadcastReceiver = new Intent(this,ListenForAlarm.class);
        toCallTheBroadcastReceiver.setAction("com.alarm.broadcast_notification");

        PendingIntent pendingIntent = PendingIntent.getBroadcast(this,uniqueAlarmId,toCallTheBroadcastReceiver,0);
        //TO CANCEL THE ALARM
        alarmManager.cancel(pendingIntent);
        System.out.println("The alarm has been canceled");
    }
}
