package dataSyncronization;

import android.content.Context;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.firebase.FirebaseApp;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.functions.FirebaseFunctions;
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
        });
    }
}