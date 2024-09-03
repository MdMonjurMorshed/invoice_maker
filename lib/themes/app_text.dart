import 'package:flutter/material.dart';

class AppText {
  //Global textfield text style starts

  final labelText = TextStyle(color: Colors.purple[400]);

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
  final loginButtonText = TextStyle(color: Colors.white);
  final googleSigninBurronText = TextStyle(color: Colors.white);
  final orText = TextStyle(color: Colors.purple[400], fontSize: 25);
  // login page theme ends

  // signup page theme starts
  final signupHeader = TextStyle(color: Colors.purple[400], fontSize: 25);
  final loginTextBtn = TextStyle(
    color: Colors.purple[400],
    fontSize: 15,
  );
  final signupButtonText = TextStyle(color: Colors.white);

  // signup page theme ends

  // Auction  page starts

  final productLabelText = TextStyle(color: Colors.red, fontSize: 20);
  final bidButtonText = TextStyle(
    color: Colors.white,
  );

  final tableTitleText = TextStyle(fontSize: 20);
  final tableHeaderText = TextStyle(fontSize: 20);
  final tableCellText = TextStyle(fontSize: 18);

  final winingGreeting = TextStyle(fontSize: 25, color: Colors.red);
  final winingDetails = TextStyle(fontSize: 20, color: Colors.red);

  // Auction page ends

  AppText();
}
