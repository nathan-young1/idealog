package dataSyncronization;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.work.Worker;
import androidx.work.WorkerParameters;

import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.api.services.drive.DriveScopes;
import com.google.api.client.googleapis.extensions.android.gms.auth.GoogleAccountCredential;
import com.mobile.idealog.IdealogDatabase;

import org.json.JSONArray;
import org.json.JSONException;

import java.util.Collections;
import java.util.Map;

import databaseModels.IdeaModel;

public class SynchronizationHandler extends Worker {

    Context applicationContext;

    public SynchronizationHandler(@NonNull Context context, @NonNull WorkerParameters workerParams) {
        super(context, workerParams);
        applicationContext = context;
    }

    @NonNull
    @Override
    public Result doWork() {
//        try {
//            SynchronizationHandler.synchronize(applicationContext);
//            return Result.success();
//
//        }catch (Exception e){
////            either returning retry or failure in case of constant exception
//            return Result.retry();
//        }
        return null;
    }

    public static GoogleAccountCredential authenticateUser(Context context){
        GoogleSignInAccount currentUser = GoogleSignIn.getLastSignedInAccount(context);

        GoogleAccountCredential credential =
                GoogleAccountCredential.usingOAuth2(
                        context, Collections.singleton(DriveScopes.DRIVE_APPDATA));

        credential.setSelectedAccount(currentUser.getAccount());

        return credential;
    }

    public static void synchronize(Context applicationContext) throws JSONException {


        IdealogDatabase sqlDbForIdealogDb = new IdealogDatabase(applicationContext,null,null,1);

            Map[] allIdeas = (Map[]) sqlDbForIdealogDb.readAllIdeasInDb().stream().map(IdeaModel::toMap).toArray();
            JSONArray jsonArray = new JSONArray();
            jsonArray.put(allIdeas);
            System.out.println(jsonArray.toString());
            String output = jsonArray.toString();
            JSONArray jj = new JSONArray(output);
            System.out.println(jj.toString());

            IdealogDatabase.WriteLastSyncTime(applicationContext);



    }

}