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
    final private String SET_PREMIUM_EXPIRE_DATE = "set_premium_expire_date";
    final private String GET_USER_IS_PREMIUM = "get_user_is_premium";
    private static final String CHANNEL = "com.idealog.alarmServiceCaller";



    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL).setMethodCallHandler((call, result) -> {

            applicationContext = getApplicationContext();

            switch (call.method) {
                case startAutoSyncMethod:
                    SynchronizationHandler.START_AUTO_SYNC(applicationContext);
                    result.success("Auto Sync Start Was Called");
                    break;

                case cancelAutoSyncMethod:
                    SynchronizationHandler.CANCEL_AUTO_SYNC(applicationContext);
                    result.success("Auto Sync Stop was called");
                    break;

                case GET_LAST_SYNC_TIME_METHOD:
                    result.success(IdealogDatabase.GetLastBackUpTime(getApplicationContext()));
                    break;
                case UPDATE_LAST_SYNC_TIME_METHOD:
                    result.success(IdealogDatabase.WriteLastSyncTime(getApplicationContext()));
                    break;

                case SET_PREMIUM_EXPIRE_DATE:
                    // The expiration date gotten from dart code in string format.
                    String expirationDateInMilliseconds = call.argument("set_premium_expire_date");
                    result.success(IdealogDatabase.setExpirationDateForPremiumSubscription(expirationDateInMilliseconds, applicationContext));
                    break;

                case GET_USER_IS_PREMIUM:
                    result.success(IdealogDatabase.UserIsSubscribedToPremium(applicationContext));
                    break;

            }
        });
    }

}
