package com.android.goodcitizen;

import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.IBinder;
import android.util.Log;

public class LocationUpdatesService extends Service {
    private final BroadcastReceiver locationReceiver = new LocationReceiver();

    @Override
    public void onCreate() {
        super.onCreate();
        IntentFilter filter = new IntentFilter("com.almoullim.background_location.action.PROCESS_UPDATES");
        registerReceiver(locationReceiver, filter, Context.RECEIVER_EXPORTED);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        // Your service code
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        unregisterReceiver(locationReceiver);
        super.onDestroy();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
