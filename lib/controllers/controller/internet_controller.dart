import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:swad_electric__bill_maker/themes/app_theme.dart';
import 'package:get/get.dart';

class InternetController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  RxBool internetIsActive = false.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult results) {
      _updateConnectionStatus(results);
    });

    // _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) async {
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.none) {
      internetIsActive.value = false;
      // Get.rawSnackbar(
      //     messageText: const Text('PLEASE  CONNECT TO THE INTERNET',
      //         style: TextStyle(color: Colors.white, fontSize: 14)),
      //     isDismissible: false,
      //     duration: const Duration(days: 1),
      //     backgroundColor: AppTheme.appColor.internetSnackbarColor,
      //     icon: const Icon(
      //       Icons.wifi_off,
      //       color: Colors.white,
      //       size: 35,
      //     ),
      //     margin: EdgeInsets.zero,
      //     snackStyle: SnackStyle.GROUNDED);
    } else {
      internetIsActive.value = true;
      // if (Get.isSnackbarOpen) {
      // Get.closeCurrentSnackbar();
      // }
    }
  }
}
