import 'package:flutter/material.dart';

class AppText {
  //Global textfield text style starts

  final labelText = TextStyle(color: Colors.purple[400]);
  final internetCheckSnackbarText =
      TextStyle(color: Colors.white, fontSize: 14);

  // internet not connection text

  final internetNotConnectedText = TextStyle(color: Colors.black, fontSize: 18);

  // app bar title
  final appBarTitle =
      TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);

  // form field name textstyle
  final formFieldNameTitle =
      TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold);

// radio button textstyle
  final formRadioButtonText =
      TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500);

// text field text style
  final textFieldText =
      TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500);

// available Bluetooth device TextStyle
  final availableBluetoothTextStyle =
      TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500);

  final scanButtonTextStyle = TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500);





  // Bluetooth enable connection starts
  final yesNoButtonText = TextStyle(color: Colors.black);

  //Bluetooth enable connection ends


  // progress indicator text starts
 final circularProgressIndicatorText = TextStyle(fontSize:18,color: Colors.black );
  // progress indicator text ends


  // inside app body text starts

 final  appBodyGeneralText = TextStyle(fontSize:18,color: Colors.black );
  final  appBodyHeaderText = TextStyle(fontSize:20,color: Colors.black );


  // inside app body text ends


  // dashboard text starts
  final  appDashboardHeaderText = TextStyle(fontSize:20,color: Colors.white );
  // dashboard text ends


  AppText();
}
