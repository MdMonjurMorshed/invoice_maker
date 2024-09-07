import 'package:get/get.dart';

class RadioButtonController extends GetxController {
  String utilityBillDesco = 'DESCO';
  String utilityBillWasa = 'WASA';
  String utilityBillGas = 'GAS';
  RxString utilityBillSelected = ''.obs;

  String accountTypePrepaid = 'Prepaid';
  String accountTypePostpaid = 'Postpaid';
  RxString accountTypeSelected = ''.obs;

  String accountRefferenceBaksh = 'Bkash';
  String accountRefferenceNagad = 'Nagad';
  String accountRefferenceRocket = 'Rocket';
  String accountRefferenceBank = 'Bank';
  RxString accountRefferenceSelected = ''.obs;
}
