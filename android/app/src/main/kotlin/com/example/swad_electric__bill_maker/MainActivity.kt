package com.example.swad_electric__bill_maker

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.bluetooth.BluetoothAdapter
import android.content.Context 
import android.content.Intent
import android.content.IntentFilter


class MainActivity: FlutterActivity() {
    val channel = "com.swad_electric__bill_maker/simpleMethodCall"

    private val bluetoothAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()
    var discoveredDevices: MutableList<BluetoothDevice>? = null
    private lateinit var methodResult: MethodChannel.Result

    

    override fun configureFlutterEngine(flutterEngine: FlutterEngine){

        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,channel).setMethodCallHandler{
            call, result->
            if (call.method == "getNormalMethodCallResult"){
                 val nativeData = getNormalMethodCallResult()
                result.success(nativeData)
            }else if (call.method == "chekckpermission"){
            if (bluetoothAdapter == null){
                result.error("UNAVAILABLE", "Bluetooth not supported", null)
            }else{
                if(!bluetoothAdapter.isEnabled()){
                    result.success(false)
                }else{
                    result.success(true)
                }
            }
            
           
             
           }else if (call.method == "enableBluetooth"){
            bluetoothAdapter!!.enable()
            result.success(true)
           }else if (call.method == "scanBluetoothDevice"){
            val deviceData = discoverDevices(discoveredDevices,result)
            result.success(deviceData)
            
           }

            else{
                result.notImplemented()
            }
        }

    }

private fun discoverDevices(deviceList: MutableList<BluetoothDevice>?, result: MethodChannel.Result) {
    bluetoothAdapter!!.startDiscovery()
    val filter = IntentFilter(BluetoothDevice.ACTION_FOUND)
    val receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                when (intent.action) {
                    BluetoothDevice.ACTION_FOUND -> {
                        val device: BluetoothDevice? = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                        device?.let{
                            discoveredDevices!!.add(it)
                        }
                        println("device found has selected parameters inside the broadcast receivver function $device")
                    }
                    BluetoothAdapter.ACTION_DISCOVERY_FINISHED -> {
                        val devices = discoveredDevices!!.map { device ->
                        mapOf("name" to (device.name ?: "Unknown"), "address" to device.address)
                    }
                        result.success(devices)
                    }
                    "" -> println("broadcast receiver intent.action has no attribute")
                    null -> println("broadcast receiver intent.action was null")
                }
            }
        }
    registerReceiver(receiver,filter)
      
}    
// private val receiver = object : BroadcastReceiver() {
//         override fun onReceive(context: Context, intent: Intent) {
//             when (intent.action) {
//                 BluetoothDevice.ACTION_FOUND -> {
//                     val device: BluetoothDevice? = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
//                     device?.let {
//                         discoveredDevices.add(it)
//                     }
//                 }
//                 BluetoothAdapter.ACTION_DISCOVERY_FINISHED -> {
//                     // Send the list of discovered devices to Flutter
//                     val deviceList = discoveredDevices.map { device ->
//                         mapOf("name" to (device.name ?: "Unknown"), "address" to device.address)
//                     }
//                     methodResult.success(deviceList)
//                 }
//             }
//         }
//     }

    
}
 


 private fun getNormalMethodCallResult(): String {
        return "Data from native code"
    }
