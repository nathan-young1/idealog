package dataSyncronization;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.work.Worker;
import androidx.work.WorkerParameters;

public class AutoSync extends Worker {
    Context applicationContext;

    public AutoSync(@NonNull Context context, @NonNull WorkerParameters workerParams) {
        super(context, workerParams);
        applicationContext = context;
    }

    @NonNull
    @Override
    public Result doWork() {
        try {
            SynchronizationHandler.synchronize(applicationContext);
            return Result.success();

        }catch (Exception e){
//            either returning retry or failure in case of constant exception
            return Result.retry();
        }
    }
}
