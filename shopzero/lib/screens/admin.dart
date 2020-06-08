import 'dart:io';
import 'package:ShopZero/api/event_api.dart';
import 'package:ShopZero/models/events.dart';
import 'package:ShopZero/providers/events_notifier.dart';
import 'package:ShopZero/services/auth.dart';
import 'package:ShopZero/services/database.dart';
import 'package:ShopZero/utilities/constants.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Admin extends StatefulWidget {
 @override
 _AdminState createState() => new _AdminState();
}

class _AdminState extends State < Admin > {
 String barcode = "";
 FirebaseUser user;
 final AuthService _auth = AuthService();

//current scan values
 int _currentScans;
 int _currentScansLeft;
 double _currentScansPercent;



 @override

 void initState() {
  EventsNotifier eventsNotifier = Provider.of < EventsNotifier > (context, listen: false);
  getEvent(eventsNotifier);
  super.initState();
 }

 Widget build(BuildContext context) {
  EventsNotifier eventsNotifier = Provider.of < EventsNotifier > (context);


  return new MaterialApp(
   theme: ThemeData(
    primarySwatch: Colors.teal,
   ),
   home: new Scaffold(
     //appbar
    appBar: new AppBar(
     title: new Text('Admin Dashboard'),
     actions: < Widget > [
      Padding(
       padding: EdgeInsets.only(left: 20.0),
       child: new FlatButton(
        child: new Text('Logout', style: new TextStyle(fontSize: 17.0, color: Colors.white)),
        onPressed: () async {
         await _auth.signOut();
        },
       ),
      ),
     ],
    ),
    //main context
    body: new Center(
     child: new Column(
      children: < Widget > [
       SizedBox(height: 10.0),
       //scan user barcode function
       Card(
        child: new Container(
         width: 350,
         child: new MaterialButton(
          onPressed: updateScans, child: new Text("Scan Customer Barcode", style: textStyles)
         ),
         padding: const EdgeInsets.all(8.0),
        ),
       ),
       SizedBox(height: 10.0),
       //reset user voucher barcode function
       Card(
        child: new Container(
         width: 350,
         child: new MaterialButton(
          onPressed: resetScans, child: new Text("Reset Customer Barcode", style: textStyles)
         ),
         padding: const EdgeInsets.all(8.0),
        ),
       ),
       SizedBox(height: 10.0),
       //add event function
       Card(
        child: Container(
         padding: const EdgeInsets.all(8.0),
          width: 350,
          child: MaterialButton(
           child: Text('Add event', style: textStyles),
           onPressed: () {
            eventsNotifier.currentEvent = null;
            Navigator.of(context).push(
             MaterialPageRoute(builder: (BuildContext context) {
              return EventForm(
               isUpdating: false,
              );
             }),
            );
           },
          ),
        ),
       ),
       //remove event function
       SizedBox(height: 10.0),
       Card(
        child: Container(
         padding: const EdgeInsets.all(8.0),
          width: 350,
          child: MaterialButton(
           child: Text('Remove event', style: textStyles),
           onPressed: () {
            eventsNotifier.currentEvent = null;
            Navigator.of(context).push(
             MaterialPageRoute(builder: (BuildContext context) {
              return EventsList();
             }),
            );
           }
          ),
        )
       ),
       SizedBox(height: 10.0),
       //edit event function
       Card(
        child: Container(
         padding: const EdgeInsets.all(8.0),
          width: 350,
          child: MaterialButton(
           child: Text('Edit event', style: textStyles),
           onPressed: () {
            eventsNotifier.currentEvent = null;
            Navigator.of(context).push(
             MaterialPageRoute(builder: (BuildContext context) {
              return EventsListEdit();
             }),
            );
           }
          ),
        )
       ),


      ],
     ),
    )),
  );
 }

//the function that updates the user scans
 Future updateScans() async {
  try {
   String barcode = await BarcodeScanner.scan(); //make string into uid object
   setState(() => this.barcode = barcode);
   print("scanned sucsessfully");

  //collects current scans from barcode which then updates the values from database
   await DatabaseService(uid: barcode).updateScans(
    _currentScans,
    _currentScansLeft,
    _currentScansPercent,
   );

//confirmation of barcode scanned successfully
   showDialog(
    context: context,
    builder: (BuildContext context) {
     // return object of type Dialog
     return AlertDialog(
      title: new Text("Scan Confirmation"),
      content: new Text("Customer's barcode scanned sucessfully"),
      actions: < Widget > [
       // usually buttons at the bottom of the dialog
       new FlatButton(
        child: new Text("Ok"),
        onPressed: () {
         Navigator.of(context).pop();
        },
       ),
      ],
     );
    },
   );

  }
  on PlatformException
  //error prevention
  catch (e) {
   if (e.code == BarcodeScanner.CameraAccessDenied) {
    setState(() {
     this.barcode = 'The user did not grant the camera permission!';
    });
   } else {
    setState(() => this.barcode = 'Unknown error: $e');
   }
  }
  on FormatException {
   setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
  } catch (e) {
   setState(() => this.barcode = 'Unknown error: $e');
  }
 }

//function to reset scans back to zero
 Future resetScans() async {
  try {
   String barcode = await BarcodeScanner.scan(); //make string into uid object
   setState(() => this.barcode = barcode);
   print("scanned sucsessfully");

//gets the users current scans by scanning barcode which is linked to uid
   await DatabaseService(uid: barcode).resetScans(
     //using database service function to reset to zero
    _currentScans,
    _currentScansLeft,
    _currentScansPercent,
   );
//confirmation that barcode reset
   showDialog(
    context: context,
    builder: (BuildContext context) {
     // return object of type Dialog
     return AlertDialog(
      title: new Text("Scan Confirmation"),
      content: new Text("Customer's voucher reset sucessfully"),
      actions: < Widget > [
       // usually buttons at the bottom of the dialog
       new FlatButton(
        child: new Text("Ok"),
        onPressed: () {
         Navigator.of(context).pop();
        },
       ),
      ],
     );
    },
   );

  }
  on PlatformException
  catch (e) {
   if (e.code == BarcodeScanner.CameraAccessDenied) {
    setState(() {
     this.barcode = 'The user did not grant the camera permission!';
    });
   } else {
    setState(() => this.barcode = 'Unknown error: $e');
   }
  }
  on FormatException {
   setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
  } catch (e) {
   setState(() => this.barcode = 'Unknown error: $e');
  }
 }
}

