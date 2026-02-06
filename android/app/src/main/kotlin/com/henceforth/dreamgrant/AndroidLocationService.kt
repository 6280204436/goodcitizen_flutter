package com.pr.goodcitizen

import android.app.*
import android.content.Context
import android.content.Intent
import android.os.*
import android.util.Log
import io.socket.client.IO
import io.socket.client.Socket
import org.json.JSONObject
import androidx.core.app.NotificationCompat
import com.google.android.gms.location.*
import java.text.SimpleDateFormat
import java.util.*

class AndroidLocationService : Service() {

    private var token: String = ""
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationCallback: LocationCallback
    private lateinit var wakeLock: PowerManager.WakeLock
    private lateinit var mSocket: Socket
    private var lastKnownLocation: android.location.Location? = null
    private val MIN_DISTANCE_FOR_UPDATE = 2.0 // meters - adjust as needed

    override fun onCreate() {
        super.onCreate()
        Log.d("LocationService", "Service onCreate called")

        // Setup fused location client and callback
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) {
                super.onLocationResult(locationResult)
                locationResult.lastLocation?.let {
                    logLocation(it)
                }
            }
        }

        // Acquire wake lock
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "LocationService::WakeLock")
        wakeLock.acquire(6 * 60 * 60 * 1000L) // 6 hours
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        token = intent?.getStringExtra("token") ?: ""
        Log.d("ServiceToken", "Received token from intent: $token")

        if (token.isEmpty()) {
            Log.e("ServiceToken", "Token is empty. Cannot start service properly.")
            stopSelf()
            return START_NOT_STICKY
        }

        setupSocketWithToken(token)
        startForegroundService()
        requestLocationUpdates()
        return START_STICKY
    }

    companion object {
        // Stop Service Method (Called from Flutter)
        fun stopService(context: Context) {
            val stopIntent = Intent(context, AndroidLocationService::class.java).apply {
                action = "STOP"
            }
            context.startService(stopIntent)
        }
    }

    private fun setupSocketWithToken(token: String) {
        try {
            Log.d("SocketIO", "Setting up socket with token")

            val opts = IO.Options().apply {
                forceNew = true
                reconnection = true
                transports = arrayOf("websocket")

                val headers = mutableMapOf<String, List<String>>()
                headers["token"] = listOf(token)
                this.extraHeaders = headers

                val query = mutableMapOf<String, String>()
                query["token"] = "Bearer $token"
                this.query = query.entries.joinToString("&") { "${it.key}=${it.value}" }

                val authMap = mutableMapOf<String, String>()
                authMap["authtoken"] = token
                this.auth = authMap
            }

            mSocket = IO.socket("https://api.agoodcitizen.in", opts)
            mSocket.connect()

            mSocket.on(Socket.EVENT_CONNECT) {
                Log.d("SocketIO", "Socket connected ✅")
            }

            mSocket.on(Socket.EVENT_CONNECT_ERROR) { args ->
                val error = args.firstOrNull()
                Log.e("SocketIO", "Connect error: $error")
                if (error is Exception) {
                    error.printStackTrace()
                    Log.e("SocketIO", "Detailed error: ${error.localizedMessage}")
                    Log.e("SocketIO", "Cause: ${error.cause}")
                }
            }

            mSocket.on(Socket.EVENT_DISCONNECT) {
                Log.d("SocketIO", "Socket disconnected ❌")
            }

            Log.d("SocketIO", "Socket initialization completed")
        } catch (e: Exception) {
            Log.e("SocketIO", "Socket error: ${e.message}")
            e.printStackTrace()
        }
    }

    private fun startForegroundService() {
        val channelId = "com.android.goodcitizen.LOCATION_SERVICE"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(channelId, "Location Service", NotificationManager.IMPORTANCE_LOW)
            getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
        }

        val notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle("Location Tracking Active")
            .setContentText("Your location is being logged.")
            .setSmallIcon(R.drawable.ic_notification)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setOngoing(true)
            .build()

        startForeground(1, notification)
        Log.d("LocationService", "Started as foreground service")
    }

    private fun requestLocationUpdates() {
        val locationRequest = LocationRequest.Builder(Priority.PRIORITY_HIGH_ACCURACY, 1000)
            .setMinUpdateIntervalMillis(1000)
            .build()

        try {
            fusedLocationClient.requestLocationUpdates(locationRequest, locationCallback, Looper.getMainLooper())
            Log.d("LocationService", "Started location updates every second.")
        } catch (e: SecurityException) {
            Log.e("LocationService", "Missing location permission: ${e.message}")
        }
    }

    private fun logLocation(location: android.location.Location) {
        // Check if this is the first location or if we've moved enough to justify an update
        if (lastKnownLocation == null || calculateDistance(lastKnownLocation!!, location) >= MIN_DISTANCE_FOR_UPDATE) {
            val timeFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())
            val timeString = timeFormat.format(Date())

            val locationData = JSONObject().apply {
                put("lat", location.latitude)
                put("long", location.longitude)
            }

            if (::mSocket.isInitialized && mSocket.connected()) {
                mSocket.emit("save_location", locationData)
                Log.d("LocationLog", "[$timeString] Location sent - Lat: ${location.latitude}, Lng: ${location.longitude}")
            } else {
                Log.w("SocketIO", "Socket not connected. Skipping emit.")
                // Try to reconnect if socket is initialized but not connected
                if (::mSocket.isInitialized && !mSocket.connected()) {
                    Log.d("SocketIO", "Attempting to reconnect socket")
                    mSocket.connect()
                }
            }

            // Update last known location after sending
            lastKnownLocation = location
        } else {
            Log.d("LocationLog", "Skipping location update - moved less than ${MIN_DISTANCE_FOR_UPDATE}m")
        }
    }



    // Helper function to calculate distance between two locations
    private fun calculateDistance(start: android.location.Location, end: android.location.Location): Float {
        return start.distanceTo(end) // Returns distance in meters
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d("LocationService", "Service onDestroy called")

        if (::wakeLock.isInitialized && wakeLock.isHeld) {
            wakeLock.release()
        }

        if (::fusedLocationClient.isInitialized) {
            fusedLocationClient.removeLocationUpdates(locationCallback)
        }

        if (::mSocket.isInitialized && mSocket.connected()) {
            mSocket.disconnect()
            mSocket.off()
        }

        restartService()
        Log.d("LocationService", "Destroyed and restarting service.")
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        Log.d("LocationService", "Task removed, will attempt to restart")
        restartService()
    }

    private fun restartService() {
        val restartIntent = Intent(applicationContext, AndroidLocationService::class.java).apply {
            putExtra("token", token)
        }

        val pendingIntent = PendingIntent.getService(
            applicationContext,
            1,
            restartIntent,
            PendingIntent.FLAG_IMMUTABLE
        )

        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.set(
            AlarmManager.ELAPSED_REALTIME,
            SystemClock.elapsedRealtime() + 1000,
            pendingIntent
        )

        Log.d("LocationService", "Service restart scheduled")
    }



    override fun onBind(intent: Intent?): IBinder? = null
}