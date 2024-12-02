import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swad_electric__bill_maker/controllers/controller/message_send_controller.dart';
import 'package:swad_electric__bill_maker/controllers/controller/print_controller.dart';
import 'package:swad_electric__bill_maker/themes/app_theme.dart';
import 'package:swad_electric__bill_maker/view/available_bluetooth_printer.dart';
import 'package:swad_electric__bill_maker/view/landing_page.dart';

import '../controllers/services/get_device_message.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key) {
    final messageSendController = Get.find<MessageSendController>();
    final printController = Get.find<PrintController>();
    messageSendController.getMessageBalance();
    printController.connectionCheck();
  }

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;
    final printController = Get.find<PrintController>();
    final messageSendController = Get.find<MessageSendController>();
    // printController.connectionCheck();
    return Scaffold(
      appBar: AppBar(
        title: Text("Swad Enterprize > Bill Maker"),
        centerTitle: true,
      ),
      body: SizedBox(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: mediaHeight / 3,
                width: mediaWidth / 1.1,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Available Message:",
                            style: AppTheme.appText.appDashboardHeaderText,
                          ),
                          SizedBox(
                            width: mediaWidth / 20,
                          ),
                          Obx(() => Text(
                                "${messageSendController.availableMessage.value}",
                                style: AppTheme.appText.appDashboardHeaderText,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: mediaHeight / 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Connection:",
                              style: AppTheme.appText.appDashboardHeaderText),
                          SizedBox(
                            width: mediaWidth / 20,
                          ),
                          Obx(() => Text(
                              "${printController.connectedDevice.value ? 'Connected' : 'Not connected'}",
                              style: AppTheme.appText.appDashboardHeaderText)),
                        ],
                      ),
                      SizedBox(
                        height: mediaHeight / 15,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            var bluetoothStatus =
                                await NormalMethodCall.checkBluetoothAdapter();
                            if (!bluetoothStatus) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext contect) {
                                    return AlertDialog(
                                      title: Text("Bluetooth Not Enabled"),
                                      content: Text(
                                          "Do you want to enable bluetooth?"),
                                      alignment: Alignment.center,
                                      actionsAlignment:
                                          MainAxisAlignment.spaceAround,
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text(
                                              'no',
                                              style: AppTheme
                                                  .appText.yesNoButtonText,
                                            )),
                                        ElevatedButton(
                                            onPressed: () async {
                                              final bool enabled =
                                                  await NormalMethodCall
                                                      .enableBluetooth();
                                              print(
                                                  "bluetooth enabled:${enabled}");
                                              if (enabled) {
                                                Get.back();
                                              }
                                            },
                                            child: Text(
                                              "yes",
                                              style: AppTheme
                                                  .appText.yesNoButtonText,
                                            )),
                                      ],
                                    );
                                  });
                            } else {
                              // final bondedDevices = await NormalMethodCall.getBondedDevices();
                              // print("bonded devices i got: $bondedDevices");
                              // final bondedDevices =
                              //     await printController.getBondedDevices();
                              // Get.to(AvailableBluetoothPrinter());

                              // printController.scanAndConnectToPrinter();
                              printController.connectToPrinter();
                            }
                          },
                          child: Text(
                            "Connect Printer",
                            style: AppTheme.appText.appBodyGeneralText,
                          ))
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              SizedBox(
                height: mediaHeight / 15,
              ),
              SizedBox(
                height: mediaHeight / 3,
                width: mediaWidth / 1.1,
                child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              Get.to(LandingPage());
                            },
                            child: Text(
                              "Open Form",
                              style: AppTheme.appText.appBodyHeaderText,
                            ))
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(30))),
              )
            ],
          ),
        ),
      )),
    );
  }
}
