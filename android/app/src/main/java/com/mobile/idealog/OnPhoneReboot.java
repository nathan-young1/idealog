package com.mobile.idealog;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;

import androidx.annotation.Nullable;

import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import databaseModels.IdeaModel;
import databaseModels.RepeatSchedule;
import databaseModels.ScheduleModel;


public class OnPhoneReboot extends BroadcastReceiver {
    AlarmManager alarmManager;
    IdealogDatabase db;
    @Override
    public void onReceive(Context context, Intent intent) {
        alarmManager = (AlarmManager)context.getSystemService(context.ALARM_SERVICE);
        db = new IdealogDatabase(context,null,null,1);
        //implement the rescheduling of alarm after reading from sqlLite database here
        if (intent.getAction().equals("android.intent.action.BOOT_COMPLETED")) {

            List<ScheduleModel> schedule = db.readFromDbAfterReboot();
            //loop through schedules
            schedule.forEach(singleSchedule -> resetAlarmSchedule(
                    singleSchedule.scheduleDetails,
                    NotificationType.SCHEDULE,
                    singleSchedule.uniqueId,
                    singleSchedule.date,
                    singleSchedule.startTime,
                    singleSchedule.repeatSchedule,
                    context));
        }
    }

    private void resetAlarmSchedule(String alarmText, NotificationType notificationType, int uniqueAlarmId, @Nullable String date, @Nullable String startTime,RepeatSchedule repeatSchedule,Context context){

        List<String> dateFormat = Arrays.asList(date.split("-"));
        int year = Integer.parseInt(dateFormat.get(0));
        int month = Integer.parseInt(dateFormat.get(1));
        int day = Integer.parseInt(dateFormat.get(2));

        List<String> timeFormat = Arrays.asList(startTime.split(":"));
        int hour = Integer.parseInt(timeFormat.get(0));
        int minute = Integer.parseInt(timeFormat.get(1));

        Calendar alarmTime = Calendar.getInstance();
        alarmTime.set(year,month,day,hour,minute);

        if(alarmTime.before(Calendar.getInstance())){
            switch (repeatSchedule){
                case DAILY:
                    alarmTime.add(Calendar.DATE,1);
                break;
                case WEEKLY:
                    alarmTime.add(Calendar.DAY_OF_MONTH,7);
                break;
                case MONTHLY:
                    alarmTime.add(Calendar.MONTH,1);
                break;
                case YEARLY:
                    alarmTime.set(year+1,month,day,hour,minute);
                break;
            };
            db.updateTime(Integer.toString(year),uniqueAlarmId);
        }

        Intent toCallTheBroadcastReceiver = new Intent(context,ListenForAlarm.class);
        toCallTheBroadcastReceiver.setAction("com.alarm.broadcast_notification");
        toCallTheBroadcastReceiver.putExtra("alarmText",alarmText);
        toCallTheBroadcastReceiver.putExtra("notificationType",notificationType);
        toCallTheBroadcastReceiver.putExtra("id",uniqueAlarmId);
        //put a unique pendingIntent id
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context,uniqueAlarmId,toCallTheBroadcastReceiver,0);
        alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP,alarmTime.getTimeInMillis(),pendingIntent);
    }
}