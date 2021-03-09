package com.mobile.idealog;

import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

public class ListenForAlarm extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(context);
//        NotificationCompat.Builder(Context context) has been deprecated. And we have to use the constructor which has the channelId parameter:
        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(context,"channelId");
        notificationBuilder.setContentTitle("Idealog");
        notificationBuilder.setContentText(MainActivity.alarmContentText);
//        remeber to add set small icon of light buld
        notificationBuilder.setSmallIcon(R.drawable.ic_launcher_foreground);
//        now create intent to open app on notification tap
        Intent onNotificationTap = new Intent(context,MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(context,0,onNotificationTap,0);
        notificationBuilder.setContentIntent(pendingIntent);

        notificationBuilder.setAutoCancel(true);
        //give each notification a different id so they can stand apart
        notificationManager.notify(MainActivity.alarmNotificationId,notificationBuilder.build());
    }
}