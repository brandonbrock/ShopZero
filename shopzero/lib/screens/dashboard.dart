import 'dart:io' show Platform;
import 'package:ShopZero/models/user.dart';
import 'package:ShopZero/screens/settings.dart';
import 'package:ShopZero/screens/vouchers.dart';
import 'package:ShopZero/services/auth.dart';
import 'package:ShopZero/services/database.dart';
import 'package:ShopZero/utilities/constants.dart';
import 'package:ShopZero/widgets/base_widget.dart';
import 'package:ShopZero/widgets/loading.dart';
import 'package:app_review/app_review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Dashboard extends StatefulWidget {

 @override
 _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State < Dashboard > {

 FirebaseUser user;
 final AuthService _auth = AuthService();

 @override
 void initState() {
  super.initState();
  initUser();
 }

 initUser() async {
  user = await FirebaseAuth.instance.currentUser();
  setState(() {});
 }



 @override
 Widget build(BuildContext context) {
  User user = Provider.of < User > (context);
  return StreamBuilder < UserData > (
   stream: DatabaseService(uid: user.uid).userData,
   builder: (context, snapshot) {
     //if the collection has data display the dashboard if not keep spinning loading widget
    if (snapshot.hasData) {
     UserData userData = snapshot.data;
     //if user scans equals ten then show dashboard verison 2 if not dashboard verison 1
     if (userData.scans == 10) {
      return BaseWidget(builder: (context, sizingInformation) {
       return Scaffold(
         //appbar
        appBar: AppBar(
         title: Text('Dashboard'),
         centerTitle: true,
        ),
        //drawer
        drawer: Drawer(
         child: ListView(
          padding: EdgeInsets.zero,
          children: [
           Container(
            padding: EdgeInsets.only(top: 26.0),
            height: 120,
            child: DrawerHeader(
              //display user email address 
             child: Text('${userData?.email}', style: TextStyle(color: Colors.white, fontSize: 17), ),
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
            children: < Widget > [
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
        body: Container(
         child: SingleChildScrollView(
          child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           children: < Widget > [
            SizedBox(height: 20),
            Card(
             elevation: 8.0,
             child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: < Widget > [
               QrImage(
                 //assign user uid to qr code to gather whole document for admin scan
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
            SizedBox(height: 10),
            Text.rich(
             TextSpan(
              children: [
               TextSpan(
                 //display to the user ammount times their qr code has been scanned
                text: '${userData?.scans}',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, )),
               TextSpan(text: ' scans', style: TextStyle(fontSize: 15))
              ],
             ),
            ),
            Padding(
             padding: EdgeInsets.all(15.0),
             child: LinearPercentIndicator(
              animation: true,
              lineHeight: 20.0,
              animationDuration: 2500,
              percent: userData.scansPercent, //convert int to double to which uses scans interger
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.teal,
             ),
            ),
            //number of scans left until user gets a voucher
            Text("${userData?.scansLeft} stamps until your next voucher of 10% off!", style: TextStyle(color: Colors.black54), ),
            Container(
             padding: const EdgeInsets.all(16.0),
              child: Center(
               child: Card(
                elevation: 1,
                child: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: < Widget > [
                   //only shows when user scans are at 10
                  ListTile(
                   leading: Icon(Icons.keyboard_arrow_down),
                   title: Text('10% off Voucher', style: textStyles, ),
                   subtitle: Text('You have gained a voucher to spend in store', style: TextStyle(fontSize: 10), ),
                   onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VoucherDetail()));
                   },
                  ),
                 ],
                ),
               ),
              ),
            )
           ],
          ),
         ),
        ),
       );
      });
     } else {
       //dashboard when vouchers equals zero
      return Scaffold(
        //appbar
       appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
       ),
       //drawer
       drawer: Drawer(
        child: ListView(
         padding: EdgeInsets.zero,
         children: [
          Container(
           padding: EdgeInsets.only(top: 26.0),
           height: 120,
           child: DrawerHeader(
             //displays current user email from user database
            child: Text('${userData?.email}', style: TextStyle(color: Colors.white, fontSize: 17), ),
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
           children: < Widget > [
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
       //main body context
       body: Container(
        child: SingleChildScrollView(
         child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: < Widget > [
           SizedBox(height: 20),
           Card(
            elevation: 8.0,
            child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: < Widget > [
              QrImage(
                //user uid assigned to qr code for admin scan
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
           SizedBox(height: 10),
           Text.rich(
            TextSpan(
             children: [
              TextSpan(
                //display number of times barcode has been scanned
               text: '${userData?.scans}',
               style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, )),
              TextSpan(text: ' scans', style: TextStyle(fontSize: 15))
             ],
            ),
           ),
           Padding(
            padding: EdgeInsets.all(15.0),
            child: LinearPercentIndicator(
             animation: true,
             lineHeight: 20.0,
             animationDuration: 2500,
             percent: userData.scansPercent, //percentage away from a voucher
             linearStrokeCap: LinearStrokeCap.roundAll,
             progressColor: Colors.teal,
            ),
           ),
           //number of scans left until next voucher
           Text("${userData?.scansLeft} stamps until your next voucher of 10% off!", style: TextStyle(color: Colors.black54), ),
           SizedBox(height: 20),
          ],
         ),
        ),
       ),
      );
     }
    } else {
     return Loading();
    }
   }
  );
 }

}

class Newsletter extends StatefulWidget {
 _NewsletterState createState() => new _NewsletterState();
}

class _NewsletterState extends State < Newsletter > {

 final _formKey = GlobalKey < FormState > ();
 String error = '';
 bool loading = false;
 String email = '';
 String firstName = '';

 @override
 Widget build(BuildContext context) {
  return Scaffold(
    //appbar
   appBar: AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
    title: Text('Newsletter'),
    //back button
    leading: new IconButton(
     icon: new Icon(Icons.arrow_back),
     onPressed: () {
      Navigator.pop(context);
     }
    ),
   ),
   //newsletter form
   body: Form(
    key: _formKey,
    child: LayoutBuilder(
     builder: (BuildContext context, BoxConstraints viewportContraints) {
      return Container(
       padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        child: SingleChildScrollView(
         child: ConstrainedBox(
          constraints: BoxConstraints(
           minHeight: viewportContraints.maxHeight,
          ),
          child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: < Widget > [
            SizedBox(height: 25),
            TextFormField(
             validator: (input) => input.isEmpty ? 'Please enter a name' : null,
             onChanged: (input) {
              setState(() => email = input);
             },
             style: TextStyle(fontSize: 18, color: Colors.black54),
             decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.red),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Full Name',
              contentPadding: const EdgeInsets.all(15),
               focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.teal
                ),
                borderRadius: BorderRadius.circular(5),
               ),
               enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.teal
                ),
                borderRadius: BorderRadius.circular(5),
               ),
             )
            ),
            SizedBox(height: 25),
            TextFormField(
             validator: (input) => input.isEmpty ? 'Please enter a email address' : null,
             onChanged: (input) {
              setState(() => email = input);
             },
             style: TextStyle(fontSize: 18, color: Colors.black54),
             decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.red),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Email',
              contentPadding: const EdgeInsets.all(15),
               focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.teal
                ),
                borderRadius: BorderRadius.circular(5),
               ),
               enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.teal
                ),
                borderRadius: BorderRadius.circular(5),
               ),
             )
            ),
            SizedBox(height: 25),
            FlatButton(child: Text(
              'Subscribe',
              style: TextStyle(
               fontSize: 20,
              ),
             ),
             shape: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal, width: 2),
              borderRadius: BorderRadius.circular(5),
             ),
             padding: const EdgeInsets.all(15),
              textColor: Colors.teal,
              onPressed: () async {
               if (_formKey.currentState.validate()) {}
              }
            ),
           ],
          ),
         ),
        ),
      );
     },
    )
   ),
  );
 }
}

