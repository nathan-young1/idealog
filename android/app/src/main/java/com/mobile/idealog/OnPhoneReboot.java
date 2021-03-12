package com.mobile.idealog;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class OnPhoneReboot extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        //implement the rescheduling of alarm after reading from sqlLite database here
        if (intent.getAction().equals("android.intent.action.BOOT_COMPLETED")) {
            // Set the alarm here
            //make set alarm and cancel alarm static so you can call it from here but you have to initilize alarm manager in it
        }
    }
}