package dataSyncronization;

import android.content.Context;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.work.Worker;
import androidx.work.WorkerParameters;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.FirebaseApp;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QueryDocumentSnapshot;
import com.google.firebase.firestore.QuerySnapshot;
import com.google.firebase.functions.FirebaseFunctions;
import com.mobile.idealog.AnalyticsDatabase;
import com.mobile.idealog.IdealogDatabase;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import firebaseServices.Authentication;

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

            FirebaseApp.initializeApp(this.applicationContext);
            FirebaseFirestore db = FirebaseFirestore.getInstance();
            FirebaseFunctions functions = FirebaseFunctions.getInstance();

//        Get the user UID from firebase auth
            final String authUserUid = Authentication.googleAuth(applicationContext);

            IdealogDatabase sqlDbForIdealogDb = new IdealogDatabase(applicationContext,null,null,1);
//            call the delete function first
            functions.getHttpsCallable("deleteFormerData").call().addOnCompleteListener(new OnCompleteListener() {
                @Override
                public void onComplete(@NonNull Task task) {
            sqlDbForIdealogDb.readFromDbForAutoSync().forEach((idea)->{
                db.collection(authUserUid).document("Database").collection("Ideas").document(String.valueOf(idea.uniqueId)).set(idea);
            });

                //            open the database with the analytics table name
                AnalyticsDatabase sqlDbForAnalytics = new AnalyticsDatabase(applicationContext,null,null,1);
                sqlDbForAnalytics.readAnalyticsForAutoSync().forEach((analyticData)->{
                    int month = analyticData.date.get(Calendar.MONTH);
                    int activeDay = analyticData.date.get(Calendar.DAY_OF_MONTH);

                db.collection(authUserUid).document("Analytics").collection(String.valueOf(month)).document(String.valueOf(activeDay)).set(analyticData);
            });
                }
            });


            return Result.success();
        }catch (Exception e){
//            either returning retry or failure in case of constant exception
            return Result.retry();
        }
    }
}