class ReplacementCard extends StatefulWidget {
 _ReplacementCardState createState() => new _ReplacementCardState();
}

class _ReplacementCardState extends State < ReplacementCard > {

 final _formKey = GlobalKey < FormState > ();
 String error = '';
 bool loading = false;
 String email = '';
 String firstName = '';

 @override
 Widget build(BuildContext context) {
  return Scaffold(
    //appbar
   appBar: AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
    title: Text('Replacement Card'),
    //back button
    leading: new IconButton(
     icon: new Icon(Icons.arrow_back),
     onPressed: () {
      Navigator.pop(context);
     }
    ),
   ),
   //replacement card form
   body: Form(
    key: _formKey,
    child: LayoutBuilder(
     builder: (BuildContext context, BoxConstraints viewportContraints) {
      return Container(
       padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        child: SingleChildScrollView(
         child: ConstrainedBox(
          constraints: BoxConstraints(
           minHeight: viewportContraints.maxHeight,
          ),
          child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: < Widget > [
            SizedBox(height: 25),
            TextFormField(
             validator: (input) => input.isEmpty ? 'Please enter a name' : null,
             onChanged: (input) {
              setState(() => email = input);
             },
             style: TextStyle(fontSize: 18, color: Colors.black54),
             decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.red),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Full Name',
              contentPadding: const EdgeInsets.all(15),
               focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.teal
                ),
                borderRadius: BorderRadius.circular(5),
               ),
               enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.teal
                ),
                borderRadius: BorderRadius.circular(5),
               ),
             )
            ),
            SizedBox(height: 25),
            TextFormField(
             validator: (input) => input.isEmpty ? 'Please enter a email address' : null,
             onChanged: (input) {
              setState(() => email = input);
             },
             style: TextStyle(fontSize: 18, color: Colors.black54),
             decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.red),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Email',
              contentPadding: const EdgeInsets.all(15),
               focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.teal
                ),
                borderRadius: BorderRadius.circular(5),
               ),
               enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.teal
                ),
                borderRadius: BorderRadius.circular(5),
               ),
             )
            ),
            SizedBox(height: 25),
            FlatButton(child: Text(
              'Submit',
              style: TextStyle(
               fontSize: 20,
              ),
             ),
             shape: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal, width: 2),
              borderRadius: BorderRadius.circular(5),
             ),
             padding: const EdgeInsets.all(15),
              textColor: Colors.teal,
              onPressed: () async {
               if (_formKey.currentState.validate()) {}
              }
            ),
           ],
          ),
         ),
        ),
      );
     },
    )
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

