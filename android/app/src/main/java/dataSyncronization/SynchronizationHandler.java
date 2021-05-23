package dataSyncronization;

import android.content.Context;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.firebase.FirebaseApp;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.functions.FirebaseFunctions;
import com.mobile.idealog.AnalyticsDatabase;
import com.mobile.idealog.IdealogDatabase;

import firebaseServices.Authentication;

public class SynchronizationHandler {

    public static void synchronize(Context applicationContext){

        FirebaseApp.initializeApp(applicationContext);
        FirebaseFirestore db = FirebaseFirestore.getInstance();
        FirebaseFunctions functions = FirebaseFunctions.getInstance();

//        Get the user UID from firebase auth
        final String authUserUid = Authentication.googleAuth(applicationContext);

        IdealogDatabase sqlDbForIdealogDb = new IdealogDatabase(applicationContext,null,null,1);
//            call the delete function first
        functions.getHttpsCallable("deleteFormerData").call().addOnCompleteListener(task -> {
            sqlDbForIdealogDb.readFromDbForAutoSync().forEach((idea)-> db.collection(authUserUid).document("Database").collection("Ideas").document(String.valueOf(idea.uniqueId)).set(idea));

            //            open the database with the analytics table name
            AnalyticsDatabase sqlDbForAnalytics = new AnalyticsDatabase(applicationContext,null,null,1);
            sqlDbForAnalytics.readAnalyticsForAutoSync().forEach((analyticData)->{
                int month = analyticData.customDateObject.get("Month");
                int activeDay = analyticData.customDateObject.get("Date");

                db.collection(authUserUid).document("Analytics").collection(String.valueOf(month)).document(String.valueOf(activeDay)).set(analyticData);
            });
        });
    }
}