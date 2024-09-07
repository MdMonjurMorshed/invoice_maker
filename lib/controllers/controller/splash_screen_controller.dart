import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  RxBool activeSplashScreen = true.obs;

  @override
  void onInit() {
    super.onInit();
    _splashScreenTime();
  }

  void _splashScreenTime() {
    Future.delayed(Duration(seconds: 8));
    activeSplashScreen.value = false;
  }
}
