package com.mobile.idealog;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;
import android.os.PersistableBundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import java.util.*;

public class MainActivity extends FlutterActivity {
//    set the alarm contentText and clear the value on set alarm finish.
    public static String alarmContentText;
    public static int alarmNotificationId;
    public static NotificationType typeOfNotification;
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
                    int notificationId = (int)configuration.get("uniqueNotificationId");
                    String alarmText = (String)configuration.get("alarmText");
                    typeOfNotification = ((int)configuration.get("typeOfNotification") == 1)?NotificationType.IDEAS:NotificationType.SCHEDULE;
                    setAlarm(notificationId,alarmText,typeOfNotification,uniqueIdForAlarm);
                    result.success("Finished successfully");
                }else if(call.method.equals("cancelAlarm")){
                    cancelAlarm(uniqueIdForAlarm);
                    result.success("Canceled successfully");
                }
            }
        });
    }

    public void setAlarm(int notificationId,String alarmText,NotificationType notificationType,int uniqueAlarmId){
        //remeber to set the contentText
        alarmContentText = alarmText;
        typeOfNotification = notificationType;
        //remeber to set a different id for each notification
        alarmNotificationId = notificationId;
        Intent toCallTheBroadcastReciever = new Intent(this,ListenForAlarm.class);
        toCallTheBroadcastReciever.setAction("com.alarm.broadcast_notification");
        //put a unique pendingIntent id
        PendingIntent pendingIntent = PendingIntent.getBroadcast(this,uniqueAlarmId,toCallTheBroadcastReciever,0);

        //check for type of alarm either normal or repeating
        //guide is at 12.58 of the video
        //alarmManager.setRepeating(AlarmManager.RTC_WAKEUP,System.currentTimeMillis(),1000,pendingIntent);
        //set time
        Date date = new Date();
        Calendar time = Calendar.getInstance();
        time.setTime(date);
        time.set(Calendar.HOUR_OF_DAY,13);
        time.set(Calendar.MINUTE,1);
        time.set(Calendar.SECOND,0);
        alarmManager.set(AlarmManager.RTC_WAKEUP,time.getTimeInMillis(),pendingIntent);
        System.out.println("The alarm has been scheduled at "+time.getTime());
    }

    public void cancelAlarm(int uniqueAlarmId){
        Intent toCallTheBroadcastReciever = new Intent(this,ListenForAlarm.class);
        toCallTheBroadcastReciever.setAction("com.alarm.broadcast_notification");
        //put unique id for alarm id
        //either this PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_CANCEL_CURRENT 
        PendingIntent pendingIntent = PendingIntent.getBroadcast(this,uniqueAlarmId,toCallTheBroadcastReciever,0);
        //TO CANCEL THE ALARM
        //find out how to cancel the alarm by the id
        System.out.println("The alarm has been canceled");
        alarmManager.cancel(pendingIntent);
    }
}
