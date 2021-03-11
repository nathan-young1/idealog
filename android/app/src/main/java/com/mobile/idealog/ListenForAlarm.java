package com.mobile.idealog;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.os.Build;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

public class ListenForAlarm extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        System.out.println("I the broadcast has been called with text "+ MainActivity.alarmContentText);
        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
//        NotificationCompat.Builder(Context context) has been deprecated. And we have to use the constructor which has the channelId parameter:
        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(context,"channelId")
        .setContentTitle("Idealog")
        .setContentText(MainActivity.alarmContentText)
//        remeber to add set small icon of light bulb
        .setSmallIcon(R.drawable.ic_launcher_foreground)
        .setPriority(NotificationCompat.PRIORITY_MAX)
        .setOngoing(true)
        .setAutoCancel(true)
        //setting the lights for blinking led
        .setLights(0xFFb71c1c, 1000, 2000)
        .setLargeIcon(BitmapFactory.decodeResource(context.getResources(), R.drawable.ic_launcher_foreground));
//        now create intent to open app on notification tap
        Intent onNotificationTap = new Intent(context,MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(context,0,onNotificationTap,PendingIntent.FLAG_UPDATE_CURRENT);
        notificationBuilder.setContentIntent(pendingIntent);
        //for andriod 8 and above , you need to set notification channel
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
        {
            String channelId = "Your_channel_id";
            NotificationChannel channel = new NotificationChannel(
                    channelId,
                    "Channel human readable title",
                    NotificationManager.IMPORTANCE_HIGH);
            notificationManager.createNotificationChannel(channel);
            notificationBuilder.setChannelId(channelId);
        }

        //give each notification a different id so they can stand apart
        notificationManager.notify(78,notificationBuilder.build());
    }
}