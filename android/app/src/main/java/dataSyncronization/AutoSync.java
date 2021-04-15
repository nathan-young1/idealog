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

//        Get the user UID from firebase auth
            final String authUserUid = Authentication.googleAuth(applicationContext);

            Map<String, String> testData = new HashMap<String, String>();
            testData.put("first", "one");
            testData.put("second", "sec");
            testData.put("third", "thr");

//        for add test data;
            db.collection(authUserUid).add(testData)
                    .addOnSuccessListener(new OnSuccessListener<DocumentReference>() {
                        @Override
                        public void onSuccess(DocumentReference documentReference) {
                            Toast.makeText(applicationContext, documentReference.getId(), Toast.LENGTH_LONG);
                        }
                    })
                    .addOnFailureListener(new OnFailureListener() {
                        @Override
                        public void onFailure(@NonNull Exception e) {
                            Toast.makeText(applicationContext, "There was a failure writing to database", Toast.LENGTH_LONG);
                        }
                    });

//        for reading test data from firebase
            db.collection(authUserUid).get()
                    .addOnCompleteListener(new OnCompleteListener<QuerySnapshot>() {
                        @Override
                        public void onComplete(@NonNull Task<QuerySnapshot> task) {
                            if (task.isSuccessful()) {
                                for (QueryDocumentSnapshot snapshot : task.getResult()) {
                                    Toast.makeText(applicationContext, snapshot.getData().toString(), Toast.LENGTH_LONG);
                                }
                            } else {
                                Toast.makeText(applicationContext, "error getting documents", Toast.LENGTH_LONG);
                            }
                        }
                    });
            return Result.success();
        }catch (Exception e){
//            either returning retry or failure in case of constant exception
            return Result.retry();
        }
    }
}
