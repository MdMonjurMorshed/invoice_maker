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
import android.util.Log
import android.content.pm.PackageManager
import androidx.core.content.ContextCompat
import android.Manifest
import androidx.core.app.ActivityCompat
import android.location.LocationManager
import android.provider.Settings
import java.util.UUID
import java.io.OutputStream
import android.bluetooth.BluetoothSocket
import java.io.IOException
import android.bluetooth.BluetoothClass
import android.widget.Toast



class MainActivity: FlutterActivity() {
    val channel = "com.swad_electric__bill_maker/simpleMethodCall"

    private val bluetoothAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()
    var discoveredDevices: MutableList<BluetoothDevice> =  mutableListOf()
    private lateinit var methodResult: MethodChannel.Result
    private val REQUEST_BLUETOOTH_PERMISSIONS = 1
    private val REQUEST_LOCATION_PERMISSION = 2

     private fun isLocationEnabled(): Boolean {
        val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) ||
                locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
    }

    private fun openLocationSettings() {
        val intent = Intent(android.provider.Settings.ACTION_LOCATION_SOURCE_SETTINGS)
        startActivity(intent)
    }
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
               Log.d("Tag","scan bluetooth called")
              discoveredDevices.clear()
              discoverDevices(result)
            
            
           }else if(call.method == "connectDeviceAndPrint"){
                printAndConnect()
                result.success("success")

            }

            else{
                result.notImplemented()
            }
        }

    }

