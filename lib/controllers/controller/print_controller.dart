import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swad_electric__bill_maker/controllers/services/get_device_message.dart';
import 'package:swad_electric__bill_maker/controllers/services/scan_bluetooth_devices.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';

class PrintController extends GetxController {
  RxList checkList = [].obs;
  RxBool bluetoothStatus = true.obs;
  // RxList bluetoothDevices = [].obs;
  RxBool scanForBluetoothDevice = false.obs;

  RxBool connectedDevice = false.obs;

  RxString connectedDeviceAddress = "".obs;
  // BlueThermalPrinter printer = BlueThermalPrinter.instance;
  RxList<BluetoothDevice> bluetoothDevices = <BluetoothDevice>[].obs;
  BluetoothDevice? selectedDevice;
  FlutterBluePlus flutterBlue = FlutterBluePlus();

  // PrinterBluetoothManager printerManager = PrinterBluetoothManager();

  // NormalMethodCall normalMethodCall = NormalMethodCall();
  static const MethodChannel channel =
      MethodChannel('com.swad_electric__bill_maker/simpleMethodCall');
  Future<String> getMethodCallData() async {
    String data = await NormalMethodCall.getNormalMethodCallResult();
    print(data);
    return data;
  }

  Future<void> getBluetoothDevices() async {
    print("controller called");
    // final devices = await NormalMethodCall.scanResultOfBluetoothDevice();
    // bluetoothDevices.value =
    //     devices!.map((device) => Map<String, String>.from(device)).toList();
    // print(" scan device data data from method call: ${devices}");
  }

  Future<void> getBondedDevices() async {
    // final devices = await NormalMethodCall.getBondedDevices();
    // bluetoothDevices.value =
    //     devices!.map((device) => Map<String, String>.from(device)).toList();
    // print(bluetoothDevices);
    // List<BluetoothDevice> availableDevices = await printer.getBondedDevices();
    // bluetoothDevices.value = availableDevices;
    print("bonded devices are: $bluetoothDevices");
  }

  Future<void> connectDevice(BluetoothDevice device) async {
    // final connection = await printer.connect(device);
    // if (connection) {
    //   connectedDevice.value = true;
    // }
  }

  Future<void> setBluetoothStatus() async {
    String bluetoothString =
        await FindBluetoothDeviceMethodCall.getBluetoothStatus();
    if (bluetoothString == "enabled") {
      bluetoothStatus.value = true;
    }
    if (bluetoothString == "disabled") {
      bluetoothStatus.value = false;
    }
  }

  Future<void> findBluetoothDevice() async {
    var data = await FindBluetoothDeviceMethodCall
        .getBluetoothDeviceMethodCallResult();
    print(data);
  }

  Future<void> getConnectedDeviceDataFromSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    connectedDeviceAddress.value = prefs.getString("connectedDeviceAddress")!;
  }

  // void printSample() {
  //   print("printer instance: $printer");
  //   print("data is sent to the printer");
  //   printer.writeBytes(Uint8List.fromList([0x1B, 0x40])); // Initialize
  //   printer.writeBytes(Uint8List.fromList([0x1B, 0x40])); // Set font size
  //   printer.writeBytes(Uint8List.fromList([0x1B, 0x40])); // Set font style
  //   // printer.writeBytes("Hello, World!".codeUnits);
  //   printer.writeBytes(Uint8List.fromList([0x1B, 0x40]));
  //   printer.printNewLine();
  //   printer.printCustom("Hello, this is a test print!", 1, 1);
  //   printer.printNewLine();
  //   printer.printNewLine();
  //   printer.write('this is data');
  //   printer.paperCut();
  // }

  void scanAndConnectToPrinter() async {
    // Start scanning for BLE devices
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

    // Listen to scan results
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.device.name == 'X5h-F31B') {
          // Use your printer's name
          // Stop scanning
          FlutterBluePlus.stopScan();

          // Connect to the printer
          r.device.connect();
          print('Connected to ${r.device.name}');

          connectedDevice.value = true;
          selectedDevice = r.device;

          // You may need to handle disconnection
        }
      }
    });
  }

  void connectToPrinter() async {
    final connectionStatus = await NormalMethodCall.connectDeviceAndPrint();
    if (connectionStatus) {
      connectedDevice.value = true;
    }
  }

  void connectionCheck() async {
    final connectStatus = await NormalMethodCall.checkConnectionStatus();
    if (connectStatus) {
      connectedDevice.value = true;
    }
  }

  // Future<List<int>> generatePrintData() async {
  //   final profile = await CapabilityProfile.load();
  //   final generator = Generator(PaperSize.mm58, profile);

  //   List<int> bytes = [];
  //   bytes += generator.text('Hello World',
  //       styles: PosStyles(align: PosAlign.center));
  //   bytes += generator.cut();

  //   return bytes;
  // }

  void printData(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    print(services);
    for (BluetoothService service in services) {
      print("service object: $service");
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        print("charecteristic uuid: ${characteristic.uuid}");
        print(
            "charecteristic uid data type: ${characteristic.uuid.runtimeType}");
        if (characteristic.uuid ==
            Guid("0000a000-0000-1000-8000-00805f9b34fb")) {
          print("Found correct characteristic for writing data.");

          // Replace with your printer's write characteristic UUID
          // Write data to characteristic
          List<int> bytes = [
            0x1B,
            0x40
          ]; // Example data to initialize the printer, adjust as needed
          List<int> printData = [..."Hello, World\n".codeUnits, 0x0A];

          characteristic.write(bytes);
          characteristic.write(printData);
          print("Data sent to printer.");
        }
        if (characteristic.uuid == Guid("ae01")) {
          List<int> bytes = [
            0x1B,
            0x40
          ]; // Example data to initialize the printer, adjust as needed
          await characteristic.write(bytes, withoutResponse: true);
          // await characteristic.write(await generatePrintData(),
          // withoutResponse: true);
          print("Data sent to printer.");
        }
      }
    }
  }

  // Future<void> setConnect(String? mac) async {
  //   final String? result = await BluetoothThermalPrinter.connect(mac!);
  //   print("state conneected $result");
  //   if (result == "true") {
  //     connectedDevice.value = true;
  //   }
  // }

  // Future<void> printTicket() async {
  //   String? isConnected = await BluetoothThermalPrinter.connectionStatus;
  //   if (isConnected == "true") {
  //     List<int> bytes = await getTicket();
  //     // List<int> bytes = utf8.encode("Hello, Printer!\n\n\n");
  //     print(bytes);
  //     // final result = await BluetoothThermalPrinter.writeBytes(bytes);
  //     final result = await BluetoothThermalPrinter.writeText("hello there");
  //     print("Print $result");
  //   } else {
  //     //Hadnle Not Connected Senario
  //   }
  // }

  // Future<List<int>> getTicket() async {
  //   List<int> bytes = [];
  //   CapabilityProfile profile = await CapabilityProfile.load();
  //   final generator = Generator(PaperSize.mm58, profile);

  //   bytes += generator.text("Demo Shop",
  //       styles: PosStyles(
  //         align: PosAlign.center,
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ),
  //       linesAfter: 1);

  //   bytes += generator.text(
  //       "18th Main Road, 2nd Phase, J. P. Nagar, Bengaluru, Karnataka 560078",
  //       styles: PosStyles(align: PosAlign.center));
  //   bytes += generator.text('Tel: +919591708470',
  //       styles: PosStyles(align: PosAlign.center));

  //   bytes += generator.hr();
  //   bytes += generator.row([
  //     PosColumn(
  //         text: 'No',
  //         width: 1,
  //         styles: PosStyles(align: PosAlign.left, bold: true)),
  //     PosColumn(
  //         text: 'Item',
  //         width: 5,
  //         styles: PosStyles(align: PosAlign.left, bold: true)),
  //     PosColumn(
  //         text: 'Price',
  //         width: 2,
  //         styles: PosStyles(align: PosAlign.center, bold: true)),
  //     PosColumn(
  //         text: 'Qty',
  //         width: 2,
  //         styles: PosStyles(align: PosAlign.center, bold: true)),
  //     PosColumn(
  //         text: 'Total',
  //         width: 2,
  //         styles: PosStyles(align: PosAlign.right, bold: true)),
  //   ]);

  //   bytes += generator.row([
  //     PosColumn(text: "1", width: 1),
  //     PosColumn(
  //         text: "Tea",
  //         width: 5,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //         )),
  //     PosColumn(
  //         text: "10",
  //         width: 2,
  //         styles: PosStyles(
  //           align: PosAlign.center,
  //         )),
  //     PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
  //     PosColumn(text: "10", width: 2, styles: PosStyles(align: PosAlign.right)),
  //   ]);

  //   bytes += generator.row([
  //     PosColumn(text: "2", width: 1),
  //     PosColumn(
  //         text: "Sada Dosa",
  //         width: 5,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //         )),
  //     PosColumn(
  //         text: "30",
  //         width: 2,
  //         styles: PosStyles(
  //           align: PosAlign.center,
  //         )),
  //     PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
  //     PosColumn(text: "30", width: 2, styles: PosStyles(align: PosAlign.right)),
  //   ]);

  //   bytes += generator.row([
  //     PosColumn(text: "3", width: 1),
  //     PosColumn(
  //         text: "Masala Dosa",
  //         width: 5,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //         )),
  //     PosColumn(
  //         text: "50",
  //         width: 2,
  //         styles: PosStyles(
  //           align: PosAlign.center,
  //         )),
  //     PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
  //     PosColumn(text: "50", width: 2, styles: PosStyles(align: PosAlign.right)),
  //   ]);

  //   bytes += generator.row([
  //     PosColumn(text: "4", width: 1),
  //     PosColumn(
  //         text: "Rova Dosa",
  //         width: 5,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //         )),
  //     PosColumn(
  //         text: "70",
  //         width: 2,
  //         styles: PosStyles(
  //           align: PosAlign.center,
  //         )),
  //     PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
  //     PosColumn(text: "70", width: 2, styles: PosStyles(align: PosAlign.right)),
  //   ]);

  //   bytes += generator.hr();

  //   bytes += generator.row([
  //     PosColumn(
  //         text: 'TOTAL',
  //         width: 6,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //           height: PosTextSize.size4,
  //           width: PosTextSize.size4,
  //         )),
  //     PosColumn(
  //         text: "160",
  //         width: 6,
  //         styles: PosStyles(
  //           align: PosAlign.right,
  //           height: PosTextSize.size4,
  //           width: PosTextSize.size4,
  //         )),
  //   ]);

  //   bytes += generator.hr(ch: '=', linesAfter: 1);

  //   // ticket.feed(2);
  //   bytes += generator.text('Thank you!',
  //       styles: PosStyles(align: PosAlign.center, bold: true));

  //   bytes += generator.text("26-11-2020 15:22:45",
  //       styles: PosStyles(align: PosAlign.center), linesAfter: 1);

  //   bytes += generator.text(
  //       'Note: Goods once sold will not be taken back or exchanged.',
  //       styles: PosStyles(align: PosAlign.center, bold: false));
  //   bytes += generator.cut();
  //   return bytes;
  // }

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