//list of events to remove
class EventsList extends StatefulWidget {
 @override
 _EventState createState() => _EventState();
}

class _EventState extends State < EventsList > {
 @override
 void initState() {
  EventsNotifier eventsNotifier = Provider.of < EventsNotifier > (context, listen: false);
  getEvent(eventsNotifier);
  super.initState();
 }

 @override
 Widget build(BuildContext context) {
  EventsNotifier eventsNotifier = Provider.of < EventsNotifier > (context);
  return Scaffold(
   appBar: AppBar(
    title: Text('List of Events'),
    centerTitle: true,
   ),
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
        return RemoveEvent();
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
 }

}

//list of events to edit
class EventsListEdit extends StatefulWidget {
 @override
 _EventsListEditState createState() => _EventsListEditState();
}

class _EventsListEditState extends State < EventsListEdit > {
 @override
 void initState() {
  EventsNotifier eventsNotifier = Provider.of < EventsNotifier > (context, listen: false);
  getEvent(eventsNotifier);
  super.initState();
 }

 @override
 Widget build(BuildContext context) {
  EventsNotifier eventsNotifier = Provider.of < EventsNotifier > (context);
  return Scaffold(
    //appbar
   appBar: AppBar(
    title: Text('List of Events'),
    centerTitle: true,
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
        return EditEvent();
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
 }

}

//event form to create an event
class EventForm extends StatefulWidget {
 final bool isUpdating;

 EventForm({
  @required this.isUpdating
 });

 @override
 _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State < EventForm > {
 final GlobalKey < FormState > _formKey = GlobalKey < FormState > ();
 final GlobalKey < ScaffoldState > _scaffoldKey = GlobalKey < ScaffoldState > ();

 Event _currentEvent;
 String _imageUrl;
 File _imageFile;

 @override
 void initState() {
  super.initState();
  EventsNotifier eventNotifier = Provider.of < EventsNotifier > (context, listen: false);

  if (eventNotifier.currentEvent != null) {
   _currentEvent = eventNotifier.currentEvent;
  } else {
   _currentEvent = Event();
  }

  _imageUrl = _currentEvent.image;
 }

 _showImage() {
  if (_imageFile == null && _imageUrl == null) {
   return Text("");
  } else if (_imageFile != null) {
   print('showing image from local file');

   return Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: < Widget > [
     Image.file(
      _imageFile,
      fit: BoxFit.cover,
      height: 250,
     ),
     FlatButton(
      padding: EdgeInsets.all(16),
      color: Colors.black54,
      child: Text(
       'Change Image',
       style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
      ),
      onPressed: () => _getLocalImage(),
     )
    ],
   );
  } else if (_imageUrl != null) {
   print('showing image from url');

   return Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: < Widget > [
     Image.network(
      _imageUrl,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
      height: 250,
     ),
     FlatButton(
      padding: EdgeInsets.all(16),
      color: Colors.black54,
      child: Text(
       'Change Image',
       style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
      ),
      onPressed: () => _getLocalImage(),
     )
    ],
   );
  }
 }

 _getLocalImage() async {
  File imageFile =
   await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

  if (imageFile != null) {
   setState(() {
    _imageFile = imageFile;
   });
  }
 }

 Widget _buildTitleField() {
  return TextFormField(
   decoration: InputDecoration(labelText: 'Title'),
   initialValue: _currentEvent.title,
   keyboardType: TextInputType.text,
   style: TextStyle(fontSize: 20),
   validator: (String value) {
    if (value.isEmpty) {
     return 'Title is required';
    }

    if (value.length < 3 || value.length > 20) {
     return 'Title must be more than 3 and less than 20';
    }

    return null;
   },
   onSaved: (String value) {
    _currentEvent.title = value;
   },
  );
 }

 Widget _buildDateField() {
  return TextFormField(
   decoration: InputDecoration(labelText: 'Date'),
   initialValue: _currentEvent.date,
   keyboardType: TextInputType.text,
   style: TextStyle(fontSize: 20),
   validator: (String value) {
    if (value.isEmpty) {
     return 'Date is required';
    }

    if (value.length < 3 || value.length > 20) {
     return 'Date must be more than 3 and less than 20';
    }

    return null;
   },
   onSaved: (String value) {
    _currentEvent.date = value;
   },
  );
 }

 Widget _buildLocationField() {
  return TextFormField(
   decoration: InputDecoration(labelText: 'Location'),
   initialValue: _currentEvent.location,
   keyboardType: TextInputType.text,
   style: TextStyle(fontSize: 20),
   validator: (String value) {
    if (value.isEmpty) {
     return 'Location is required';
    }

    if (value.length < 3 || value.length > 20) {
     return 'Location must be more than 3 and less than 20';
    }

    return null;
   },
   onSaved: (String value) {
    _currentEvent.location = value;
   },
  );
 }

 Widget _buildDescriptionField() {
  return TextFormField(
   decoration: InputDecoration(labelText: 'Description'),
   initialValue: _currentEvent.description,
   keyboardType: TextInputType.text,
   style: TextStyle(fontSize: 20),
   validator: (String value) {
    if (value.isEmpty) {
     return 'Description is required';
    }

    if (value.length < 3 || value.length > 20) {
     return 'Description must be more than 3 and less than 20';
    }

    return null;
   },
   onSaved: (String value) {
    _currentEvent.description = value;
   },
  );
 }

 _onEventUploaded(Event event) {
  EventsNotifier eventNotifier = Provider.of < EventsNotifier > (context, listen: false);
  eventNotifier.addEvent(event);
  Navigator.pop(context);
 }

 _saveEvent() {
  print('saveEvent Called');
  if (!_formKey.currentState.validate()) {
   return;
  }

  _formKey.currentState.save();

  print('form saved');


  uploadEventAndImage(_currentEvent, widget.isUpdating, _imageFile, _onEventUploaded);

//to make sure the current event is not null
  print("title: ${_currentEvent.title}");
  print("location: ${_currentEvent.location}");
  print("date: ${_currentEvent.date}");
  print("description: ${_currentEvent.description}");
  print("_imageFile ${_imageFile.toString()}");
  print("_imageUrl $_imageUrl");
 }

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   key: _scaffoldKey,
   //appbar
   appBar: AppBar(title: Text('Event Form')),
   //main context
   body: SingleChildScrollView(
    padding: EdgeInsets.all(32),
    child: Form(
     key: _formKey,
     autovalidate: true,
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: < Widget > [
       _showImage(),
       SizedBox(height: 16),
       Text(
        widget.isUpdating ? "Edit Event" : "Create Event",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30),
       ),
       SizedBox(height: 16),
       _imageFile == null && _imageUrl == null ?
       ButtonTheme(
        child: RaisedButton(
         onPressed: () => _getLocalImage(),
         child: Text(
          'Add Image',
          style: TextStyle(color: Colors.white),
         ),
        ),
       ) :
       SizedBox(height: 0),
       //list of widgets to display
       _buildTitleField(),
       _buildDateField(),
       _buildLocationField(),
       _buildDescriptionField(),
       SizedBox(height: 16),
       FlatButton(
        child: Text('Add Event'),
        shape: OutlineInputBorder(
         borderSide: BorderSide(color: Colors.teal, width: 2),
         borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(15),
         textColor: Colors.teal,
         onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveEvent();
         },
       )
      ]
     )
    ),
   ),
  );
 }
}

