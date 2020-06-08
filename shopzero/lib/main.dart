import 'package:ShopZero/providers/auth_notifier.dart';
import 'package:ShopZero/providers/events_notifier.dart';
import 'package:ShopZero/services/auth.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/wrapper.dart';


void main() {

 runApp((MultiProvider(
  providers: [
   ChangeNotifierProvider(
    create: (context) => EventsNotifier(),
   ),
   ChangeNotifierProvider(
    create: (context) => AuthNotifier(),
   ),
  ],
  child: MyApp(),
 )));

}

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
  return StreamProvider.value(
   value: AuthService().user,
   child: MaterialApp(
    builder: DevicePreview.appBuilder,
    title: 'Shop Zero',
    theme: ThemeData(
     primarySwatch: Colors.teal,
    ),
    home: Wrapper()
   ),
  );
 }
}

//https://github.com/JulianCurrie/CwC_Flutter/tree/firebase_series
//https://github.com/iamshaunjp/flutter-firebase