import 'dart:io';

import 'package:blue_print_pos/blue_print_pos.dart';
import 'package:blue_print_pos/models/blue_device.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PrintController extends GetxController {
  final BluePrintPos bluePrintPos = BluePrintPos.instance;
  RxList<BlueDevice> blueDevice = <BlueDevice>[].obs;

  Future<void> onBluetoothDeviceScan() async {
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect
      ].request();

      if (statuses[Permission.bluetoothScan] != PermissionStatus.granted ||
          statuses[Permission.bluetoothConnect] != PermissionStatus.granted) {
        return;
      }
    }

    bluePrintPos.scan().then((List<BlueDevice> devices) {
      blueDevice.value = devices;
    });
  }
}
