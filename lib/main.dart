import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swad_electric__bill_maker/themes/app_theme.dart';
import 'package:swad_electric__bill_maker/routes/app_route.dart';
import 'package:swad_electric__bill_maker/view/splash_screen.dart';
import 'package:swad_electric__bill_maker/controllers/bindings/bindings.dart';
import 'package:flutter/services.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  DependencyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Messers Swad Enterprize',
      theme: AppTheme.appThemeData(),
      getPages: AppRoute.getPage,
      home: BillMakerSplashScreen(),
    );
  }
}
