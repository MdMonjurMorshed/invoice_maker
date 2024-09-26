package com.example.swad_electric__bill_maker

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

class BluetoothDeviceFind : FlutterPlugin {
    private val channelName = "bluetoothChannel"
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private val bluetoothAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelName)
        channel.setMethodCallHandler { call, result ->
            if (call.method == "discoverBluetoothDevices") {
                val data = discoverDevices(result)
                result.success(data)
            }
        }
    }
    
    private fun discoverDevices(result: MethodChannel.Result): MutableList<BluetoothDevice> {
        var bluetoothDevices = mutableListOf<BluetoothDevice>()

        val receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val action: String = intent.action ?: return
                if (BluetoothDevice.ACTION_FOUND == action) {
                    val device: BluetoothDevice? = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                    device?.let {
                        bluetoothDevices.add(it)
                    }
                } else if (BluetoothAdapter.ACTION_DISCOVERY_FINISHED == action) {
                    context.unregisterReceiver(this)
                    result.success(bluetoothDevices)
                }
            }
        }
        val filter = IntentFilter(BluetoothDevice.ACTION_FOUND)
        context.registerReceiver(receiver, filter)
        bluetoothAdapter?.startDiscovery()
        return bluetoothDevices
    }
    

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
       channel.setMethodCallHandler(null)
    }
}

