import 'package:flutter/material.dart';
import 'package:swad_electric__bill_maker/themes/app_color.dart';
import 'package:swad_electric__bill_maker/themes/app_icons.dart';
import 'package:swad_electric__bill_maker/themes/app_text.dart';

class AppTheme {
  static final appColor = AppColor();
  static final appText = AppText();
  static final appIcons = AppIcons();

  AppTheme._();

  static ThemeData appThemeData() {
    return ThemeData(
        primaryColor: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white))),
        appBarTheme: AppBarTheme(
            backgroundColor: appColor.appBarColor,
            titleTextStyle: appText.appBarTitle),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            elevation: 10));
  }
}
