package com.orderpin.doctor_consultation

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        // Changed for Agora.io plugin
        // GeneratedPluginRegistrant.registerWith(flutterEngine);
         super.configureFlutterEngine(flutterEngine);
    }
}
