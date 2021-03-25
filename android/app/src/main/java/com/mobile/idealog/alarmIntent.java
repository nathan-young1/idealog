package com.mobile.idealog;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;

public class alarmIntent {
    static PendingIntent createPendingIntent(Context context,String alarmTitle,NotificationType notificationType,int uniqueAlarmId){
        Intent toCallTheBroadcastReceiver = new Intent(context,ListenForAlarm.class);
        toCallTheBroadcastReceiver.setAction("com.alarm.broadcast_notification");
        toCallTheBroadcastReceiver.putExtra("alarmText",alarmTitle);
        toCallTheBroadcastReceiver.putExtra("notificationTypeIsIdea",notificationType == NotificationType.IDEAS);
        toCallTheBroadcastReceiver.putExtra("id",uniqueAlarmId);

        return PendingIntent.getBroadcast(context,uniqueAlarmId,toCallTheBroadcastReceiver,0);
    }
}
