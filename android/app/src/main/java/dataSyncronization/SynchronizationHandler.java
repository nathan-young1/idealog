package dataSyncronization;

import android.content.Context;

import androidx.work.BackoffPolicy;
import androidx.work.Constraints;
import androidx.work.NetworkType;
import androidx.work.PeriodicWorkRequest;
import androidx.work.WorkManager;

import java.util.concurrent.TimeUnit;

import io.flutter.plugin.common.MethodChannel;

public class SynchronizationHandler {

    final static private String AutoSyncWorkRequestTag = "AutoSync";

    /**
     * This method gives the auto sync task to the work manager.
     */
    public static void START_AUTO_SYNC(Context context, MethodChannel.Result result){
        try {
            Constraints workRequestConstraints = new Constraints.Builder()
                    .setRequiredNetworkType(NetworkType.CONNECTED)
                    .build();

///        In case of error the backoff criteria for result.retry has been set to try again in the next 10 minutes

            PeriodicWorkRequest autoSyncWorkRequest = new PeriodicWorkRequest.Builder(GoogleDrive.class, 1, TimeUnit.DAYS)
                    .setConstraints(workRequestConstraints)
                    .setBackoffCriteria(BackoffPolicy.LINEAR, 10, TimeUnit.MINUTES)
                    .addTag(AutoSyncWorkRequestTag)
                    .build();

//        Add work request to work manager
            WorkManager
                    .getInstance(context)
                    .enqueue(autoSyncWorkRequest);
        } finally {
            result.success("Auto Sync Start Was Called");
        }
    }


    /**
     * This method cancels the auto sync task in the work manager.
     */
    public static void CANCEL_AUTO_SYNC(Context context,MethodChannel.Result result){
        try {
            WorkManager.getInstance(context).cancelAllWorkByTag(AutoSyncWorkRequestTag);
        } finally {
            result.success("Auto Sync Stop was called");
        }
    }

}
