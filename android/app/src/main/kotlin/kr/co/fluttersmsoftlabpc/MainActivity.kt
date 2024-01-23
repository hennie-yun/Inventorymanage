package kr.co.fluttersmsoftlabpc

import android.os.Bundle
import android.os.PersistableBundle
import io.flutter.app.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.app.FlutterFragmentActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        GeneratedPluginRegistrant.registerWith(this)
    }

//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//        GeneratedPluginRegistrant.registerWith(flutterEngine)
//    }
}
