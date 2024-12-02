package com.example.swad_electric__bill_maker

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothClass
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothProfile
import android.bluetooth.BluetoothSocket
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.location.LocationManager
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.util.Log
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.io.OutputStream
import java.util.UUID
import android.net.Uri
import androidx.core.content.FileProvider
import java.io.File


class MainActivity: FlutterActivity() {
    val channel = "com.swad_electric__bill_maker/simpleMethodCall"

    private val bluetoothAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()
    var discoveredDevices: MutableList<BluetoothDevice> = mutableListOf()
    var bondedDevices: MutableList<BluetoothDevice> = mutableListOf()
    private lateinit var methodResult: MethodChannel.Result
    private val REQUEST_BLUETOOTH_PERMISSIONS = 1
    private val REQUEST_LOCATION_PERMISSION = 2
    private var bluetoothSocket: BluetoothSocket? = null
    private  var  keepAlive = true;

    private fun isLocationEnabled(): Boolean {
        val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) ||
                locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
    }

    private fun openLocationSettings() {
        val intent = Intent(android.provider.Settings.ACTION_LOCATION_SOURCE_SETTINGS)
        startActivity(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {

        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->
            if (call.method == "getNormalMethodCallResult") {
                val nativeData = getNormalMethodCallResult()
                result.success(nativeData)
            } else if (call.method == "chekckpermission") {
                if (bluetoothAdapter == null) {
                    result.error("UNAVAILABLE", "Bluetooth not supported", null)
                } else {
                    if (!bluetoothAdapter.isEnabled()) {
                        result.success(false)
                    } else {
                        result.success(true)
                    }
                }


            } else if (call.method == "enableBluetooth") {
                bluetoothAdapter!!.enable()
                result.success(true)
            } else if (call.method == "scanBluetoothDevice") {
                Log.d("Tag", "scan bluetooth called")
                discoveredDevices.clear()
                discoverDevices(result)


            } else if (call.method == "getBondedDevice") {
                getBondedDevice(result)

            } else if (call.method == "connectToDevice") {
//                printAndConnect()
//                result.success("success")
                connectBluetoothDevice(result)
//                bleDeviceConnectionAndPrint(address!!)



            } else if (call.method == "connectionChecking") {
                
//                val isConnected = isSocketConnected()
//                result.success(isConnected)
                val isConnected = isDeviceBonded("1B:F3:BC:D4:CE:13")
                if (isConnected){
                    result.success(true)
                }else{
                    result.success(false)
                }
            }else if(call.method == "printData"){
                val address = call.argument<String>("address")
                dataPrintingMethod(address!!)
            }else if (call.method == "shareFile") {
                val filePath = call.argument<String>("filePath")
                Log.d("filePath","$filePath")
                val packageName = call.argument<String>("packageName")
                if (filePath != null && packageName != null) {
                    shareFileToSpecificApp(filePath, packageName)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "File path or package name is null", null)
                }
            }
            else {
                result.notImplemented()
            }
        }


    }

     private fun shareFileToSpecificApp(filePath: String, packageName: String) {
        val file = File(filePath)
        Log.d("file","$file")
        val uri = FileProvider.getUriForFile(this, "${applicationContext.packageName}.fileprovider", file)

        Log.d("fileUri","$uri")
        val shareIntent = Intent(Intent.ACTION_SEND).apply {
            type = "application/pdf"
            putExtra(Intent.EXTRA_STREAM, uri)
            setPackage(packageName)
        }
        startActivity(Intent.createChooser(shareIntent, "Share File"))
    }

    private fun bleDeviceConnectionAndPrint(address: String) {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
            // Android 12 (API 31) and above
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_SCAN)
                != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(
                    this,
                    Manifest.permission.BLUETOOTH_CONNECT
                )
                != PackageManager.PERMISSION_GRANTED
            ) {
                // Request Bluetooth permissions for Android 12+
                ActivityCompat.requestPermissions(
                    this, arrayOf(
                        Manifest.permission.BLUETOOTH_SCAN,
                        Manifest.permission.BLUETOOTH_CONNECT,
                        Manifest.permission.BLUETOOTH_ADVERTISE
                    ), REQUEST_BLUETOOTH_PERMISSIONS
                )


            } else {
                if (isLocationEnabled()) {

                } else {
                    openLocationSettings()
                }
            }
        } else if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
            // Android 6.0 (API 23) to Android 11 (API 30)
            if (ContextCompat.checkSelfPermission(
                    this,
                    Manifest.permission.ACCESS_FINE_LOCATION
                )
                != PackageManager.PERMISSION_GRANTED
            ) {
                // Request Location permission for Bluetooth scanning (Android 6 to 11)
                ActivityCompat.requestPermissions(
                    this,
                    arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                    REQUEST_LOCATION_PERMISSION
                )
            } else {
                if (isLocationEnabled()) {

                    val device = bluetoothAdapter?.getRemoteDevice(address)
                    device?.let {
                        val gatt = it.connectGatt(this, true, object : BluetoothGattCallback() {
                            override fun onConnectionStateChange(
                                gatt: BluetoothGatt,
                                status: Int,
                                newState: Int
                            ) {
                                Log.d("connectionStatus","$status")
                                Log.d("newState","$newState")
                                if (newState == BluetoothProfile.STATE_CONNECTED) {
                                    gatt.discoverServices()
                                }else {
                                    // Retry connection if status is 133 or connection failed
                                    if (status == 133) {
                                        gatt.close()
                                        Handler(Looper.getMainLooper()).postDelayed({
                                            device.connectGatt(context, false, this)
                                        }, 1000) // 1-second delay
                                    }
                                }

                            }

                            override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
                                if (status == BluetoothGatt.GATT_SUCCESS) {
                                    for (service in gatt.services) {
                                        val serviceUuid = service.uuid // Service UUID
                                        Log.d("serviceUUID", "$serviceUuid")
                                        for (characteristic in service.characteristics) {
                                            val characteristicUuid = characteristic.uuid // Characteristic UUID
                                            Log.d("characteristicUuid", "$characteristicUuid")
                                            // Here you can log or use the service and characteristic UUIDs
                                        }
                                    }
                                }
                            }
                        })


                    }



                } else {
                    openLocationSettings()
                }


            }

        }


    }

    private fun checkSocketConnection(result: MethodChannel.Result, address: String) {
        val bluetoothDevice: BluetoothDevice = bluetoothAdapter!!.getRemoteDevice("$address")
        Log.d("remoteDevice", "$bluetoothDevice")

        Thread {
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
                // Android 12 (API 31) and above
                if (ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_SCAN)
                    != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(
                        this,
                        Manifest.permission.BLUETOOTH_CONNECT
                    )
                    != PackageManager.PERMISSION_GRANTED
                ) {
                    // Request Bluetooth permissions for Android 12+
                    ActivityCompat.requestPermissions(
                        this, arrayOf(
                            Manifest.permission.BLUETOOTH_SCAN,
                            Manifest.permission.BLUETOOTH_CONNECT,
                            Manifest.permission.BLUETOOTH_ADVERTISE
                        ), REQUEST_BLUETOOTH_PERMISSIONS
                    )


                } else {
                    if (isLocationEnabled()) {
                        if (bluetoothSocket!!.isConnected){
                            result.success(true)
                        }
                        result.success(false)

                    } else {
                        openLocationSettings()
                    }
                }
            } else if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
                // Android 6.0 (API 23) to Android 11 (API 30)
                if (ContextCompat.checkSelfPermission(
                        this,
                        Manifest.permission.ACCESS_FINE_LOCATION
                    )
                    != PackageManager.PERMISSION_GRANTED
                ) {
                    // Request Location permission for Bluetooth scanning (Android 6 to 11)
                    ActivityCompat.requestPermissions(
                        this,
                        arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                        REQUEST_LOCATION_PERMISSION
                    )
                } else {
                    if (isLocationEnabled()) {
                        if (bluetoothSocket!!.isConnected){
                            result.success(true)
                        }
                        result.success(false)





                } else {
                    openLocationSettings()
                }


            }

        }

    }.start()

}
private  fun getBondedDevice(result:MethodChannel.Result){
    val pairedDevice:Set<BluetoothDevice> = bluetoothAdapter!!.bondedDevices
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

               for(device in pairedDevice){
                   val bluetoothDevice: BluetoothDevice = bluetoothAdapter!!.getRemoteDevice("${device.address}")
                   Log.d("connectedDevice","$bluetoothDevice")
//                   val deviceClass = bluetoothDevice.bluetoothClass.deviceClass
                   val majorDevice = bluetoothDevice.bluetoothClass.majorDeviceClass

                   if (majorDevice == BluetoothClass.Device.Major.HEALTH) {
                       Log.d("inMajor","i am in major and got imaging device")
                       bondedDevices.add(device)

                       }


                   if (majorDevice == BluetoothClass.Device.Major.IMAGING){
                       Log.d("inMajor","i am in imaging device")
                       bondedDevices.add(device)
                   }
                   if (majorDevice == BluetoothClass.Device.Major.PHONE){
                       Log.d("inMajor","it's a phone")

                   }




               }

                val devices = bondedDevices.map{ device ->
                    mapOf("name" to (device.name ?: "Unknown"), "address" to device.address)
                }
                result.success(devices)

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
                for(device in pairedDevice){
                    val bluetoothDevice: BluetoothDevice = bluetoothAdapter!!.getRemoteDevice("${device.address}")
                    Log.d("connectedDevice","$bluetoothDevice")
//                   val deviceClass = bluetoothDevice.bluetoothClass.deviceClass
                    val majorDevice = bluetoothDevice.bluetoothClass.majorDeviceClass

                    if (majorDevice == BluetoothClass.Device.Major.HEALTH) {
                        Log.d("inMajor","i am in major and got imaging device")
                        bondedDevices.add(device)

                    }


                    if (majorDevice == BluetoothClass.Device.Major.IMAGING){
                        Log.d("inMajor","i am in imaging device")
                        bondedDevices.add(device)
                    }
                    if (majorDevice == BluetoothClass.Device.Major.PHONE){
                        Log.d("inMajor","it's a phone")

                    }
//                    val devices = bondedDevices.map{device->mapOf("name" to (device.name ?: "Unknown"), "address" to device.address)}
//                    Log.d("devices","$devices")
//                    result.success(bondedDevices)


                }
                val devices = bondedDevices.map{device->mapOf("name" to (device.name ?: "Unknown"), "address" to device.address)}
                Log.d("devices","$devices")
                result.success(devices)
            }else{
                openLocationSettings()
            }



        }

    }
