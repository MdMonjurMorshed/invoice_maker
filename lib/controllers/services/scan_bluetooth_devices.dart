import 'package:flutter/services.dart';

class FindBluetoothDeviceMethodCall {
  static const MethodChannel channel1 = MethodChannel('bluetoothChannel');

  static Future<List> getBluetoothDeviceMethodCallResult() async {
    final List? data = await channel1.invokeMethod('discoverBluetoothDevices');
    print(data);
    return data!;
  }
}