//remove event form
class RemoveEvent extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
  EventsNotifier eventsNotifier = Provider.of < EventsNotifier > (context);

  _onEventDeleted(Event event) {
   Navigator.push(context, MaterialPageRoute(builder: (context) => Admin()));
   eventsNotifier.removeEvent(event);
  }

  return Scaffold(
   appBar: AppBar(
    title: Text(eventsNotifier.currentEvent.title, style: TextStyle(fontSize: 14), ),
   ),
   body: SingleChildScrollView(
    child: Center(
     child: Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.stretch,
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
        SizedBox(height: 20),
        FlatButton(
         child: Text('Delete'),
         shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal, width: 2),
          borderRadius: BorderRadius.circular(5),
         ),
         padding: const EdgeInsets.all(15),
          textColor: Colors.teal,
          onPressed: () {
           deleteEvent(eventsNotifier.currentEvent, _onEventDeleted);
          },
        ),
       ],
      ),
     ),
    ),
   ),
  );
 }
}

//edit an event form
class EditEvent extends StatelessWidget {
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
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.stretch,
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
        SizedBox(height: 20),
        FlatButton(
         child: Text('Edit'),
         shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal, width: 2),
          borderRadius: BorderRadius.circular(5),
         ),
         padding: const EdgeInsets.all(15),
          textColor: Colors.teal,
          onPressed: () {
           Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
             return EventForm(
              isUpdating: true,
             );
            }),
           );
          },
        ),
       ],
      ),
     ),
    ),
   ),
  );
 }
}