import 'dart:io';

import 'package:ShopZero/models/user.dart';
import 'package:ShopZero/screens/dashboard.dart';
import 'package:ShopZero/screens/settings.dart';
import 'package:ShopZero/services/auth.dart';
import 'package:ShopZero/services/database.dart';
import 'package:ShopZero/utilities/constants.dart';
import 'package:ShopZero/widgets/loading.dart';
import 'package:app_review/app_review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Vouchers extends StatefulWidget {

 @override
 _VouchersState createState() => _VouchersState();
}

class _VouchersState extends State<Vouchers> {

  FirebaseUser user;

 @override
 void initState() {
  super.initState();
  initUser();
 }

 initUser() async {
  user = await FirebaseAuth.instance.currentUser();
  setState(() {});
 }

 final AuthService _auth = AuthService();

 @override
 Widget build(BuildContext context) {
  User user = Provider.of<User>(context);
     return StreamBuilder<UserData>(
       stream: DatabaseService(uid: user.uid).userData,
       builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData = snapshot.data;
         return Scaffold(
   appBar: AppBar(
    title: Text('Vouchers'),
    centerTitle: true,
   ),
   drawer: Drawer(
           child: ListView(
             padding: EdgeInsets.zero,
            children: [
              Container(
                padding: EdgeInsets.only(top: 26.0),
                height: 120,
                child: DrawerHeader(
        child: Text('${userData?.email}', style: TextStyle(color: Colors.white, fontSize: 17),),
        decoration: BoxDecoration(
          color: Colors.teal,
        ),
      ),
              ),
              ListTile(
              title: Text("Order a replacement card"),
              onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReplacementCard()));
              },
             ),
             ListTile(
              title: Text("Newsletter"),
              onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Newsletter()));
              },
             ),
             ListTile(
              title: Text("Give App Feedback"),
              onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => Feedback()));
              },
             ),
              ExpansionTile(
              title: Text("Help & Support"),
              children: <Widget>[
              ListTile(
              title: Text("About"),
              onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
              },
             ),
                ListTile(
              title: Text("Delivery Info"),
              onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryInfo()));
              },
             ),
              ListTile(
              title: Text("Contact Us"),
              onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => Contact()));
              },
             ),
             ListTile(
              title: Text("Privacy Policy"),
              onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => Privacy()));
              },
             ),
                ],
             ),
             ListTile(
              title: Text("Logout"),
              onTap: () async {
               await _auth.signOut();
              },
             ),
            ],
           ),
          ),
   body: StreamBuilder<UserData>(
     stream: DatabaseService(uid: user.uid).userData,
       builder: (context, snapshot) {
         if(snapshot.hasData){
          UserData userData = snapshot.data;
          if(userData.scans == 10) {
       return Container(
         child: Column(
                    children: <Widget>[
            Card(
      shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
      elevation: 2,
      margin: EdgeInsets.all(12.0),
      child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              backgroundColor: Colors.white,
              title: _buildTitle(),
              leading: Icon(
        Icons.arrow_drop_down,
        size: 36.0,
      ),
              trailing: SizedBox(),
              children: <Widget>[
                QrImage(
                      data: '${user?.uid}',
                      version: QrVersions.auto,
                      size: 300,
                      errorStateBuilder: (cxt, err) {
                       return Container(
                        child: Center(
                         child: Text('Error',
                          textAlign: TextAlign.center,
                          style: new TextStyle(color: Colors.red),
                         ),
                        ),
                       );
                      },
                     ),
              ],
            ),
      ),
    ), 
    Container(
             padding: const EdgeInsets.symmetric(horizontal: 5),
             child: InkWell(
             child: Text('*View voucher Terms & Conditions', style: headings,),
             onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => VoucherTerms()));
             },
           )
            ),
                    ],
         ),
       );
          } else {
            return Container(
        child: Card(
             child: Container(
               padding: const EdgeInsets.symmetric(horizontal: 30),
            height: 100,
            child: const Center(
             child: Text('You currently have no vouches',
              style: TextStyle(
               color: Colors.black
              ),
             ),
            ),
           ),
           ),
           
       );
          }
       } else {
         return Loading();
       }
       }
   ),
 
      );
        } else {
          return Loading();
        }
       }
       );
 }
Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("10% Voucher"),
            Spacer(),
            Text("Use by 28/02/20", style: TextStyle(fontSize: 11, color: Colors.black54),),
          ],
        ),
      ],
    );
  }

}

