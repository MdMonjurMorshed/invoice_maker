import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swad_electric__bill_maker/view/home_page.dart';
import 'package:swad_electric__bill_maker/view/landing_page.dart';

class BillMakerSplashScreen extends StatelessWidget {
  const BillMakerSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      // Navigator.pushReplacement(
      //     context, GetPageRoute(page: () => LandingPage()));
      Get.off(HomePage());
    });

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Container(
          width: width / 2,
          height: height / 4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: AssetImage('assets/splashScreen/swad_logo.png'),
                  fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
