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
    AlarmManager alarmManager;
    private static final String CHANNEL = "com.idealog.alarmServiceCaller";

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState, @Nullable PersistableBundle persistentState) {
        super.onCreate(savedInstanceState, persistentState);
        alarmManager = (AlarmManager)getSystemService(ALARM_SERVICE);

    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                final Map<String,Object> configuration = call.arguments();
                if(call.method.equals("setAlarm")){
                    System.out.println("Your configuration id is: " + (String)configuration.get("id"));
                    setAlarm();
                    result.success("Finished successfully");
                }else if(call.method.equals("cancelAlarm")){
                    cancelAlarm();
                    result.success("Canceled successfully");
                }
            }
        });
    }

    public void setAlarm(){
        //remeber to set the contentText
        alarmContentText = "new alarm just texting";
        //remeber to set a different id for each notification
        alarmNotificationId = 9000;
        Intent toCallTheBroadcastReciever = new Intent();
        toCallTheBroadcastReciever.setAction("com.alarm.broadcastNotification");
        toCallTheBroadcastReciever.addCategory("android.intent.category.DEFAULT");
        PendingIntent pendingIntent = PendingIntent.getBroadcast(this,0,toCallTheBroadcastReciever,0);

        //check for type of alarm either normal or repeating
        //guide is at 12.58 of the video
        alarmManager.setRepeating(AlarmManager.RTC_WAKEUP,System.currentTimeMillis(),1000*30,pendingIntent);
        System.out.println("The alarm has been scheduled");
    }

    public void cancelAlarm(){
        Intent toCallTheBroadcastReciever = new Intent();
        toCallTheBroadcastReciever.setAction("com.alarm.broadcastNotification");
        toCallTheBroadcastReciever.addCategory("android.intent.category.DEFAULT");
        PendingIntent pendingIntent = PendingIntent.getBroadcast(this,0,toCallTheBroadcastReciever,0);
        //TO CANCEL THE ALARM
        //find out how to cancel the alarm by the id
        System.out.println("The alarm has been canceled");
        alarmManager.cancel(pendingIntent);
    }
}
