package com.mobile.idealog;

import android.content.Context;
import android.view.View;

import androidx.annotation.NonNull;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.stream.Collectors;

import dataSyncronization.GoogleDrive;
import dataSyncronization.SynchronizationHandler;
import databaseModels.IdeaModel;
import databaseModels.Task;
import databaseModels.TaskList;
import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterFragmentActivity {
    public static Context applicationContext = null;
    final private String startAutoSyncMethod = "startAutoSync";
    final private String cancelAutoSyncMethod = "cancelAutoSync";
    final private String GET_LAST_SYNC_TIME_METHOD = "get_last_sync_time";
    final private String UPDATE_LAST_SYNC_TIME_METHOD = "update_last_sync_time";
    private static final String CHANNEL = "com.idealog.alarmServiceCaller";



    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL).setMethodCallHandler((call, result) -> {

            applicationContext = getApplicationContext();

            switch (call.method) {
                case startAutoSyncMethod:
                    SynchronizationHandler.START_AUTO_SYNC(applicationContext,result);
                    break;

                case cancelAutoSyncMethod:
                    SynchronizationHandler.CANCEL_AUTO_SYNC(applicationContext,result);
                    break;

                case GET_LAST_SYNC_TIME_METHOD:
                    result.success(IdealogDatabase.GetLastBackUpTime(getApplicationContext()));
                    break;
                case UPDATE_LAST_SYNC_TIME_METHOD:
                    result.success(IdealogDatabase.WriteLastSyncTime(getApplicationContext()));
                    break;
            }
        });
    }




    public static ArrayList<IdeaModel> allIdeasFromJson(String JsonString) throws JSONException {
        JSONArray jj = new JSONArray(JsonString);
        ArrayList<IdeaModel> allIdeas = new ArrayList<>();
        for(int i = 0; i < jj.length(); i++){

            JSONObject obj = jj.getJSONObject(i);
            IdeaModel idea = new IdeaModel(obj.getInt("ideaId"),obj.getString("ideaTitle"),obj.getString("moreDetails"), TaskList.FromJsonArray(obj.getJSONArray("uncompletedTasks")),TaskList.FromJsonArray(obj.getJSONArray("completedTasks")));
            System.out.println("ID: "+idea.ideaId);
            System.out.println("Title: "+idea.ideaTitle);
            System.out.println("MoreDetails: "+idea.moreDetails);
            System.out.println("CompletedTasks: "+idea.completedTasks.stream().map(Task::toMap).collect(Collectors.toList()));
            System.out.println("unCompletedTasks:  "+idea.uncompletedTasks.stream().map(Task::toMap).collect(Collectors.toList()));
            allIdeas.add(idea);
        }

        return allIdeas;
    }


}
