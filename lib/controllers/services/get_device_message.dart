import 'package:flutter/services.dart';

class NormalMethodCall {
  static const MethodChannel channel =
      MethodChannel('com.swad_electric__bill_maker/simpleMethodCall');

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
      List<dynamic>? bluetoothDevice = await channel.invokeMethod(
        "scanBluetoothDevice",
      );
      deviceValue = bluetoothDevice!;
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
}
