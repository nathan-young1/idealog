package com.mobile.idealog;

import android.app.AlarmManager;
import android.app.PendingIntent;

import java.util.Calendar;

import databaseModels.RepeatSchedule;

public class customSetAlarmManager {
    static public void setAlarmManagerRepeatingOnCondition(AlarmManager alarmManager, RepeatSchedule repeatSchedule, Calendar alarmTime, PendingIntent pendingIntent){
        if(repeatSchedule != RepeatSchedule.NONE) {
            switch(repeatSchedule){
                //set repeating on phone reboot in case the user do not off and on the phone before the next alarm
                case DAILY:
                    alarmManager.setRepeating(AlarmManager.RTC_WAKEUP,alarmTime.getTimeInMillis(),86400000,pendingIntent);
                    break;
                case WEEKLY:
                    alarmManager.setRepeating(AlarmManager.RTC_WAKEUP,alarmTime.getTimeInMillis(),604800000,pendingIntent);
                    break;
                default:
                    alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, alarmTime.getTimeInMillis(), pendingIntent);
                    break;
            }
        }
    }
    static public RepeatSchedule changeRepeatScheduleFromStringToObject(String repeatSchedule){
        RepeatSchedule repeatScheduleObject = RepeatSchedule.NONE;

        switch (repeatSchedule){
            case "RepeatSchedule.DAILY":
                repeatScheduleObject = RepeatSchedule.DAILY;
            break;
            case "RepeatSchedule.WEEKLY":
                repeatScheduleObject = RepeatSchedule.WEEKLY;
            break;
            case "RepeatSchedule.MONTHLY":
                repeatScheduleObject = RepeatSchedule.MONTHLY;
            break;
            case "RepeatSchedule.YEARLY":
                repeatScheduleObject = RepeatSchedule.YEARLY;
            break;
        }
    return repeatScheduleObject;
    }
}
