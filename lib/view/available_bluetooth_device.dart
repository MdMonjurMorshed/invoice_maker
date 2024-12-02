import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swad_electric__bill_maker/controllers/controller/print_controller.dart';
import 'package:swad_electric__bill_maker/controllers/services/get_device_message.dart';
import 'package:swad_electric__bill_maker/themes/app_theme.dart';

class BlueToothDevicesNearBy extends StatelessWidget {
  const BlueToothDevicesNearBy({super.key});

  @override
  Widget build(BuildContext context) {
    final printController = Get.find<PrintController>();
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: IconButton(onPressed: (){
              Get.back();
            }, icon: Icon(AppTheme.appIcons.backNavigationIcon,color: AppTheme.appIcons.backNavigationIconColor,size: AppTheme.appIcons.backNavigationIconSize,)),
          ),
          centerTitle: true,
          title: Text('Bluetooth devices Nearby',
              style: AppTheme.appText.appBarTitle),
        ),
        body:Obx(()=>!printController.scanForBluetoothDevice.value? Center(
          child: SingleChildScrollView(
            child: Center(child:printController.bluetoothDevices.value.isNotEmpty? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children:List.generate(printController.bluetoothDevices.value.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: GestureDetector(
                      onTap: () {
                        // printController.makeBluetoothConnection(
                        //     printController.devices[index].name,
                        //     printController.devices[index].macAdress);
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
                                ' Device: ${printController.bluetoothDevices.value} ',
                                style: AppTheme
                                    .appText.availableBluetoothTextStyle,
                              ),
                              Text(
                                ' Address: ${printController.bluetoothDevices.value} ',
                                style: AppTheme
                                    .appText.availableBluetoothTextStyle,
                              )
                            ]),
                      ),
                    ),
                  );
                }),
                ): Center(child:Text("No device found",style: AppTheme.appText.appBodyGeneralText) ) ,
                ),
          ),
        ):Center(
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.black,strokeWidth: 5,),
                Text("Searching for Devices",style: AppTheme.appText.appBodyGeneralText,),

              ],
            ),
          ),
        )),
      bottomNavigationBar: Stack(
        alignment: AlignmentDirectional.bottomCenter,
          children:[
            Container(
              height: mediaHeight/10,
              width: mediaWidth,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.black
              ),
            ),
            Container(
              height:mediaHeight/5.6 ,

              decoration: BoxDecoration(
                   shape: BoxShape.circle,
                  color: Colors.white,

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: GestureDetector(
                onTap: () async {
                  printController.scanForBluetoothDevice.value = true;
                  Future.delayed(Duration(seconds: 20),(){
                    printController.scanForBluetoothDevice.value = false;
                  });
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
                                  child: Text('no',style: AppTheme.appText.yesNoButtonText,)),
                              ElevatedButton(
                                  onPressed: () async {
                                    final bool enabled =
                                    await NormalMethodCall.enableBluetooth();
                                    print("bluetooth enabled:${enabled}");
                                    if (enabled) {
                                      Get.back();
                                    }
                                  },
                                  child: Text("yes",style: AppTheme.appText.yesNoButtonText,)),
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
                child: Container(
                  child: Center(
                    child:  Text("Scan",style:AppTheme.appText.scanButtonTextStyle,),
                  ),
                  height: mediaHeight/6,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black
                  ),
                ),
              ),
            ),


          ]
        ),


    );
  }
}
