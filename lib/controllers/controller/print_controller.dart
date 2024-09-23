import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swad_electric__bill_maker/controllers/services/get_device_message.dart';

class PrintController extends GetxController {
  RxList checkList = [].obs;
  // NormalMethodCall normalMethodCall = NormalMethodCall();

  Future<String> getMethodCallData() async {
    String data = await NormalMethodCall.getNormalMethodCallResult();
    print(data);
    return data;
  }

  // BluePrintPos bluePrintPos = BluePrintPos.instance;
  // RxList<BlueDevice> devices = <BlueDevice>[].obs;

  // void scanForDevices() {
  //   printerManager.scanResults.listen((printers) async {
  //     print(printers);
  //   });
  //   printerManager.startScan(Duration(seconds: 4));

  //   print("clicked");
  // }
  // RxList<BluetoothInfo> devices = <BluetoothInfo>[].obs;
  // RxString connectedWith = ''.obs;

  // void scanBluetoothDevices() async {
  //   final List<BluetoothInfo> pairedDevices =
  //       await PrintBluetoothThermal.pairedBluetooths;

  //   devices.value = pairedDevices;
  // }

  // void makeBluetoothConnection(String name, String address) async {
  //   final bool connect =
  //       await PrintBluetoothThermal.connect(macPrinterAddress: address);
  //   if (connect) {
  //     connectedWith.value = name;
  //   } else {
  //     Get.showSnackbar(GetSnackBar(
  //       title: "Bluetooth connection",
  //       message: "No device found",
  //       duration: Duration(seconds: 2),
  //     ));
  //   }
  // }
}
