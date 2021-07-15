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
import com.mobile.idealog.MainActivity;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

import static com.google.api.client.extensions.android.http.AndroidHttp.newCompatibleTransport;

public class GoogleDrive extends Worker {

    private static Context applicationContext;
    private static final String APPLICATION_NAME = "Idealog";
    private static final String DRIVE_SPACE = "appDataFolder";
    private static String FILE_NAME = "Idealog.json";
    private File _lastBackupFileIfExists;

    Drive drive;

    public GoogleDrive(@NonNull Context context, @NonNull WorkerParameters workerParams) {
        super(context, workerParams);
        applicationContext = context;
        drive = new Drive.Builder(newCompatibleTransport(), new GsonFactory(), SynchronizationHandler.authenticateUser(applicationContext))
                .setApplicationName(APPLICATION_NAME)
                .build();
    }


    @Override
    public Result doWork() {
        try {
            _getLastBackupFileIfExists();
            uploadToDrive(applicationContext);
            return Result.success();
        } catch (IOException e) {
            e.printStackTrace();
            return Result.failure();
        }
    }



    /**
     * This method gets all the ideas in the database parses it to a json file and then uploads it to the user's google drive.
     * @param context
     * @throws IOException
     */
    public void uploadToDrive(Context context) throws IOException {

        boolean isUpdate = _lastBackupFileIfExists != null;

        // The metadata request file.
        File metadataFile = new File()
                .setName(FILE_NAME)
                .setParents(Collections.singletonList(DRIVE_SPACE));

        java.io.File jsonFile = new java.io.File(context.getCacheDir(),FILE_NAME);
        String jsonString = MainActivity.allIdeasToJson(context);

//      Created a buffered writer to write the json string to the temporary file.
        BufferedWriter writer = new BufferedWriter(new FileWriter(jsonFile));
        writer.write(jsonString);

//      Release the buffered writer resources.
        writer.close();

//      Convert the jsonFile to a driveMediaContent.
        FileContent mediaContent = new FileContent("application/json", jsonFile);

        if(isUpdate){
            metadataFile.setParents(null);
            drive.files().update(_lastBackupFileIfExists.getId(),metadataFile, mediaContent).execute();
        }else {
//      create the file in google drive.
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

}