//    result.success(pairedDevice)


}
    fun isDeviceBonded( deviceAddress: String): Boolean {

        val device = bluetoothAdapter?.getRemoteDevice(deviceAddress)

        return try {
            // Access the `isConnected` method via reflection
            val method = BluetoothDevice::class.java.getMethod("isConnected")
            method.invoke(device) as Boolean
        } catch (e: Exception) {
            Log.e("BluetoothCheck", "Could not check connection status", e)
            false
        }

    }
    // 2. Check if Socket is Connected
    private fun isSocketConnected() {
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

                    Log.d("checkSocket","$bluetoothSocket")

                }else{
                    openLocationSettings()
                }
            }
        } else if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
            // Android 6.0 (API 23) to Android 11 (API 30)
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED
            ) {
                // Request Location permission for Bluetooth scanning (Android 6 to 11)
                ActivityCompat.requestPermissions(
                    this,
                    arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                    REQUEST_LOCATION_PERMISSION
                )
            } else {
                if (isLocationEnabled()) {
                    Log.d("checkSocket","$bluetoothSocket")
                } else {
                    openLocationSettings()
                }


            }

        }
    }


// private  fun connectToBluetoothDevice(result:MethodChannel.Result){
   
//     Thread {
//         if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
//             // Android 12 (API 31) and above
//             if (ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_SCAN)
//                 != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(
//                     this,
//                     Manifest.permission.BLUETOOTH_CONNECT
//                 )
//                 != PackageManager.PERMISSION_GRANTED
//             ) {
//                 // Request Bluetooth permissions for Android 12+
//                 ActivityCompat.requestPermissions(
//                     this, arrayOf(
//                         Manifest.permission.BLUETOOTH_SCAN,
//                         Manifest.permission.BLUETOOTH_CONNECT,
//                         Manifest.permission.BLUETOOTH_ADVERTISE
//                     ), REQUEST_BLUETOOTH_PERMISSIONS
//                 )


