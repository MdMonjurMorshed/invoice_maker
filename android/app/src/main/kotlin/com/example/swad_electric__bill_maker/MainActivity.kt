package com.example.swad_electric__bill_maker

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.swad_electric__bill_maker.BluetoothDeviceFind

class MainActivity: FlutterActivity() {
    val channel = "com.swad_electric__bill_maker/simpleMethodCall"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine){

        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.add(BluetoothDeviceFind())

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,channel).setMethodCallHandler{
            call, result->
            if (call.method == "getNormalMethodCallResult"){
                 val nativeData = getNormalMethodCallResult()
                result.success(nativeData)
            }
            else{
                result.notImplemented()
            }
        }

    }
}
 
 private fun getNormalMethodCallResult(): String {
        return "Data from native code"
    }
