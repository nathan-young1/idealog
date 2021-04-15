package firebaseServices;

import android.content.Context;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.auth.GoogleAuthProvider;
import com.mobile.idealog.R;

public class Authentication {

    static String userUid = "";

    public static String googleAuth(Context context){
        GoogleSignInAccount account = GoogleSignIn.getLastSignedInAccount(context);
//        if the user has not previously signed in ,the account will be null. Meaning the user has not paid for the premium app.

        FirebaseAuth firebaseAuth = FirebaseAuth.getInstance();
//      Checking if user is signed in already
        FirebaseUser currentUser = firebaseAuth.getCurrentUser();

        if(currentUser == null){
//          The user is not signed in currently
            AuthCredential googleCredential = GoogleAuthProvider.getCredential(account.getIdToken(),null);

            firebaseAuth.signInWithCredential(googleCredential).addOnCompleteListener(new OnCompleteListener<AuthResult>() {
                @Override
                public void onComplete(@NonNull Task<AuthResult> task) {
                    if (task.isSuccessful()) {
                        Toast.makeText(context, "signInWithCredential:success",Toast.LENGTH_LONG);
                        FirebaseUser user = firebaseAuth.getCurrentUser();
                        userUid = user.getUid();
                    } else {
                        Toast.makeText(context,"signInWithCredential:failure"+task.getException(), Toast.LENGTH_LONG);
                    }
                }
            });

        }else{
//          When the user is currently signed in
            userUid = currentUser.getUid();
        }

        return userUid;
    }
}
