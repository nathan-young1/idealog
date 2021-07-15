package dataSyncronization;

import android.content.Context;

import com.google.api.client.json.gson.GsonFactory;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.model.File;
import com.google.api.services.drive.model.FileList;
import com.mobile.idealog.MainActivity;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.List;

import static com.google.api.client.extensions.android.http.AndroidHttp.newCompatibleTransport;

public class GoogleDrive implements Runnable{

    private static final String APPLICATION_NAME = "Idealog";

    @Override
    public void run() {
        // Build a new authorized API client service.
        System.out.println("Started the main in the drive");
        Drive service = new Drive.Builder(newCompatibleTransport(), new GsonFactory(), SynchronizationHandler.authenticateUser(MainActivity.applicationContext))
                .setApplicationName(APPLICATION_NAME)
                .build();

        // Print the names and IDs for up to 10 files.
        FileList result = null;
        try {
            result = service.files().list()
                    .setSpaces("appDataFolder")
                    .execute();
        } catch (IOException e) {
            e.printStackTrace();
        }

        List<File> files = result.getFiles();
        if (files == null || files.isEmpty()) {
            System.out.println("No files found.");
        } else {
            System.out.println("Files:");
            for (File file : files) {
                System.out.printf("%s (%s)\n", file.getName(), file.getId());
            }
        }
    }
}
