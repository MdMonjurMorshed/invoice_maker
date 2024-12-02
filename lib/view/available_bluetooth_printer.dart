// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:swad_electric__bill_maker/controllers/services/get_device_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/controller/print_controller.dart';
// import '../model/mock_device.dart';
import '../themes/app_theme.dart';

class AvailableBluetoothPrinter extends StatelessWidget {
  AvailableBluetoothPrinter({super.key});

  @override
  Widget build(BuildContext context) {
    final printController = Get.find<PrintController>();
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth Printers"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: List.generate(
                printController.bluetoothDevices.value.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(top: 15),
                child: GestureDetector(
                  onTap: () async {
                    // printController.makeBluetoothConnection(
                    //     printController.devices[index].name,
                    //     printController.devices[index].macAdress);
                    printController.connectDevice(
                        printController.bluetoothDevices.value[index]);
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    // printController.setConnect(deviceList![index]["address"]);
                    // final connectionData = await NormalMethodCall.connectDeviceAndPrint(deviceList![index]["address"]);
                    // if (connectionData["status"]){
                    //   print(connectionData);
                    //   printController.connectedDevice.value = true;
                    //   final mockBluetoothDevice = MockBluetoothDevice(address:deviceList![index]["address"] ,name:deviceList![index]["name"] );
                    //   // final mockPrinterDevice = MockPrinterBluetooth(mockBluetoothDevice) as PrinterBluetooth;
                    //   printController.testPrint(deviceList![index]["address"]);
                    //
                    //   await prefs.setString("connectedDeviceAddress", connectionData["device"]);
                    //
                    //   print("data from shared preference: ${prefs.getString("connectedDeviceAddress")}");
                    //
                    //
                    // }
                    Get.back();
                  },
                  child: Container(
                    height: mediaHeight / 11,
                    width: mediaWidth / 1.2,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: const Offset(
                            5.0,
                            5.0,
                          ),
                          blurRadius: 12.0,
                          spreadRadius: 0.0,
                        ), //BoxShadow
                        BoxShadow(
                          color: Colors.white,
                          offset: const Offset(0.0, 0.0),
                          blurRadius: 1,
                          spreadRadius: 1,
                        ), //BoxShadow
                      ],
                      border: Border.all(width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ' Device: ${printController.bluetoothDevices.value[index].name} ',
                            style: AppTheme.appText.availableBluetoothTextStyle,
                          ),
                          Text(
                            ' Address: ${printController.bluetoothDevices.value[index]} ',
                            style: AppTheme.appText.availableBluetoothTextStyle,
                          )
                        ]),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
