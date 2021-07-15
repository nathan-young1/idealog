package dataSyncronization;

import android.content.Context;

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

public class Authentication{

    public static GoogleAccountCredential authenticateUser(Context context){
        GoogleSignInAccount currentUser = GoogleSignIn.getLastSignedInAccount(context);

        GoogleAccountCredential credential =
                GoogleAccountCredential.usingOAuth2(
                        context, Collections.singleton(DriveScopes.DRIVE_APPDATA));

        credential.setSelectedAccount(currentUser.getAccount());

        return credential;
    }

}