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

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import java.util.*;

public class MainActivity extends FlutterActivity {

    public static int alarmNotificationId;
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
                    long timeForAlarm = (long) configuration.get("timeForAlarm");
                    String alarmText = (String)configuration.get("alarmText");
                    NotificationType typeOfNotification = ((int)configuration.get("typeOfNotification") == 1)?NotificationType.IDEAS:NotificationType.SCHEDULE;
                    setAlarm(alarmText,typeOfNotification,uniqueIdForAlarm,timeForAlarm);
                    IdealogDatabase db = new IdealogDatabase(MainActivity.this,null,null,1);
                }else if(call.method.equals("cancelAlarm")){
                    cancelAlarm(uniqueIdForAlarm);
                    result.success("Canceled successfully");
                }
            }
        });
    }

    public void setAlarm(String alarmText,NotificationType notificationType,int uniqueAlarmId,long deadline){
        //remember to set the contentText
        String alarmContentText = (notificationType == NotificationType.IDEAS)?"Today is the deadline for "+alarmText:alarmText;
        NotificationType typeOfNotification = notificationType;
        //give each notification id a different value with the help of current time in milliseconds
        alarmNotificationId = (int) System.currentTimeMillis();
        Intent toCallTheBroadcastReceiver = new Intent(this,ListenForAlarm.class);
        toCallTheBroadcastReceiver.setAction("com.alarm.broadcast_notification");
        toCallTheBroadcastReceiver.putExtra("AlarmText",alarmContentText);
        toCallTheBroadcastReceiver.putExtra("NotificationType",typeOfNotification);
        //put a unique pendingIntent id
        PendingIntent pendingIntent = PendingIntent.getBroadcast(this,uniqueAlarmId,toCallTheBroadcastReceiver,0);
        alarmManager.set(AlarmManager.RTC_WAKEUP,deadline,pendingIntent);
        //alarmManager.setAlarmClock();
        //alarmManager.setRepeating();
        System.out.println("The alarm has been scheduled at "+deadline);
    }

    public void cancelAlarm(int uniqueAlarmId){
        Intent toCallTheBroadcastReceiver = new Intent(this,ListenForAlarm.class);
        toCallTheBroadcastReceiver.setAction("com.alarm.broadcast_notification");
        //put unique id for alarm id
        //either this PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_CANCEL_CURRENT 
        PendingIntent pendingIntent = PendingIntent.getBroadcast(this,uniqueAlarmId,toCallTheBroadcastReceiver,0);
        //TO CANCEL THE ALARM
        //find out how to cancel the alarm by the id
        System.out.println("The alarm has been canceled");
        alarmManager.cancel(pendingIntent);
    }
}
