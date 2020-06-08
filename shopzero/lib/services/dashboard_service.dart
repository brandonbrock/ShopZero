import 'package:ShopZero/screens/dashboard.dart';
import 'package:ShopZero/screens/events.dart';
import 'package:ShopZero/screens/settings.dart';
import 'package:ShopZero/screens/vouchers.dart';
import 'package:flutter/material.dart';

class DashboardMain extends StatefulWidget {
  DashboardMainState createState()=> DashboardMainState();
}

class DashboardMainState extends State<DashboardMain> {
  
  int _currentIndex=0;
  Widget callPage(int currentIndex){
    switch (currentIndex) {
      case 0: return Dashboard();
      case 1: return Vouchers();
      case 2: return Events();
      case 3: return Settings();
        break;
      default: return Dashboard();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: callPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (value){
          _currentIndex=value;
          setState(() {
            
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard),title: Text('Dashboard')),
          BottomNavigationBarItem(icon: Icon(Icons.list),title: Text('Vouchers')),
          BottomNavigationBarItem(icon: Icon(Icons.event),title: Text('Events')),
          BottomNavigationBarItem(icon: Icon(Icons.settings),title: Text('Settings')),        
        ],
      ),
    );
  }
}
