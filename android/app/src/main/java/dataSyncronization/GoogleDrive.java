package dataSyncronization;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.work.Worker;
import androidx.work.WorkerParameters;

import com.google.api.client.http.FileContent;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.model.File;
import com.google.api.services.drive.model.FileList;
import com.mobile.idealog.IdealogDatabase;

import org.json.JSONArray;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import databaseModels.IdeaModel;

import static com.google.api.client.extensions.android.http.AndroidHttp.newCompatibleTransport;


public class GoogleDrive extends Worker {

    private static Context applicationContext;
    private static final String APPLICATION_NAME = "Idealog";
    private static final String DRIVE_SPACE = "appDataFolder";
    private static final String FILE_NAME = "Idealog.json";
    private File _lastBackupFileIfExists;

    Drive drive;

    public GoogleDrive(@NonNull Context context, @NonNull WorkerParameters workerParams) {
        super(context, workerParams);
        applicationContext = context;
        drive = new Drive.Builder(newCompatibleTransport(), new GsonFactory(), Authentication.authenticateUser(applicationContext))
                .setApplicationName(APPLICATION_NAME)
                .build();
    }


    @NonNull
    @Override
    public Result doWork() {
        /// Only auto sync when the user is subscribedToPremium
        if(IdealogDatabase.UserIsSubscribedToPremium(applicationContext)) {
            try {
                _getLastBackupFileIfExists();
                uploadToDrive(applicationContext);
                return Result.success();
            } catch (IOException e) {
                e.printStackTrace();
                return Result.failure();
            }
        } else return Result.success();
    }



    /**
     * This method gets all the ideas in the database parses it to a json file and then uploads it to the user's google drive.
     * @param context : The application's context
     * @throws IOException : A File exception may occur while writing json to a file
     */
    public void uploadToDrive(Context context) throws IOException {

//      If a last backup file exists then this operation is an update.
        boolean isUpdate = _lastBackupFileIfExists != null;

        // The metadata request file.
        File metadataFile = new File()
                .setName(FILE_NAME)
                .setParents(Collections.singletonList(DRIVE_SPACE));

        java.io.File jsonFile = new java.io.File(context.getCacheDir(),FILE_NAME);
        String jsonString = AllIdeasToJson(context);

//      Created a file writer to write the json string to the temporary file.
        FileWriter writer = new FileWriter(jsonFile);
        writer.write(jsonString);


//      Release the file writer resources.
        writer.close();


//      Convert the jsonFile to a driveMediaContent.
        FileContent mediaContent = new FileContent("application/json", jsonFile);

        if(isUpdate){
//          You cannot edit the parents on an update so i am setting it to null, before updating it.
            metadataFile.setParents(null);
            drive.files().update(_lastBackupFileIfExists.getId(),metadataFile, mediaContent).execute();
        }else {
//          Create the file in google drive.
            drive.files().create(metadataFile, mediaContent).execute();
        }

        IdealogDatabase.WriteLastSyncTime(context);

    }


    /**
     * Set the last backup file if any exists.
     */
    private void _getLastBackupFileIfExists() throws IOException {
        FileList result = drive.files().list()
                    .setSpaces(DRIVE_SPACE)
                    .execute();

        List<File> files = result.getFiles();
        if (files == null || files.isEmpty()) System.out.println("No files found.");
         else _lastBackupFileIfExists = files.get(0);

    }

    public static String AllIdeasToJson(Context context){
        IdealogDatabase sqlDbForIdealogDb = new IdealogDatabase(context,null,null,1);

        List allIdeas = sqlDbForIdealogDb.readAllIdeasInDb().stream().map(IdeaModel::toMap).collect(Collectors.toList());


        JSONArray jsonArray = new JSONArray(allIdeas);

        return jsonArray.toString();
    }

}