//             } else {
//                 if (isLocationEnabled()) {
//                       val bondedDevices: Set<BluetoothDevice> = bluetoothAdapter.bondedDevices
   

    

//     // Find the specific printer by name
//     val targetDevice: BluetoothDevice = bondedDevices.find { it.name == "X5h-F31B" }
//     if (targetDevice == null) {
//         Log.d("tergetDevice","Printer with X5h-F31B name   not found.")
//         return
//     }

//     // UUID for Serial Port Profile (SPP)
//     val universalUUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")

//     try {
//         // Create a socket and connect
//         val socket: BluetoothSocket = targetDevice.createRfcommSocketToServiceRecord(universalUUID)
//         println("Connecting to ${targetDevice.name}...")
//         socket.connect()
        

//     } catch (e: IOException) {
//         println("Connection failed: ${e.message}")
//         e.printStackTrace()
//     }

//                 } else {
//                     openLocationSettings()
//                 }
//             }
//         } else if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
//             // Android 6.0 (API 23) to Android 11 (API 30)
//             if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
//                 != PackageManager.PERMISSION_GRANTED
//             ) {
//                 // Request Location permission for Bluetooth scanning (Android 6 to 11)
//                 ActivityCompat.requestPermissions(
//                     this,
//                     arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
//                     REQUEST_LOCATION_PERMISSION
//                 )
//             } else {
//                 if (isLocationEnabled()) {
//                     val bondedDevices: Set<BluetoothDevice> = bluetoothAdapter.bondedDevices
   

    

