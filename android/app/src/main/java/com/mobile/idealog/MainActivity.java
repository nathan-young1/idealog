package com.mobile.idealog;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.view.View;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.work.BackoffPolicy;
import androidx.work.Constraints;
import androidx.work.NetworkType;
import androidx.work.PeriodicWorkRequest;
import androidx.work.WorkManager;

import dataSyncronization.AutoSync;
import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import java.util.concurrent.TimeUnit;

public class MainActivity extends FlutterFragmentActivity {
    final private String AutoSyncWorkRequestTag = "AutoSync";
    final private String startAutoSyncMethod = "startAutoSync";
    final private String cancelAutoSyncMethod = "cancelAutoSync";
    final private String lastBackUpMethod = "lastBackup";
    private static final String CHANNEL = "com.idealog.alarmServiceCaller";

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        if (hasFocus) hideSystemUI();

    }


    private void hideSystemUI() {
        View decorView = getWindow().getDecorView();
        decorView.setSystemUiVisibility(
                View.SYSTEM_UI_FLAG_IMMERSIVE
                        // Set the content to appear under the system bars so that the
                        // content doesn't resize when the system bars hide and show.
                        | View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                        | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                        // Hide the nav bar and status bar
                        | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_FULLSCREEN
                        | View.SYSTEM_UI_FLAG_IMMERSIVE);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                if(call.method.equals(startAutoSyncMethod)){
                    startAutoSync();
                    result.success("Auto Sync Started");
                }else if(call.method.equals(cancelAutoSyncMethod)){
                    cancelAutoSync();
                    result.success("Auto Sync has been canceled");
                }else if(call.method.equals(lastBackUpMethod)){
                    result.success(getLastBackUpTime());
                }
            }
        });
    }


//    work manager code added below
    public void startAutoSync(){
        Constraints workRequestConstraints = new Constraints.Builder()
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .build();


//        do the periodic work every 24 hours if there is internet connection
//        reduce the time later, though The interval period is defined as the minimum time between repetitions.

//        incase of error the backoff criteria for result.retry has been set to try again in the next 10 minutes
//        I am changing time unit to minutes for testing purposes

        PeriodicWorkRequest autoSyncWorkRequest = new PeriodicWorkRequest.Builder(AutoSync.class,2, TimeUnit.MINUTES)
                .setConstraints(workRequestConstraints)
                .setBackoffCriteria(BackoffPolicy.LINEAR,10,TimeUnit.MINUTES)
                .addTag(AutoSyncWorkRequestTag)
                .build();

//        Add work request to work manager
        WorkManager
                .getInstance(this)
                .enqueue(autoSyncWorkRequest);

    }

    public void cancelAutoSync(){
        WorkManager.getInstance(this).cancelAllWorkByTag(AutoSyncWorkRequestTag);
    }

    public String getLastBackUpTime(){
        SharedPreferences pref = this.getSharedPreferences("BackUp",this.MODE_PRIVATE);
        return pref.getString("lastBackup","");
    }
}
