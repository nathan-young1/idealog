package com.mobile.idealog;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.media.AudioAttributes;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.SystemClock;

import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import java.util.UUID;

enum NotificationType{IDEAS,SCHEDULE}
public class ListenForAlarm extends BroadcastReceiver {
    NotificationManager notificationManager;
    NotificationCompat.Builder notificationBuilder;
    String alarmContentText;
    int id;
    NotificationType notificationType;
    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals("com.alarm.broadcast_notification")) {
            Bundle extras = intent.getExtras();
            alarmContentText = extras.getString("alarmText");
            notificationType = (NotificationType) extras.getSerializable("notificationType");
            id = extras.getInt("id");
            //uri to sound file
            Uri sound = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + context.getPackageName() + "/" + R.raw.alarm);
            // Set the alarm here
        System.out.println("I the broadcast has been called with text " + alarmContentText);
//        NotificationCompat.Builder(Context context) has been deprecated. And we have to use the constructor which has the channelId parameter:
        notificationBuilder = buildNotification(context, notificationType);
//        now create intent to open app on notification tap
        Intent onNotificationTap = new Intent(context, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, onNotificationTap, PendingIntent.FLAG_UPDATE_CURRENT);
        notificationBuilder.setContentIntent(pendingIntent);
        notificationBuilder.setSound(sound);

        //for andriod 8 and above , you need to set notification channel
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            createChannels(context,sound);
        }

        //give each notification a different id so they can stand apart
        final int notificationId = (int) SystemClock.uptimeMillis();
        notificationManager.notify(notificationId, notificationBuilder.build());
    }
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    public void createChannels(Context context,Uri sound){
        AudioAttributes attributes = new AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                .build();
        if(notificationType == NotificationType.IDEAS) {
            //channel for all notification from ideas
            String ideaschannelId = "Channel for ideas";
            NotificationChannel ideasChannel = new NotificationChannel(
                    ideaschannelId,
                    "Ideas",
                    NotificationManager.IMPORTANCE_HIGH);
            ideasChannel.enableVibration(true);
            ideasChannel.setLightColor(0xFFb71c1c);
            ideasChannel.enableLights(true);
            ideasChannel.setSound(sound,attributes);
            ideasChannel.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
            getNotificationManager(context).createNotificationChannel(ideasChannel);
            notificationBuilder.setChannelId(ideaschannelId);
            System.out.print("ideas created"+notificationType);
        }else if(notificationType == NotificationType.SCHEDULE) {
            //channel for all notification from schedule
            String schedulechannelId = "Channel for schedules";
            NotificationChannel scheduleChannel = new NotificationChannel(
                    schedulechannelId,
                    "Schedules",
                    NotificationManager.IMPORTANCE_HIGH);
            scheduleChannel.enableVibration(true);
            scheduleChannel.setLightColor(0xFFb71c1c);
            scheduleChannel.enableLights(true);
            scheduleChannel.setSound(sound,attributes);
            scheduleChannel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC);
            getNotificationManager(context).createNotificationChannel(scheduleChannel);
            notificationBuilder.setChannelId(schedulechannelId);
            System.out.print(notificationType);
        }
    }

    public NotificationManager getNotificationManager(Context context) {
        //create a new notification manager if it does not already exist
        if(notificationManager == null) {
            notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        }
        return notificationManager;
    }

    public NotificationCompat.Builder buildNotification(Context context,NotificationType typeOfNotification){
        return new NotificationCompat.Builder(context,"channelId")
                .setContentTitle("Idealog")
                .setContentText(alarmContentText)
//        remeber to add set small icon of light bulb
                .setSmallIcon((typeOfNotification == NotificationType.IDEAS)?R.drawable.ic_ideas_notification:R.drawable.ic_schedule_notification)
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setOngoing(typeOfNotification == NotificationType.IDEAS)
                .setAutoCancel(true)
                //setting the lights for blinking led
                .setLights(0xFFb71c1c, 1000, 2000)
                .setLargeIcon(BitmapFactory.decodeResource(context.getResources(), R.mipmap.ic_launcher));
    }
}
