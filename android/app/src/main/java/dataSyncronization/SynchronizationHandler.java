package dataSyncronization;

import android.content.Context;
import android.content.SharedPreferences;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.firebase.FirebaseApp;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.functions.FirebaseFunctions;
import com.google.type.DateTime;
import com.mobile.idealog.IdealogDatabase;

import java.util.Calendar;

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
        });

        DateTime now = DateTime.getDefaultInstance();
        int year = now.getYear();
        int month = now.getMonth();
        int day = now.getDay();

        System.out.println("The last sync time is now: "+year+":"+month+":"+day);
        SharedPreferences pref = applicationContext.getSharedPreferences("FlutterSharedPreferences",applicationContext.MODE_PRIVATE);
        pref.edit().putString("flutter.LastSync",year+":"+month+":"+day);

//        To get back the sharedPreference
//        SharedPreferences sp = getSharedPreferences(PREFS_GAME ,Context.MODE_PRIVATE);
//        int sc  = sp.getInt(GAME_SCORE,0);
    }
}