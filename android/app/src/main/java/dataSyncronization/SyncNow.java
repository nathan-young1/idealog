package dataSyncronization;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.work.Worker;
import androidx.work.WorkerParameters;

public class SyncNow extends Worker {
    Context applicationContext;
    public SyncNow(@NonNull Context context, @NonNull WorkerParameters workerParams) {
        super(context, workerParams);
        applicationContext = context;
    }

    @NonNull
    @Override
    public Result doWork() {
        try{
            SynchronizationHandler.synchronize(applicationContext);
            return Result.success();

        }catch (Exception e){
            return  Result.failure();
        }

    }
}
