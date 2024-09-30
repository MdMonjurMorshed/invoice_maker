import 'package:flutter/services.dart';

class FindBluetoothDeviceMethodCall {
  static const MethodChannel channel1 = MethodChannel('bluetoothChannel');

  static Future<bool> checkBluetoothAdapter() async {
    bool? isBluetoothAdapterEnabled;
    try {
      final adapter = await channel1.invokeMethod("chekckpermission");
      isBluetoothAdapterEnabled = adapter;
    } catch (e) {
      print("${e}");
    }
    return isBluetoothAdapterEnabled!;
  }

  static Future<String> getBluetoothStatus() async {
    var returnValue = "";
    channel1.setMethodCallHandler((call) {
      if (call.method == "onBluetoothEnabled") {
        returnValue = call.arguments;
      }
      if (call.method == "onBluetoothDisabled") {
        returnValue = call.arguments;
      }
      return call.arguments;
    });
    return returnValue;
  }

  static Future<dynamic> getBluetoothDeviceMethodCallResult() async {
    //   print(await channel1.invokeMethod('discoverBluetoothDevices'));
    //   final List? data = await channel1.invokeMethod('discoverBluetoothDevices');
    //   print(data);
    //   return data!;
    final data_1 = channel1.invokeMethod("chekckpermission");
    print(data_1);

    return [];
  }
}
