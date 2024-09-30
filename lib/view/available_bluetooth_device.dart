import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swad_electric__bill_maker/controllers/bindings/bindings.dart';
import 'package:swad_electric__bill_maker/controllers/controller/print_controller.dart';
import 'package:swad_electric__bill_maker/controllers/services/get_device_message.dart';
import 'package:swad_electric__bill_maker/controllers/services/scan_bluetooth_devices.dart';
import 'package:swad_electric__bill_maker/themes/app_theme.dart';

class BlueToothDevicesNearBy extends StatelessWidget {
  const BlueToothDevicesNearBy({super.key});

  @override
  Widget build(BuildContext context) {
    final printController = Get.find<PrintController>();
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Bluetooth devices Nearby',
              style: AppTheme.appText.appBarTitle),
        ),
        body: SingleChildScrollView(
          child: Center(child: Text('')
              // Obx(() => Column(children: []
              //     List.generate(printController.devices.length, (index) {
              //   return Padding(
              //     padding: const EdgeInsets.only(top: 15),
              //     child: GestureDetector(
              //       onTap: () {
              //         printController.makeBluetoothConnection(
              //             printController.devices[index].name,
              //             printController.devices[index].macAdress);
              //       },
              //       child: Container(
              //         height: mediaHeight / 11,
              //         width: mediaWidth / 1.5,
              //         decoration: BoxDecoration(
              //           border: Border.all(width: 3),
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 ' Device: ${printController.devices[index].name}',
              //                 style: AppTheme
              //                     .appText.availableBluetoothTextStyle,
              //               ),
              //               Text(
              //                 ' Status: ${printController.connectedWith.value == printController.devices[index].name ? "Connected" : "Not connected"} ',
              //                 style: AppTheme
              //                     .appText.availableBluetoothTextStyle,
              //               )
              //             ]),
              //       ),
              //     ),
              //   );
              // }),
              // )),
              ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              var bluetoothStatus =
                  await NormalMethodCall.checkBluetoothAdapter();

              if (!bluetoothStatus) {
                print("bluetooth not enabled");
                showDialog(
                    context: context,
                    builder: (BuildContext contect) {
                      return AlertDialog(
                        title: Text("Bluetooth Not Enabled"),
                        content: Text("Do you want to enable bluetooth?"),
                        alignment: Alignment.center,
                        actionsAlignment: MainAxisAlignment.spaceAround,
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('no')),
                          ElevatedButton(
                              onPressed: () async {
                                final bool enabled =
                                    await NormalMethodCall.enableBluetooth();
                                print("bluetooth enabled:${enabled}");
                                if (enabled) {}
                              },
                              child: Text("yes")),
                        ],
                      );
                    });
              } else {
                print("bluetooth is connected");
                await printController.getBluetoothDevices();
                print(
                    "print controller device value:${printController.bluetoothDevices}");
              }
              // FindBluetoothDeviceMethodCall.checkBluetoothAdapter();
              // printController.
              // printController.findBluetoothDevice();
              // printController.scanBluetoothDevices();
            },
            icon: Icon(Icons.search_rounded),
            label: Text('Scan')));
  }
}
