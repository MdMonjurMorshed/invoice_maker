import 'package:flutter/material.dart';
import 'package:swad_electric__bill_maker/themes/app_color.dart';

import 'app_text.dart';

class AppTheme {
  static final appColor = AppColor();
  static final appText = AppText();
  
  AppTheme._();

  static ThemeData appThemeData() {
    
       return ThemeData(
        primaryColor: Colors.blue,
        appBarTheme: AppBarTheme(backgroundColor: Colors.purple[400]),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Colors.white,
            backgroundColor: Colors.purple[400],
            elevation: 10));
    
  }
}