//     // Find the specific printer by name
//     val targetDevice: BluetoothDevice = bondedDevices.find { it.name == "X5h-F31B" }
//     if (targetDevice == null) {
//         Log.d("tergetDevice","Printer with X5h-F31B name   not found.")
//         return
//     }

//     // UUID for Serial Port Profile (SPP)
//     val universalUUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")

//     try {
//         // Create a socket and connect
//         val socket: BluetoothSocket = targetDevice.createRfcommSocketToServiceRecord(universalUUID)
//         println("Connecting to ${targetDevice.name}...")
//         socket.connect()
        

//     } catch (e: IOException) {
//         println("Connection failed: ${e.message}")
//         e.printStackTrace()
//     }

//                 } else {
//                     openLocationSettings()
//                 }


//             }

//         }

//     }.start()

// }
    fun createPrintData(): ByteArray {
        val printData = StringBuilder()

        // Centered, bold title
        printData.append("01") // Center alignment
        printData.append("01") // Bold ON
        printData.append("Welcome to My Store\n")
        printData.append("00") // Bold OFF

        // Left aligned, normal text
        printData.append("00") // Left alignment
        printData.append("Item         Price\n")
        printData.append("--------------------------\n")

        // Example item rows
        printData.append("Apple        $1.00\n")
        printData.append("Orange       $0.80\n")

        // Total in bold
        printData.append("01") // Bold ON
        printData.append("Total        $1.80\n")
        printData.append("00") // Bold OFF

        // Add a few new lines for spacing
        printData.append("\n\n")

        // Convert the string to bytes
        return printData.toString().toByteArray()
    }

    private fun dataPrintingMethod(address: String){
        val data = createPrintData()

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

                    try {


                        // Get the output stream to send data to the printer

                        val outputStream: OutputStream = bluetoothSocket!!.outputStream
//                    outputStream.write(data["this"].toString().toByteArray())
//                    outputStream.flush()
//                    Log.d("printed","data is printed")
//                    outputStream.close
                        val escPosCommand = "\u001B\u0040"  // ESC @ (Initialize printer)
                        val dataToPrint = "$escPosCommand this is print data\n"  // ESC @ followed by your data
                        outputStream.write(dataToPrint.toByteArray(Charsets.UTF_8))
                        outputStream.flush()
//                        socket!!.close()
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

                    try {
//                    Log.d("devicePrint","$device")
//                    Log.d("uuid","$uuid")
//
//                    Log.d("socket","$socket")
//                    Log.d("connection","${socket!!.connect()}")
                        if (!bluetoothSocket!!.isConnected){
                            Log.d("bluetoothSocket","bluetooth socket is not connected")
                        }


                        // Get the output stream to send data to the printer

//                        val outputStream: OutputStream = bluetoothSocket!!.outputStream

                        bluetoothSocket?.let {
                            if (it.isConnected) {
                                Log.d("Connected","socket is connected")
                                Log.d("printIt","$it")
//                                it.outputStream.apply {
//                                    Log.d("apply","applyings it")
//                                    Log.d("printWrite","${write(byteArrayOf(0x1B, 0x40))}")
//                                    Log.d("printData","$data")
//                                    write(byteArrayOf(0x1B, 0x40))
//                                    write(data)
//                                    flush()
//                                }
                               val outputStream = it.outputStream
                               Log.d("outputsteam","$outputStream")
                                val format = byteArrayOf(27, 33, 0)
                                val initializePrinter = byteArrayOf(0x1B, 0x40) // ESC @ (initializes printer)
                                val lineBreak = byteArrayOf(0x0A)
                                val printData = byteArrayOf(0x1B, 0x40) + "Hello, Printer!".toByteArray() +  byteArrayOf(0x1B, 0x69)
                                val formattedText = """
        [L]
        [C]<u><font size='big'>ORDER N°045</font></u>
        [L]
        [C]================================
        [L]
        [L]<b>BEAUTIFUL SHIRT</b>[R]9.99e
        [L]  + Size : S
        [L]
        [L]<b>AWESOME HAT</b>[R]24.99e
        [L]  + Size : 57/58
        [L]
        [C]--------------------------------
        [L][R]TOTAL PRICE :[R]34.98e
        [L][R]TAX :[R]4.23e
        [L]
        [C]================================
        [L]
        [L]<font size='tall'>Customer :</font>
        [L]Raymond DUPONT
        [L]5 rue des girafes
        [L]31547 PERPETES
        [L]Tel : +33801201456
        [L]
        [C]<barcode type='ean13' height='10'>831254784551</barcode>
    """.trimIndent()
                                try {
                                    outputStream.write(formattedText.toByteArray())
//                                    outputStream.write(INIT)
                                    outputStream.flush()

                                }catch (e:IOException){
                                    Log.d("outputStreamError","${e.message}")
                                }
//                                outputStream.write(initializePrinter)
//                                outputStream.write("Hello, Printer!\n\n".toByteArray())
//                                outputStream.write(lineBreak) // Add line break for spacing
//
//                                // Send line breaks to ensure content is fully printed
//                                outputStream.write(lineBreak)


                            }
                        }

//                        val  outputStream = bluetoothSocket!!.getOutputStream()
//                        Log.d("outputStream","$outputStream")
//                    outputStream.write(data["this"].toString().toByteArray())
//                    outputStream.flush()
//                    Log.d("printed","data is printed")
//                    outputStream.close
//                        val escPosCommand = "\u001B\u0040"  // ESC @ (Initialize printer)
//                        val dataToPrint = "$escPosCommand this is print data\n"  // ESC @ followed by your data
//                        outputStream.write("this is the data  i need to print\r\n".toByteArray(Charsets.UTF_8))
////                        Log.d("printedData","${data["this"]}")
////                        Thread.sleep(5000)
////                        Log.d("printed","data is printed")
//                        outputStream.flush()
//                        outputStream.close()

                        // Close the socket

//                        socket!!.close()
                    }catch (e:IOException){

//                      keepAlive = true
//                    e.printStackTrace()
                        Log.d("printError","${e.message}")

                        try {
//                            socket!!.close()
                            Log.d("bluetoothSocket","bluetooth socket is closed")
                        }catch (e:IOException){
                            Log.d("socketClosingError","${e.message}")
                        }
                    }finally {

                    }

                }else{
                    openLocationSettings()
                }



            }

        }
        Log.d("socketGet","$bluetoothSocket")
    }

