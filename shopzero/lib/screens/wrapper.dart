import 'package:ShopZero/authenticate/authenticate.dart';
import 'package:ShopZero/models/user.dart';
import 'package:ShopZero/screens/admin.dart';
import 'package:ShopZero/services/dashboard_service.dart';
import 'package:ShopZero/services/database.dart';
import 'package:ShopZero/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
 @override
 Widget build(BuildContext context) {

  final user = Provider.of < User > (context);

  // return either the Dashboard or Authenticate widget
  if (user == null) {
   return Authenticate();
  } else {
   return AccountCheck();
  }
 }
}

//if user isn't admin then user dashboard otherwise admin page
class AccountCheck extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
  User user = Provider.of < User > (context);
  return StreamBuilder < UserData > (
   stream: DatabaseService(uid: user.uid).userData,
   builder: (context, snapshot) {
    if (snapshot.hasData) {
     UserData userData = snapshot.data;
     if (userData.userRole == 'admin') {
      return Admin();
     } else {
      return DashboardMain();
     }
    } else {
     return Loading();
    }
   }
  );
 }
}