private  fun printAndConnect(){

    val pairedDevice:Set<BluetoothDevice> = bluetoothAdapter!!.bondedDevices

    Log.d("pairedDevice","$pairedDevice")

    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
        // Android 12 (API 31) and above
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_SCAN)
            != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_CONNECT)
            != PackageManager.PERMISSION_GRANTED) {
            // Request Bluetooth permissions for Android 12+
            ActivityCompat.requestPermissions(this, arrayOf(
                Manifest.permission.BLUETOOTH_SCAN,
                Manifest.permission.BLUETOOTH_CONNECT,
                Manifest.permission.BLUETOOTH_ADVERTISE
            ), REQUEST_BLUETOOTH_PERMISSIONS)


        }else{
            if (isLocationEnabled()){
                for (device in pairedDevice){
                    Log.d("deviceAddress","${device.address}")
                    val bluetoothDevice: BluetoothDevice = bluetoothAdapter!!.getRemoteDevice("${device.address}")
                    Log.d("deviceAddress","working")

                    val deviceClass: Int = bluetoothDevice.bluetoothClass.deviceClass
                    Log.d("DeviceClass","$deviceClass")
                    when(deviceClass){

                        BluetoothClass.Device.Major.PHONE -> {
                            Log.d("DeviceType","this is phone")
                            Toast.makeText(this, "this is a smart phone", Toast.LENGTH_SHORT).show()
                        }
                        BluetoothClass.Device.Major.COMPUTER ->{
                            Toast.makeText(this, "Connected device is Laptop", Toast.LENGTH_SHORT).show()
                            Log.d("DeviceType","this is laptop")
                        }
                        BluetoothClass.Device.Major.IMAGING-> {
                            Toast.makeText(this, "Connected device is a printer", Toast.LENGTH_SHORT).show()
                            Log.d("DeviceType","this is printer")
                        }
                    }

                    if (isDeviceConnected(bluetoothDevice)){




                        val uuids = device.uuids
                        if (uuids != null && uuids.isNotEmpty()) {
                            // Use the first UUID (or iterate over if needed)
                            val uuid = uuids[0].uuid
                            val data = mapOf(
                                "this" to "this is data"
                            )
//                printData(bluetoothDevice,uuid,data)

                        }

                    }else{
                        Log.d("notConnected","no device is connected right now")
                    }
                }
            }else{
                openLocationSettings()
            }
        }
    } else if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
        // Android 6.0 (API 23) to Android 11 (API 30)
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
            != PackageManager.PERMISSION_GRANTED) {
            // Request Location permission for Bluetooth scanning (Android 6 to 11)
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), REQUEST_LOCATION_PERMISSION)
        }else{
            if (isLocationEnabled()){
                for (device in pairedDevice){
                    Log.d("deviceName","${device.name}")
                    Log.d("deviceAddress","${device.address}")
                    val bluetoothDevice: BluetoothDevice = bluetoothAdapter!!.getRemoteDevice("$device")
                    val deviceClass = bluetoothDevice.bluetoothClass.deviceClass
                    val majorDevice = bluetoothDevice.bluetoothClass.majorDeviceClass
                    val minorDevice = deviceClass and 0xFF

                    Log.d("majorDevice","$majorDevice")
                    Log.d("minorDevice","$minorDevice")
                    Log.d("deviceClass","$deviceClass")

                    if (majorDevice == BluetoothClass.Device.Major.HEALTH) {
                        Log.d("inMajor","i am in major and got imaging device")
                        val uuids = device.uuids
                        if (uuids != null && uuids.isNotEmpty()) {
                            // Use the first UUID (or iterate over if needed)
                            val uuid = uuids[0].uuid
                            val data = mapOf(
                                "this" to "this is data"
                            )
                printData(bluetoothDevice,uuid,data)

                        }

                    }
                    if (majorDevice == BluetoothClass.Device.Major.IMAGING){
                        Log.d("inMajor","i am in imaging device")
                    }
                    if (majorDevice == BluetoothClass.Device.Major.PHONE){
                        Log.d("inMajor","it's a phone")
                    }

//                    if (deviceClass == 0x1C){
//                        Log.d("deviceClas","$deviceClass")
//                    }

//                    when(deviceClass){
////                        Log.d("InWhen","i am in when")
////                        BluetoothClass.Device.Minor.IMAGING -> {
////                            Log.d("minorDevice","in the  minor device")
////
////                                }
//
//                            deviceClass == 0x1C {
//                                Log.Ded("BluetoothDevice", "Device is a Printer")
//                            } else {
//                                Log.d(
//                                    "BluetoothDevice",
//                                    "Device is an Imaging device but not a Printer"
//                                )
//                            }
//                        }


                    if (isDeviceConnected(bluetoothDevice)){

                        when(deviceClass){

                            BluetoothClass.Device.PHONE_SMART -> {
                                Log.d("DeviceType","this is phone")
                                Toast.makeText(this, "this is a smart phone", Toast.LENGTH_SHORT).show()
                            }
                            BluetoothClass.Device.COMPUTER_LAPTOP ->{
                                Toast.makeText(this, "Connected device is Laptop", Toast.LENGTH_SHORT).show()
                            }
                            BluetoothClass.Device.Major.IMAGING-> {
                                Toast.makeText(this, "Connected device is a printer", Toast.LENGTH_SHORT).show()
                            }
                        }




                    }else{
                        Log.d("notConnected","no device is connected right now")
                    }
                }

            }else{
                openLocationSettings()
            }



        }

    }




}

