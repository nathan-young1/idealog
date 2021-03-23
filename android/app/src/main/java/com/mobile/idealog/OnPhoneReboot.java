package com.mobile.idealog;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.widget.Toast;

import androidx.annotation.Nullable;

import java.io.File;
import java.util.ArrayList;
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
            Toast.makeText(context, "Alarm Set", Toast.LENGTH_SHORT).show();

            List<ScheduleModel> schedule = db.readFromDbAfterReboot();
            //loop through schedules
            schedule.forEach(singleSchedule -> {
                resetAlarmSchedule(
                        singleSchedule.scheduleDetails,
                        NotificationType.SCHEDULE,
                        singleSchedule.uniqueId,
                        singleSchedule.date,
                        singleSchedule.startTime,
                        singleSchedule.repeatSchedule,
                        context);
            });
        }
    }

    private void resetAlarmSchedule(String alarmText, NotificationType notificationType, int uniqueAlarmId,String date, String startTime,RepeatSchedule repeatSchedule,Context context){

        List<String> dateFormat = Arrays.asList(date.split("-"));
        int year = Integer.parseInt(dateFormat.get(0));
        int month = Integer.parseInt(dateFormat.get(1));
        int day = Integer.parseInt(dateFormat.get(2));

        List<String> timeFormat = Arrays.asList(startTime.split(":"));
        int hour = Integer.parseInt(timeFormat.get(0));
        int minute = Integer.parseInt(timeFormat.get(1));

        Calendar alarmTime = Calendar.getInstance();
        alarmTime.set(year,month,day,hour,minute);
        // i am adding this boolean condition so that alarm will not ring if it has a repeat schedule of none and it is before now
        boolean resetAlarm = true;

        if(alarmTime.before(Calendar.getInstance())){
            switch (repeatSchedule){
                case NONE:
                    resetAlarm = false;
                break;
                case DAILY:
                    alarmTime.set(year,month,day+1,hour,minute);
                break;
                case WEEKLY:
                    alarmTime.set(year,month,day+7,hour,minute);
                break;
                case MONTHLY:
                    List<Integer> monthsWith30days = new ArrayList<Integer>(Arrays.asList(3,5,8,10));
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
                    alarmTime.set(year,month,day,hour,minute);
                break;
                case YEARLY:
                    alarmTime.set(year+1,month,day,hour,minute);
                break;
            };
            String newDate = Integer.toString(year)+"-"+Integer.toString(month)+"-"+Integer.toString(day);
            db.updateDate(newDate,uniqueAlarmId);
        }

        Intent toCallTheBroadcastReceiver = new Intent(context,ListenForAlarm.class);
        toCallTheBroadcastReceiver.setAction("com.alarm.broadcast_notification");
        toCallTheBroadcastReceiver.putExtra("alarmText",alarmText);
        toCallTheBroadcastReceiver.putExtra("notificationTypeIsIdea",notificationType == NotificationType.IDEAS);
        toCallTheBroadcastReceiver.putExtra("id",uniqueAlarmId);
        //put a unique pendingIntent id
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context,uniqueAlarmId,toCallTheBroadcastReceiver,0);
        if(resetAlarm) {
            //only ring if reset alarm is true
            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, alarmTime.getTimeInMillis(), pendingIntent);
        }
    }
}