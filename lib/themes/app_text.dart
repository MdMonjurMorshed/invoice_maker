import 'package:flutter/material.dart';

class AppText {
  //Global textfield text style starts

  final labelText = TextStyle(color: Colors.purple[400]);
  final internetCheckSnackbarText =
      TextStyle(color: Colors.white, fontSize: 14);

  // internet not connection text

  final internetNotConnectedText = TextStyle(color: Colors.black, fontSize: 18);

  // app bar title
  final appBarTitle = TextStyle(color: Colors.white, fontSize: 20);

  // form field name textstyle
  final formFieldNameTitle =
      TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold);

// radio button textstyle
  final formRadioButtonText = TextStyle(fontSize: 18, color: Colors.black);

  //Global textfield text style ends

  //Global textbutton text style starts
  final submiButton = TextStyle(color: Colors.purple[400]);
  final cancelButton = TextStyle(color: Colors.purple[400]);
  //Global textbutton text style ends

  // Login page theme starts
  final loginHeader = TextStyle(color: Colors.purple[400], fontSize: 25);
  final signUPTextBtn = TextStyle(
    color: Colors.purple[400],
    fontSize: 15,
  );
  final loginButtonText = const TextStyle(color: Colors.white);
  final googleSigninBurronText = const TextStyle(color: Colors.white);
  final orText = TextStyle(color: Colors.purple[400], fontSize: 25);
  // login page theme ends

  // signup page theme starts
  final signupHeader = TextStyle(color: Colors.purple[400], fontSize: 25);
  final loginTextBtn = TextStyle(
    color: Colors.purple[400],
    fontSize: 15,
  );
  final signupButtonText = const TextStyle(color: Colors.white);

  // signup page theme ends

  // Auction  page starts

  final productLabelText = const TextStyle(color: Colors.red, fontSize: 20);
  final bidButtonText = const TextStyle(
    color: Colors.white,
  );

  final tableTitleText = const TextStyle(fontSize: 20);
  final tableHeaderText = const TextStyle(fontSize: 20);
  final tableCellText = const TextStyle(fontSize: 18);

  final winingGreeting = const TextStyle(fontSize: 25, color: Colors.red);
  final winingDetails = const TextStyle(fontSize: 20, color: Colors.red);

  // Auction page ends

  AppText();
}
