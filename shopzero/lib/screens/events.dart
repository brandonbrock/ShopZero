import 'dart:io';
import 'package:ShopZero/api/event_api.dart';
import 'package:ShopZero/models/user.dart';
import 'package:ShopZero/providers/events_notifier.dart';
import 'package:ShopZero/screens/dashboard.dart';
import 'package:ShopZero/screens/settings.dart';
import 'package:ShopZero/services/auth.dart';
import 'package:ShopZero/services/database.dart';
import 'package:ShopZero/widgets/loading.dart';
import 'package:app_review/app_review.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Events extends StatefulWidget {
 @override
 _EventState createState() => _EventState();
}

class _EventState extends State < Events > {
 @override
 void initState() {
  EventsNotifier eventsNotifier = Provider.of < EventsNotifier > (context, listen: false);
  getEvent(eventsNotifier);
  super.initState();
 }

 final AuthService _auth = AuthService();

 @override
 Widget build(BuildContext context) {
   //gets events data from collection using get event
  EventsNotifier eventsNotifier = Provider.of < EventsNotifier > (context);
  User user = Provider.of <User> (context);
  //streambuilder gets the stream of data to display
  return StreamBuilder < UserData > (
   stream: DatabaseService(uid: user.uid).userData,
   builder: (context, snapshot) {
     //if collection has data display
    if (snapshot.hasData) {
     UserData userData = snapshot.data;
     return Scaffold(
       //appbar
      appBar: AppBar(
       title: Text('Events'),
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
      //main context
      body: ListView.separated(
       itemBuilder: (BuildContext context, int index) {
        return ListTile(
         leading: Image.network(
          eventsNotifier.eventList[index].image
         ),
         title: Text(eventsNotifier.eventList[index].title),
         subtitle: Text(eventsNotifier.eventList[index].date),
         onTap: () {
          eventsNotifier.currentEvent = eventsNotifier.eventList[index];
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
           return EventsDetail();
          }));
         },
        );
       },
       itemCount: eventsNotifier.eventList.length,
       separatorBuilder: (BuildContext context, int index) {
        return Divider(
         color: Colors.black,
        );
       },
      ),
     );
     //if no data then loading will keep going until data in collection
    } else {
     return Loading();
    }
   }
  );
 }

}

//when an event is clicked 
class EventsDetail extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
  EventsNotifier eventsNotifier = Provider.of < EventsNotifier > (context);

  return Scaffold(
   appBar: AppBar(
    title: Text(eventsNotifier.currentEvent.title, style: TextStyle(fontSize: 14), ),
   ),
   body: SingleChildScrollView(
    child: Center(
     child: Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
       children: < Widget > [
        Image.network(
         eventsNotifier.currentEvent.image
        ),
        SizedBox(height: 24),
        Text(
         eventsNotifier.currentEvent.title,
         style: TextStyle(
          fontSize: 18,
         ),
        ),
        SizedBox(height: 20),
        Text(
         '${eventsNotifier.currentEvent.date}',
         style: TextStyle(fontSize: 12),
        ),
        SizedBox(height: 20),
        Text(
         '${eventsNotifier.currentEvent.location}',
         style: TextStyle(fontSize: 12),
        ),
        SizedBox(height: 16),
        Text(
         '${eventsNotifier.currentEvent.description}',
         style: TextStyle(fontSize: 12),
        ),
       ],
      ),
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