//form will only work if app is on app store
class Feedback extends StatefulWidget {
 @override
 _FeedbackState createState() => new _FeedbackState();
}

class _FeedbackState extends State < Feedback > {
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
     //appbar
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
      children: < Widget > [
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

class Contact extends StatefulWidget {
 _ContactState createState() => new _ContactState();
}

class _ContactState extends State < Contact > {

 final _recipientController = TextEditingController(
  text: 'example@example.com',
 );

 final _subjectController = TextEditingController(text: 'The subject');

 final _bodyController = TextEditingController(
  text: 'Mail body.',
 );

 final GlobalKey < ScaffoldState > _scaffoldKey = GlobalKey < ScaffoldState > ();

 Future < void > send() async {
  final Email email = Email(
   body: _bodyController.text,
   subject: _subjectController.text,
   recipients: [_recipientController.text],
  );

  String platformResponse;

  try {
   await FlutterEmailSender.send(email);
   platformResponse = 'success';
  } catch (error) {
   platformResponse = error.toString();
  }

  if (!mounted) return;

  _scaffoldKey.currentState.showSnackBar(SnackBar(
   content: Text(platformResponse),
  ));
 }

 final _formKey = GlobalKey < FormState > ();

 String error = '';
 bool loading = false;
 String email = '';
 String firstName = '';
 String message = '';

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   key: _scaffoldKey,
   appBar: AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
    title: Text('Contact Us'),
    leading: new IconButton(
     icon: new Icon(Icons.arrow_back),
     onPressed: () {
      Navigator.pop(context);
     }
    ),
   ),
   body: Form(
    key: _formKey,
    child: LayoutBuilder(
     builder: (BuildContext context, BoxConstraints viewportContraints) {
      return Container(
       padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        child: SingleChildScrollView(
         child: ConstrainedBox(
          constraints: BoxConstraints(
           minHeight: viewportContraints.maxHeight,
          ),
          child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: < Widget > [
            TextFormField(
             controller: _subjectController,
             validator: (input) => input.isEmpty ? 'Please enter a name' : null,
             onChanged: (input) {
              setState(() => firstName = input);
             },
             style: TextStyle(fontSize: 18, color: Colors.black54),
             decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.red),
              filled: true,
              fillColor: Colors.white,
              labelText: 'Name',
              contentPadding: const EdgeInsets.all(15),
               focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.teal
                ),
                borderRadius: BorderRadius.circular(5),
               ),
               enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.teal
                ),
                borderRadius: BorderRadius.circular(5),
               ),
             )
            ),
            SizedBox(height: 25.0),
            TextFormField(
             controller: _recipientController,
             validator: (input) => input.isEmpty ? 'Please enter a email address' : null,
             onChanged: (input) {
              setState(() => email = input);
             },
             style: TextStyle(fontSize: 18, color: Colors.black54),
             decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.red),
              filled: true,
              fillColor: Colors.white,
              labelText: 'Email',
              contentPadding: const EdgeInsets.all(15),
               focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.teal
                ),
                borderRadius: BorderRadius.circular(5),
               ),
               enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.teal
                ),
                borderRadius: BorderRadius.circular(5),
               ),
             )
            ),
            SizedBox(height: 20.0),
            TextFormField(
             controller: _bodyController,
             keyboardType: TextInputType.multiline,
             maxLines: 6,
             validator: (input) => input.isEmpty ? 'Please enter a message' : null,
             onChanged: (input) {
              setState(() => message = input);
             },
             style: TextStyle(fontSize: 18, color: Colors.black54),
             decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.red),
              filled: true,
              fillColor: Colors.white,
              labelText: 'Message',
              contentPadding: const EdgeInsets.all(15),
               focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.teal
                ),
                borderRadius: BorderRadius.circular(5),
               ),
               enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.teal
                ),
                borderRadius: BorderRadius.circular(5),
               ),
             )
            ),
            SizedBox(height: 20.0),
            FlatButton(child: Text(
              'Send',
              style: TextStyle(
               fontSize: 20,
              ),
             ),
             shape: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal, width: 2),
              borderRadius: BorderRadius.circular(5),
             ),
             padding: const EdgeInsets.all(15),
              textColor: Colors.teal,
              onPressed: send
            ),
           ]
          )
         )
        )
      );
     }
    )
   )
  );
 }
}

