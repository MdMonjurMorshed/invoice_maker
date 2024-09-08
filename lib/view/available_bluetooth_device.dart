import 'package:flutter/material.dart';
import 'package:swad_electric__bill_maker/themes/app_theme.dart';

class BlueToothDevicesNearBy extends StatelessWidget {
  const BlueToothDevicesNearBy({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        centerTitle: true,
        title: Text('Bluetooth devices Nearby',style:AppTheme.appText.appBarTitle),
      ) ,
    );
  }
}