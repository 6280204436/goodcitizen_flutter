
package com.pr.goodcitizen

import android.content.Intent
import android.os.Bundle
import android.view.ViewGroup
import androidx.activity.enableEdgeToEdge
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsControllerCompat


class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.android.goodcitizen/foreground_service"

    override fun onCreate(savedInstanceState: Bundle?) {
        // Enable edge-to-edge display before setting content
        enableEdgeToEdge()
        WindowCompat.setDecorFitsSystemWindows(window, false)
        val controller = WindowCompat.getInsetsController(window, window.decorView)
        controller?.systemBarsBehavior =
            WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE

        // Optionally hide nav/status bars initially
        controller?.hide(WindowInsetsCompat.Type.systemBars())

        super.onCreate(savedInstanceState)

        // Find the FlutterView in the view hierarchy
        val contentView = window.decorView.findViewById<ViewGroup>(android.R.id.content)
        val flutterView = findFlutterView(contentView) ?: return



        // Handle system insets for edge-to-edge
        ViewCompat.setOnApplyWindowInsetsListener(flutterView) { view: android.view.View, insets: WindowInsetsCompat ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            view.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
    }

    // Helper function to find FlutterView in the view hierarchy
    private fun findFlutterView(viewGroup: ViewGroup): FlutterView? {
        for (i in 0 until viewGroup.childCount) {
            val child = viewGroup.getChildAt(i)
            if (child is FlutterView) {
                return child
            } else if (child is ViewGroup) {
                val result = findFlutterView(child)
                if (result != null) return result
            }
        }
        return null
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startForegroundService" -> {
                        val token = call.argument<String>("token")
                        val serverUrl = call.argument<String>("serverUrl")
                        val messageHeading = call.argument<String>("messageHeading")
                        val messageDescription = call.argument<String>("messageDescription")

                        startForegroundService(token, serverUrl, messageHeading, messageDescription)
                        result.success(null)
                    }
                    "stopForegroundService" -> {
                        stopForegroundService()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun startForegroundService(token: String?, serverUrl: String?, messageHeading: String?, messageDescription: String?) {
        val serviceIntent = Intent(this, AndroidLocationService::class.java).apply {
            putExtra("token", token)
            putExtra("serverUrl", serverUrl)
            putExtra("messageHeading", messageHeading)
            putExtra("messageDescription", messageDescription)
        }
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            startForegroundService(serviceIntent)
        } else {
            startService(serviceIntent)
        }
    }

    private fun stopForegroundService() {
        val serviceIntent = Intent(this, AndroidLocationService::class.java)
        stopService(serviceIntent)
    }
}
