import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swad_electric__bill_maker/controllers/controller/print_controller.dart';

class NormalMethodCall {
  static const MethodChannel channel =
      MethodChannel('com.swad_electric__bill_maker/simpleMethodCall');
  // final printController = Get.find<PrintController>();
  static Future<String> getNormalMethodCallResult() async {
    final String data = await channel.invokeMethod('getNormalMethodCallResult');

    return data;
  }

  static Future<bool> enableBluetooth() async {
    final bool activeBluetooth = await channel.invokeMethod("enableBluetooth");
    return activeBluetooth;
  }

  static Future<List<dynamic>?> scanResultOfBluetoothDevice() async {
    print("service called");
    List<dynamic> deviceValue = [];
    try {
      print("i am in try");
      List<dynamic>? bluetoothDevice =
          await channel.invokeMethod("scanBluetoothDevice");
      deviceValue = bluetoothDevice!;
      print("try done");
    } catch (e) {
      print("exception: ${e}");
    }

    return deviceValue;
  }

  static Future<bool> checkBluetoothAdapter() async {
    bool? isBluetoothAdapterEnabled;
    try {
      final adapter = await channel.invokeMethod("chekckpermission");
      isBluetoothAdapterEnabled = adapter;
    } catch (e) {
      print("${e}");
    }
    return isBluetoothAdapterEnabled!;
  }

  static Future<List> getBondedDevices() async {
    final bondedDevices = await channel.invokeMethod("getBondedDevice");
    return bondedDevices;
  }

  static Future<bool> connectDeviceAndPrint() async {
    final printStatus = await channel.invokeMethod("connectToDevice");
    return printStatus;
  }

  static Future<bool> checkConnectionStatus() async {
    final connection = await channel.invokeMethod("connectionChecking");
    return connection;
  }

  static Future<void> printFormData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final printData = await channel.invokeMethod("printData",
        {"address": "${prefs.getString("connectedDeviceAddress")}"});
  }

  // static Future<void> connectionChecking()async{
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final checkConnetion = await channel.invokeMethod("connectionChecking",{"address":"${prefs.getString("connectedDeviceAddress")}"});
  //   // NormalMethodCall.printController.connectedDevice.value = checkConnetion;
  //
  //
  // }

  static Future<void> shareToSpecificApp(
      String filePath, String packageName) async {
    // const platform = MethodChannel('com.example.share');
    try {
      await channel.invokeMethod(
          'shareFile', {'filePath': filePath, 'packageName': packageName});
    } on PlatformException catch (e) {
      print("Failed to share file: '${e.message}'.");
    }
  }
}