class DeliveryInfo extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
    title: Text('Delivery Info'),
    leading: new IconButton(
     icon: new Icon(Icons.arrow_back),
     onPressed: () {
      Navigator.pop(context);
     }
    ),
   ),
   body: SingleChildScrollView(
    child: Container(
     padding: EdgeInsets.all(16.0),
     child: Column(
      children: < Widget > [
        //all information gathered from shopzero website
       SizedBox(height: 10),
       Text('We currently post orders out to addresses in the UK by 2nd Class Royal Mail. (Our Door 2 Door delivery service is currently made to NG2, NG5 and NG7 postcodes).', style: textStyles),
       SizedBox(height: 10),
       Text('Despatch: Is within 1-2 working days depending on when we receive you order and the shop is open to pack your order. From posting, orders will usually arrive in the next 2-4 days depending on packing time and delivery patterns. We aim to keep in touch with you via email if there are any variations from this.', style: textStyles),
       SizedBox(height: 10),
       Text('Packaging materials: In line with our sustainable ethos – we will use and reuse recyclable packaging where possible and package plastic-free. Any tape used is fully home compostable and recyclable. It is made in the UK or EU from Kraft paper and the glue is plant-based. Occasionally, you may find some traditional tape remains on the boxes.', style: textStyles),
       SizedBox(height: 10),
       Text('Occasionally items do get lost in the post, and we can re-send or refund your order 15 working days after it was sent as this is when the Royal Mail class it as lost and allow us to claim for the loss.', style: textStyles),
       SizedBox(height: 10),
      ],
     ),
    ),
   ),
  );
 }
}