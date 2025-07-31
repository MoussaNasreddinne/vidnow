package com.example.test1

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.google.android.gms.ads.MobileAds
import android.util.Log

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Initialize Mobile Ads SDK
        MobileAds.initialize(this) { initializationStatus ->
            // Log initialization status
            Log.d("Ads", "Mobile Ads SDK initialized: ${initializationStatus.adapterStatusMap}")
            
            // Optional: Print test device ID for verification
            Log.d("Ads", "Test device ID: ${MobileAds.getRequestConfiguration().testDeviceIds}")
        }
    }
}