private  fun connectBluetoothDevice(result: MethodChannel.Result) {
    val pairedDevice:Set<BluetoothDevice>? = bluetoothAdapter!!.bondedDevices
    Thread {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
            // Android 12 (API 31) and above
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_SCAN)
                != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(
                    this,
                    Manifest.permission.BLUETOOTH_CONNECT
                )
                != PackageManager.PERMISSION_GRANTED
            ) {
                // Request Bluetooth permissions for Android 12+
                ActivityCompat.requestPermissions(
                    this, arrayOf(
                        Manifest.permission.BLUETOOTH_SCAN,
                        Manifest.permission.BLUETOOTH_CONNECT,
                        Manifest.permission.BLUETOOTH_ADVERTISE
                    ), REQUEST_BLUETOOTH_PERMISSIONS
                )


            } else {
                if (isLocationEnabled()) {
                    //  val targetDevice: BluetoothDevice = pairedDevice!!.find { it.name == "X5h-F31B" }
                    val targetDevice: BluetoothDevice? = pairedDevice!!.find { it.name == "X5h-F31B" }
                    Log.d("targetDevice","$targetDevice")
                    // Log.d("bondedDevice","$pairedDevice")

                     val universalUUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")

                        try {
                            // Create a socket and connect
                            val socket: BluetoothSocket = targetDevice!!.createRfcommSocketToServiceRecord(universalUUID)
                            // println("Connecting to ${targetDevice.name}...")
                            socket.connect()
                            result.success(true)

                        } catch (e: IOException) {
                            println("Connection failed: ${e.message}")
                            e.printStackTrace()
                            result.success(false)
                        }


                } else {
                    openLocationSettings()
                }
            }
        } else if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
            // Android 6.0 (API 23) to Android 11 (API 30)
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED
            ) {
                // Request Location permission for Bluetooth scanning (Android 6 to 11)
                ActivityCompat.requestPermissions(
                    this,
                    arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                    REQUEST_LOCATION_PERMISSION
                )
            } else {
                if (isLocationEnabled()) {
                    // val targetDevice: BluetoothDevice = pairedDevice.find { it.name == "X5h-F31B" }
                    val targetDevice: BluetoothDevice? = pairedDevice!!.find{it.name == "X5h-F31B"}
                    Log.d("targetDevice","$targetDevice")
                    // Log.d("bondedDevice","$pairedDevice")
                     val universalUUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")

                        try {
                            // Create a socket and connect
                            val socket: BluetoothSocket = targetDevice!!.createRfcommSocketToServiceRecord(universalUUID)
                            // println("Connecting to ${targetDevice.name}...")
                            socket.connect()
                            result.success(true)
                            

                        } catch (e: IOException) {
                            println("Connection failed: ${e.message}")
                            e.printStackTrace()
                            result.success(false)
                        }
                    




                } else {
                    openLocationSettings()
                }


            }

        }

    }.start()
}
private fun processDeviceData(device:BluetoothDevice){
    Thread{
        val uuids = device.uuids
        Log.d("listOfUUID","$uuids")
        if (uuids != null && uuids.isNotEmpty()) {
            // Use the first UUID (or iterate over if needed)
            val uuid = uuids[0].uuid
            Log.d("printUUID","${uuid.javaClass}")
            val data = mapOf(
                "this" to "this is data"
            )
            var socket: BluetoothSocket? = device.createRfcommSocketToServiceRecord(uuid)

            Log.d("socketConnection","$socket")
            try {
               socket!!.connect()
               sendKeepAlive(socket!!)
            }catch (e:IOException){
                 Log.d("socketException","${e.message}")
            }



        }
    }.start()
}

    private val keepAliveThread = Thread {
        while (keepAlive) {
            try {
                // Send keep-alive packet (adjust to your specific method)
                bluetoothSocket?.outputStream?.write("ping".toByteArray())
                Thread.sleep(5000) // interval for keep-alive
            } catch (e: IOException) {
                Log.e("KeepAlive", "Failed to send keep-alive", e)
                break
            } catch (e: InterruptedException) {
                Thread.currentThread().interrupt()
                break
            }
        }
    }
    fun sendKeepAlive(socket: BluetoothSocket) {
        Thread{
            if(keepAlive){
                val handler = Handler(Looper.getMainLooper())
                val keepAliveRunnable = object : Runnable {
                    override fun run() {
                        try {
                            socket.outputStream.write("ping".toByteArray())
                            handler.postDelayed(this, 2000)  // Send every 2 seconds
                        } catch (e: IOException) {
                            Log.d("KeepAlive", "Failed to send keep-alive: ${e.message}")
                        }
                    }
                }
                handler.post(keepAliveRunnable)
            }

        }.start()

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
                    val bluetoothDevice: BluetoothDevice = bluetoothAdapter!!.getRemoteDevice("${device.address}")
                    Log.d("connectedDevice","$bluetoothDevice")
                    val deviceClass = bluetoothDevice.bluetoothClass.deviceClass
                    val majorDevice = bluetoothDevice.bluetoothClass.majorDeviceClass
                    val minorDevice = deviceClass and 0xFF

                    Log.d("majorDevice","$majorDevice")
                    Log.d("minorDevice","$minorDevice")
                    Log.d("deviceClass","$deviceClass")

                    if (majorDevice == BluetoothClass.Device.Major.HEALTH) {
                        Log.d("inMajor","i am in major and got imaging device")
                        pairDevice(bluetoothDevice)
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

                    val outputStream: OutputStream = socket!!.outputStream
//                    outputStream.write(data["this"].toString().toByteArray())
//                    outputStream.flush()
//                    Log.d("printed","data is printed")
//                    outputStream.close
                    val escPosCommand = "\u001B\u0040"  // ESC @ (Initialize printer)
                    val dataToPrint = "$escPosCommand${data["this"]}\n"  // ESC @ followed by your data
                    outputStream.write(dataToPrint.toByteArray(Charsets.UTF_8))
                    outputStream.flush()
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
                    if (!socket!!.isConnected){
                        socket!!.connect()
                        Log.d("bluetoothSocket","bluetooth socket is connected")
                    }


                    // Get the output stream to send data to the printer

                    val outputStream: OutputStream = socket!!.outputStream
                    Log.d("outputStream","$outputStream")
                    val escPosCommand = "\u001B\u0040"  // ESC @ (Initialize printer)
                    val dataToPrint = "$escPosCommand${data["this"]}\n"  // ESC @ followed by your data
                    outputStream.write(dataToPrint.toByteArray(Charsets.UTF_8))
                    outputStream.flush()
                    Log.d("printedData","${data["this"]}")
                    Thread.sleep(5000)
                    Log.d("printed","data is printed")
                    outputStream.close()

                    // Close the socket

                    socket!!.close()
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

private fun pairDevice(device: BluetoothDevice) {
        try {
            val method = device.javaClass.getMethod("createBond")
            method.invoke(device)
        } catch (e: Exception) {
            e.printStackTrace()
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
                        val devices = discoveredDevices.map{ device ->
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
