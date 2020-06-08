import 'package:ShopZero/authenticate/login.dart';
import 'package:ShopZero/authenticate/register.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
 @override
 _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State <Authenticate> {

//if showSignIn true then show login page if not go to register page
 bool showSignIn = true;
 void toggleView() {
  print(showSignIn.toString());
  setState(() => showSignIn = !showSignIn);
 }

 @override
 Widget build(BuildContext context) {
  if (showSignIn) {
   return Login(toggleView: toggleView);
  } else {
   return RegisterPage(toggleView: toggleView);
  }
 }
}