private  fun  printData(device: BluetoothDevice,uuid: UUID,data:Map<String,Any>){
     Log.d("mapData","${data["this"].toString()}")
     Log.d("printUUID","$uuid")
    var socket: BluetoothSocket? = null

    socket = device.createRfcommSocketToServiceRecord(uuid)

    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
        // Android 12 (API 31) and above
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_SCAN)
            != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_CONNECT)
            != PackageManager.PERMISSION_GRANTED) {
            // Request Bluetooth permissions for Android 12+
            ActivityCompat.requestPermissions(this, arrayOf(
                Manifest.permission.BLUETOOTH_SCAN,
                Manifest.permission.BLUETOOTH_CONNECT,
                Manifest.permission.BLUETOOTH_ADVERTISE
            ), REQUEST_BLUETOOTH_PERMISSIONS)


        }else{
            if (isLocationEnabled()){
                if (bluetoothAdapter?.isDiscovering == true){
                    Log.d("Discovering","bluetooth is discovering")
                }
                if (device.bondState != BluetoothDevice.BOND_BONDED) {
                    //device.createBond()  // Ensure pairing is completed
                    Log.d("notPaired","device not paired")
                }
                try {
                    Log.d("devicePrint","$device")
                    Log.d("uuid","$uuid")

                    Log.d("socket","$socket")
                    Log.d("connection","${socket!!.connect()}")
                    socket!!.connect()

                    Log.d("bluetoothSocket","bluetooth socket is connected")
                    // Get the output stream to send data to the printer

                    val outputStream: OutputStream = socket.outputStream
                    outputStream.write(data["this"].toString().toByteArray())
                    outputStream.flush()
                    Log.d("printed","data is printed")
                    outputStream.close()
                    socket!!.close()
                    // Close the socket


                }catch (e:IOException){


                    e.printStackTrace()
                    Log.d("printError","${e.message}")
                }

            }else{
                openLocationSettings()
            }
        }
    } else if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
        // Android 6.0 (API 23) to Android 11 (API 30)
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
            != PackageManager.PERMISSION_GRANTED) {
            // Request Location permission for Bluetooth scanning (Android 6 to 11)
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), REQUEST_LOCATION_PERMISSION)
        }else{
            if (isLocationEnabled()){
                if (bluetoothAdapter?.isDiscovering == true){
                    Log.d("Discovering","bluetooth is discovering")
                }
                if (device.bondState != BluetoothDevice.BOND_BONDED) {
                    //device.createBond()  // Ensure pairing is completed
                    Log.d("notPaired","device not paired")
                }
                try {
//                    Log.d("devicePrint","$device")
//                    Log.d("uuid","$uuid")
//
//                    Log.d("socket","$socket")
//                    Log.d("connection","${socket!!.connect()}")
                    socket!!.connect()

                    Log.d("bluetoothSocket","bluetooth socket is connected")
                    // Get the output stream to send data to the printer

                    val outputStream: OutputStream = socket.outputStream
                    outputStream.write(data["this"].toString().toByteArray())
                    outputStream.flush()
                    Log.d("printed","data is printed")
                    outputStream.close()

                    // Close the socket


                }catch (e:IOException){


//                    e.printStackTrace()
                    Log.d("printError","${e.message}")

                    try {
                        socket!!.close()
                        Log.d("bluetoothSocket","bluetooth socket is closed")
                    }catch (e:IOException){
                        Log.d("socketClosingError","${e.message}")
                    }
                }

            }else{
                openLocationSettings()
            }



        }

    }






}