class VoucherTerms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
          title: Text('Voucher T & Cs'),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: new FlatButton(
              child: new Text('Back', style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: () {Navigator.pop(context);
                },
            ),
              ),
          ],
          ),
          body: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Text('Where can you use your vouchers:', style: headings),
                  SizedBox(height: 10),
                  Text('Use once in-store at ShopZero on selected products in store under shop owners restrictions.', style: textStyles),
                  SizedBox(height: 10),
                  Text('Where your vouches cannot be used:', style: headings),
                  SizedBox(height: 10),
                  Text('Vouchers cannot be used online just yet as the app is in early implementation, this feature will be comming soon by the end of 2020.', style: textStyles),
                  SizedBox(height: 10),
                  Text('Any voucher is not for resale or useable again, vouchers are only valid in the UK and copying vouchers will not be accepted. Age restrictions apply. Valid for use only by the recipient. Terms and conditions apply.', style: textStyles),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
    );
  }
}

// The existing imports
// !! Keep your existing impots here !!

/// main is entry point of Flutter application
void main() {
  // Desktop platforms aren't a valid platform.
  if (!kIsWeb) _setTargetPlatformForDesktop();
  return runApp(Feedback());
}

/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

class Feedback extends StatefulWidget {
  @override
  _FeedbackState createState() => new _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  @override
  void initState() {
    super.initState();
    AppReview.getAppID.then((String onValue) {
      setState(() {
        appID = onValue;
      });
      print("App ID" + appID);
    });
  }

  String appID = "";
  String output = "";

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
      appBar: AppBar(  
          title: Text('App Feedback'),
          backgroundColor: new Color(0xFF009688), 
          centerTitle: true,
          leading: new IconButton(
    icon: new Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pop(context);
    }
          ),
          ),
        body: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Container(
                height: 40.0,
              ),
              new ListTile(
                leading: const Icon(Icons.info),
                title: const Text('App ID'),
                subtitle: new Text(appID),
                onTap: () {
                  AppReview.getAppID.then((String onValue) {
                    setState(() {
                      output = onValue;
                    });
                    print(onValue);
                  });
                },
              ),
              const Divider(height: 20.0),
              new ListTile(
                leading: const Icon(
                  Icons.shop,
                ),
                title: const Text('View Store Page'),
                onTap: () {
                  AppReview.storeListing.then((String onValue) {
                    setState(() {
                      output = onValue;
                    });
                    print(onValue);
                  });
                },
              ),
              const Divider(height: 20.0),
              new ListTile(
                leading: const Icon(
                  Icons.star,
                ),
                title: const Text('Request Review'),
                onTap: () {
                  AppReview.requestReview.then((String onValue) {
                    setState(() {
                      output = onValue;
                    });
                    print(onValue);
                  });
                },
              ),
              const Divider(height: 20.0),
              new ListTile(
                leading: const Icon(
                  Icons.note_add,
                ),
                title: const Text('Write a New Review'),
                onTap: () {
                  AppReview.writeReview.then((String onValue) {
                    setState(() {
                      output = onValue;
                    });
                    print(onValue);
                  });
                },
              ),
              const Divider(height: 20.0),
              new ListTile(title: new Text(output)),
            ],
          ),
        ),
      ),
    );
  }
}

class VoucherDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
    title: Text('Voucher'),
    centerTitle: true,
   ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 40,),
            Center(
              child: QrImage(
                        data: '${user?.uid}',
                        version: QrVersions.auto,
                        size: 350,
                        errorStateBuilder: (cxt, err) {
                         return Container(
                          child: Center(
                           child: Text('Error',
                            textAlign: TextAlign.center,
                            style: new TextStyle(color: Colors.red),
                           ),
                          ),
                         );
                        },
                       ),
            ),
          ],
        ),
      ),
    );
  }
  
}