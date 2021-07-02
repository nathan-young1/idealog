package com.mobile.idealog;

import android.view.View;

import androidx.annotation.NonNull;
import androidx.work.BackoffPolicy;
import androidx.work.Constraints;
import androidx.work.NetworkType;
import androidx.work.PeriodicWorkRequest;
import androidx.work.WorkManager;

import java.util.concurrent.TimeUnit;

import dataSyncronization.AutoSync;
import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterFragmentActivity {
    final private String AutoSyncWorkRequestTag = "AutoSync";
    final private String startAutoSyncMethod = "startAutoSync";
    final private String cancelAutoSyncMethod = "cancelAutoSync";
    final private String GET_LAST_SYNC_TIME_METHOD = "get_last_sync_time";
    final private String UPDATE_LAST_SYNC_TIME_METHOD = "update_last_sync_time";
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
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL).setMethodCallHandler((call, result) -> {

            switch (call.method) {
                case startAutoSyncMethod:
                    startAutoSync();
                    result.success("Auto Sync Started");
                    break;
                case cancelAutoSyncMethod:
                    cancelAutoSync();
                    result.success("Auto Sync has been canceled");
                    break;
                case GET_LAST_SYNC_TIME_METHOD:
                    result.success(IdealogDatabase.GetLastBackUpTime(getApplicationContext()));
                    break;
                case UPDATE_LAST_SYNC_TIME_METHOD:
                    result.success(IdealogDatabase.WriteLastSyncTime(getApplicationContext()));
                    break;
            }
        });
    }


    /**
     * This method gives the auto sync task to the work manager.
     */
    public void startAutoSync(){
        Constraints workRequestConstraints = new Constraints.Builder()
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .build();


//        In case of error the backoff criteria for result.retry has been set to try again in the next 10 minutes

        PeriodicWorkRequest autoSyncWorkRequest = new PeriodicWorkRequest.Builder(AutoSync.class,1, TimeUnit.DAYS)
                .setConstraints(workRequestConstraints)
                .setBackoffCriteria(BackoffPolicy.LINEAR,10,TimeUnit.MINUTES)
                .addTag(AutoSyncWorkRequestTag)
                .build();

//        Add work request to work manager
        WorkManager
                .getInstance(this)
                .enqueue(autoSyncWorkRequest);

    }

    /**
     * This method cancels the auto sync task in the work manager.
     */
    public void cancelAutoSync(){
        WorkManager.getInstance(this).cancelAllWorkByTag(AutoSyncWorkRequestTag);
    }


}
