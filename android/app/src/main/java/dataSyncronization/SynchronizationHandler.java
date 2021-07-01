package dataSyncronization;

import android.content.Context;
import android.content.SharedPreferences;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.firebase.FirebaseApp;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.functions.FirebaseFunctions;
import com.google.type.DateTime;
import com.mobile.idealog.IdealogDatabase;

import java.util.ArrayList;
import java.util.Calendar;

import firebaseServices.Authentication;

public class SynchronizationHandler {

    public static void synchronize(Context applicationContext){
        final String[] cloudFirebasePath = {"Database","Ideas"};

        FirebaseApp.initializeApp(applicationContext);
        FirebaseFirestore db = FirebaseFirestore.getInstance();
        FirebaseFunctions functions = FirebaseFunctions.getInstance();

//        Get the user UID from firebase auth
        final String authUserUid = Authentication.googleAuth(applicationContext);

        IdealogDatabase sqlDbForIdealogDb = new IdealogDatabase(applicationContext,null,null,1);

//            call the delete function first
        functions.getHttpsCallable("deleteFormerData").call().addOnSuccessListener(task -> {
            sqlDbForIdealogDb.readAllIdeasInDb().forEach((idea)-> db.collection(authUserUid).document(cloudFirebasePath[0]).collection(cloudFirebasePath[1]).document(String.valueOf(idea.IdeaId)).set(idea));
        });

        Calendar now = Calendar.getInstance();
        SharedPreferences pref = applicationContext.getSharedPreferences("BackUp",applicationContext.MODE_PRIVATE);
        Toast.makeText(applicationContext,"The data has been auto synced",Toast.LENGTH_LONG);
        pref.edit().putString("lastBackup",String.valueOf(now.getTimeInMillis()));
    }
}