private fun isDeviceConnected(device: BluetoothDevice): Boolean {
          Log.d("device","$device")
        try {
            // Using reflection to check if the Bluetooth device is connected
            val method = device.javaClass.getMethod("isConnected")
            return method.invoke(device) as Boolean
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return false
    }

private fun discoverDevices(result: MethodChannel.Result) {
    Log.d("discover","discover devices called")
    Log.d("adapter","$bluetoothAdapter")

    val filter = IntentFilter(BluetoothDevice.ACTION_FOUND)
    filter.addAction(BluetoothAdapter.ACTION_DISCOVERY_FINISHED)
    Log.d("IntentFilter","$filter")





    val receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val action = intent.action
                Log.d("action","action is $action")
                when (intent.action) {
                    BluetoothDevice.ACTION_FOUND -> {
                        val device: BluetoothDevice? = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                        device?.let{
                            val duplicateDevice = discoveredDevices.any {discoveredDevice: BluetoothDevice -> discoveredDevice.address == device.address
                            }
                            if(!duplicateDevice){
                                discoveredDevices.add(it)
                            }

                        }
                        Log.d("tag","device found has selected parameters inside the broadcast receivver function $device")
                    }
                    BluetoothAdapter.ACTION_DISCOVERY_FINISHED -> {
                        val devices = discoveredDevices.map { device ->
                        mapOf("name" to (device.name ?: "Unknown"), "address" to device.address)
                    }
                        result.success(devices)
                        unregisterReceiver(this)
                    }
                    "" -> println("broadcast receiver intent.action has no attribute")
                    null -> println("broadcast receiver intent.action was null")
                }
            }
        }
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
        // Android 12 (API 31) and above
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_SCAN)
            != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_CONNECT)
            != PackageManager.PERMISSION_GRANTED) {
            // Request Bluetooth permissions for Android 12+
            ActivityCompat.requestPermissions(this, arrayOf(
                Manifest.permission.BLUETOOTH_SCAN,
                Manifest.permission.BLUETOOTH_CONNECT,
                Manifest.permission.BLUETOOTH_ADVERTISE
            ), REQUEST_BLUETOOTH_PERMISSIONS)


        }else{
            if (isLocationEnabled()){
                if (bluetoothAdapter?.isDiscovering == true){
                    Log.d("discovering","discovering the going on")
                    bluetoothAdapter?.cancelDiscovery()
                }else{
                    Log.d("startDiscovery","discovery started")
                    registerReceiver(receiver, filter)

                    val started12 = bluetoothAdapter?.startDiscovery()
                    Log.d("started12+","$started12")
                }
            }else{
                openLocationSettings()
            }
        }
    } else if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
        // Android 6.0 (API 23) to Android 11 (API 30)
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
            != PackageManager.PERMISSION_GRANTED) {
            // Request Location permission for Bluetooth scanning (Android 6 to 11)
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), REQUEST_LOCATION_PERMISSION)
        }else{
               if (isLocationEnabled()){
                   if (bluetoothAdapter?.isDiscovering == true){
                       Log.d("discovering","discovering the going on")
                       bluetoothAdapter?.cancelDiscovery()
                   }else{
                       Log.d("startDiscovery","discovery started")
                       registerReceiver(receiver, filter)

                       val started6 = bluetoothAdapter?.startDiscovery()
                       Log.d("started6","$started6")
                   }
               }else{
                   openLocationSettings()
               }



            }

        }
    }



      

// private val receiver = object : BroadcastReceiver() {
//         overvride fun onReceive(context: Context, intent: Intent) {
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

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        when (requestCode) {
            REQUEST_BLUETOOTH_PERMISSIONS -> {
                // Android 12+ Bluetooth permission result
                if (grantResults.isNotEmpty() && grantResults.all { it == PackageManager.PERMISSION_GRANTED }) {
                    // All Bluetooth permissions are granted
                    Log.d("MainActivity", "Bluetooth permissions granted")
                        if (isLocationEnabled()){
                            if (bluetoothAdapter?.isDiscovering == true){
                                Log.d("discovering","discovering the going on")
                                bluetoothAdapter?.cancelDiscovery()
                            }else{
                                Log.d("startDiscovery","discovery started")


                                val started6 = bluetoothAdapter?.startDiscovery()
                                Log.d("started6","$started6")
                            }
                        }else{
                            openLocationSettings()
                        }

//                    if (bluetoothAdapter?.isDiscovering == true){
//                        bluetoothAdapter?.cancelDiscovery()
//                    }else{
//                        bluetoothAdapter?.startDiscovery()
//                    }


                } else {
                    Log.d("MainActivity", "Bluetooth permissions denied")
                    // Handle denied permission case (show a message or disable features)
                }
            }
            REQUEST_LOCATION_PERMISSION -> {
                // Location permission result for Android 6-11
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    Log.d("MainActivity", "Bluetooth permissions granted")
//                    if (bluetoothAdapter?.isDiscovering == true){
//                        bluetoothAdapter?.cancelDiscovery()
//                    }else{
//                        bluetoothAdapter?.startDiscovery()
//                    }
                    if (isLocationEnabled()){
                        if (bluetoothAdapter?.isDiscovering == true){
                            Log.d("discovering","discovering the going on")
                            bluetoothAdapter?.cancelDiscovery()
                        }else{
                            Log.d("startDiscovery","discovery started")

                            val started6 = bluetoothAdapter?.startDiscovery()
                            Log.d("started6","$started6")
                        }
                    }else{
                        openLocationSettings()
                    }
                } else {
                    Log.d("MainActivity", "Location permission denied")
                    // Handle denied permission case
                }
            }
        }
    }





}
 


 private fun getNormalMethodCallResult(): String {
        return "Data from native code"
    }
