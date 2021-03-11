package com.mobile.idealog;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.os.Build;

import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
enum NotificationType{IDEAS,SCHEDULE}
public class ListenForAlarm extends BroadcastReceiver {
    NotificationManager notificationManager;
    NotificationCompat.Builder notificationBuilder;
    @Override
    public void onReceive(Context context, Intent intent) {
        System.out.println("I the broadcast has been called with text "+ MainActivity.alarmContentText);
//        NotificationCompat.Builder(Context context) has been deprecated. And we have to use the constructor which has the channelId parameter:
        notificationBuilder = new NotificationCompat.Builder(context,"channelId")
        .setContentTitle("Idealog")
        .setContentText(MainActivity.alarmContentText)
//        remeber to add set small icon of light bulb
        .setSmallIcon(R.drawable.ic_launcher_foreground)
        .setPriority(NotificationCompat.PRIORITY_HIGH)
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
            createChannels(context);
        }

        //give each notification a different id so they can stand apart
        final int notificationId = MainActivity.alarmNotificationId;
        notificationManager.notify(notificationId,notificationBuilder.build());
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    public void createChannels(Context context){
        //channel for all notification from ideas
        String ideaschannelId = "Channel for ideas";
        NotificationChannel ideasChannel = new NotificationChannel(
                ideaschannelId,
                "Ideas",
                NotificationManager.IMPORTANCE_HIGH);
        ideasChannel.enableVibration(true);
        ideasChannel.setLightColor(0xFFb71c1c);
        ideasChannel.enableLights(true);
        ideasChannel.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
        getNotificationManager(context).createNotificationChannel(ideasChannel);
        notificationBuilder.setChannelId(ideaschannelId);
        //channel for all notification from schedule
        String schedulechannelId = "Channel for schedules";
        NotificationChannel scheduleChannel = new NotificationChannel(
                schedulechannelId,
                "Schedules",
                NotificationManager.IMPORTANCE_HIGH);
        scheduleChannel.enableVibration(true);
        scheduleChannel.setLightColor(0xFFb71c1c);
        scheduleChannel.enableLights(true);
        scheduleChannel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC);
        getNotificationManager(context).createNotificationChannel(scheduleChannel);
        notificationBuilder.setChannelId(schedulechannelId);
    }

    public NotificationManager getNotificationManager(Context context) {
        //create a new notification manager if it does not already exist
        if(notificationManager == null) {
            notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        }
        return notificationManager;
    }

    public NotificationCompat.Builder getIdeasNotification(String title,String message,Context context,boolean userCanClearNotification,NotificationType typeOfNotification){
        return new NotificationCompat.Builder(context,"IdForIdeas")
                .setContentTitle("Idealog")
                .setContentText(MainActivity.alarmContentText)
//        remeber to add set small icon of light bulb
                .setSmallIcon((typeOfNotification == NotificationType.IDEAS)?R.drawable.ic_ideas_notification:R.drawable.ic_schedule_notification)
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setOngoing(!userCanClearNotification)
                .setAutoCancel(true)
                //setting the lights for blinking led
                .setLights(0xFFb71c1c, 1000, 2000)
                .setLargeIcon(BitmapFactory.decodeResource(context.getResources(), R.drawable.ic_launcher_foreground));
    }
}
