package com.mobile.idealog;

import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.fragment.app.FragmentActivity;
import androidx.work.BackoffPolicy;
import androidx.work.Constraints;
import androidx.work.ExistingWorkPolicy;
import androidx.work.NetworkType;
import androidx.work.OneTimeWorkRequest;
import androidx.work.Operation;
import androidx.work.PeriodicWorkRequest;
import androidx.work.WorkInfo;
import androidx.work.WorkManager;

import com.google.common.util.concurrent.ListenableFuture;

import dataSyncronization.AutoSync;
import dataSyncronization.SyncNow;
import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import java.util.concurrent.Executor;
import java.util.concurrent.TimeUnit;

public class MainActivity extends FlutterFragmentActivity {
    final private String AutoSyncWorkRequestTag = "AutoSync";
    final private String SyncNowWorkRequestTag = "SyncNow";
    final private String startAutoSyncMethod = "startAutoSync";
    final private String cancelAutoSyncMethod = "cancelAutoSync";
    final private String syncNowMethod = "syncNow";
    private static final String CHANNEL = "com.idealog.alarmServiceCaller";

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
                }else  if(call.method.equals(syncNowMethod)){
                    syncNow(result);
                }
            }
        });
    }


//    work manager code added below
    public void startAutoSync(){
        Constraints workRequestConstraints = new Constraints.Builder()
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .build();

//        do the periodic work every 2 hours if there is internet connection
//        reduce the time later, though The interval period is defined as the minimum time between repetitions.
//        The exact time that the worker is going to be executed depends on the constraints that you are using in your WorkRequest object
//        and on the optimizations performed by the system.

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
//        cancel the autoSync work request by the tag
        WorkManager.getInstance(this).cancelAllWorkByTag(AutoSyncWorkRequestTag);
    }


    public void syncNow(MethodChannel.Result result){
        Constraints workRequestConstraints = new Constraints.Builder()
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .build();


        OneTimeWorkRequest syncNowWorkRequest = new OneTimeWorkRequest.Builder(SyncNow.class)
                .setConstraints(workRequestConstraints)
                .addTag(SyncNowWorkRequestTag)
                .build();


        WorkManager workManagerInstance = WorkManager.getInstance(this);

        workManagerInstance.enqueueUniqueWork(SyncNowWorkRequestTag, ExistingWorkPolicy.APPEND_OR_REPLACE,syncNowWorkRequest);

        workManagerInstance
                .getWorkInfoByIdLiveData(syncNowWorkRequest.getId())
                .observe(this, workInfo -> {
                    switch (workInfo.getState()){
                        case SUCCEEDED:
                            result.success("Success");
                            break;
                        case FAILED:
                            result.error("Failed","Failed",null);
                            break;
                    }
                });
    }
}
