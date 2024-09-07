import 'package:get/get.dart';
import 'package:swad_electric__bill_maker/view/landing_page.dart';
import 'package:swad_electric__bill_maker/view/splash_screen.dart';

class AppRoute {
  static List<GetPage> getPage = [
    // GetPage(
    //     name: '/',
    //     page: () => BillMakerSplashScreen(),
    //     transition: Transition.fadeIn,
    //     transitionDuration: Duration(milliseconds: 500)),
    GetPage(
        name: '/landing',
        page: () => LandingPage(),
        transition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: 500))
  ];
}
