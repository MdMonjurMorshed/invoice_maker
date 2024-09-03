import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      title: 'Auction BD24',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appThemeData(),
      initialBinding: ControllerBindings(),
      getPages: AppRoute.getPage,
      home: AuctionSplash(),
    );
  }
}


