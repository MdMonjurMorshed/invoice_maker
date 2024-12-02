import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormController extends GetxController {
  RxString accountNumberText = ''.obs;
  RxString energyCostText = ''.obs;
  RxDouble totalAmmountText = 0.0.obs;
  TextEditingController chargesTextController = TextEditingController();
  TextEditingController complainInTextController = TextEditingController();
  TextEditingController accountNumberTextController = TextEditingController();
  TextEditingController phoneNumberTextController = TextEditingController();
  TextEditingController energyCostTextController = TextEditingController();

  RxString customerPhoneNumberText = ''.obs;

  double charges = 10;
  RxInt complain = 0.obs;

  @override
  void onInit() {
    super.onInit();
    chargesTextController.text = '10';
    totalAmmountText.value = double.parse(chargesTextController.text);
  }

  void getCustomerSupport(value) {
    if (value == "DESCO") {
      complainInTextController.text = "16120";
    } else if (value == "WASA") {
      complainInTextController.text = "16162";
    } else if (value == "GAS") {
      complainInTextController.text = "16496";
    }
  }
}
