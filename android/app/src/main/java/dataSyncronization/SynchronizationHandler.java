package dataSyncronization;

import android.content.Context;

import com.google.firebase.FirebaseApp;
import com.mobile.idealog.IdealogDatabase;

import org.json.JSONArray;
import org.json.JSONException;

import java.util.Map;

import databaseModels.IdeaModel;

public class SynchronizationHandler {

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