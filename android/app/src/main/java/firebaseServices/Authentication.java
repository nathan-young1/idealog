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

    public static String googleAuth(Context context){
        String userUid = "";
        GoogleSignInAccount account = GoogleSignIn.getLastSignedInAccount(context);
//        if the user has not previously signed in ,the account will be null. So then and only then will he be signed in.
        if(account == null) {
//        Do most of my authentication from flutter, and just use the data here
//      But i am not supposed to do google sign in from here that should be done from the flutter app
//      So the user can only access it on premium account , just use the data provided to this account object of auto sync with firebase
//        Created a google sign-in client object to store the date provided by google
            GoogleSignInClient mGoogleSignInClient;
            GoogleSignInOptions gso = new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                    .requestIdToken(String.valueOf(R.string.default_web_client_id))
                    .requestEmail()
                    .build();

            mGoogleSignInClient = GoogleSignIn.getClient(context, gso);
        }else {
//            return the data in the account object
//            make this idtoken available to the entire class later
            account.getIdToken();
        }

//        Get firebase auth instance in other to make authenticated firestore crud operations in background
//        make firebase auth private
        FirebaseAuth firebaseAuth;
        firebaseAuth = FirebaseAuth.getInstance();
//        when intializing activity check if user is signed in already
        FirebaseUser currentUser = firebaseAuth.getCurrentUser();
//       current user should be non-null if the person is signed in currently
        if(currentUser == null){
//            if the user is not currently signed in
            AuthCredential googleCrendential = GoogleAuthProvider.getCredential(account.getIdToken(),null);
            firebaseAuth.signInWithCredential(googleCrendential).addOnCompleteListener(new OnCompleteListener<AuthResult>() {
                @Override
                public void onComplete(@NonNull Task<AuthResult> task) {
                    if (task.isSuccessful()) {
                        // Sign in success, update UI with the signed-in user's information
                        Toast.makeText(context, "signInWithCredential:success",Toast.LENGTH_LONG);
                        FirebaseUser user = firebaseAuth.getCurrentUser();
//                        updateUI(user);
//                        make firebaseUser accessible to all the class so i can get userUid
//                        userUid = user.getUid();
                    } else {
                        // If sign in fails, display a message to the user.
                        Toast.makeText(context,"signInWithCredential:failure"+task.getException(), Toast.LENGTH_LONG);
//                        updateUI(null);
                    }
                }
            });
        }else{
//            when user is currently signed in
            userUid = currentUser.getUid();
        }

//        Remeber to signout just do
//        FirebaseAuth.getInstance().signOut();
//        Although we won't need it cause all authentication should be done from the flutter app
        return userUid;
    }
}
