import 'package:get/get.dart';
import 'package:swad_electric__bill_maker/controllers/controller/form_controller.dart';
import 'package:swad_electric__bill_maker/controllers/controller/internet_controller.dart';
import 'package:swad_electric__bill_maker/controllers/controller/print_controller.dart';
import 'package:swad_electric__bill_maker/controllers/controller/radio_button_controller.dart';
import 'package:swad_electric__bill_maker/controllers/controller/splash_screen_controller.dart';

class DependencyInjection {
  static void init() {
    Get.put<InternetController>(InternetController(), permanent: true);
    Get.put<SplashScreenController>(SplashScreenController());
    Get.put<RadioButtonController>(RadioButtonController());
    Get.put<FormController>(FormController());
    Get.put<PrintController>(PrintController(), permanent: true);

  }
}
