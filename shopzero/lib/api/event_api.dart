import 'dart:io';
import 'package:ShopZero/models/events.dart';
import 'package:ShopZero/providers/events_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';


//get the event from database collection to display in a list
getEvent(EventsNotifier eventsNotifier) async {
  QuerySnapshot snapshot = await Firestore.instance.collection('events').getDocuments();

  List<Event> _eventList = [];

  snapshot.documents.forEach((document) {
    Event event = Event.fromMap(document.data);
    _eventList.add(event);
  });

  eventsNotifier.eventList = _eventList;
}

//upload image to event form function
uploadEventAndImage(Event event, bool isUpdating, File localFile, Function eventUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('events/images/$uuid$fileExtension');

    await firebaseStorageRef.putFile(localFile).onComplete.catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    _uploadEvent(event, isUpdating, eventUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadEvent(event, isUpdating, eventUploaded);
  }
}

//adding an event to the events collection
_uploadEvent(Event event, bool isUpdating, Function eventUploaded, {String imageUrl}) async {
  CollectionReference eventRef = Firestore.instance.collection('events');

  if (imageUrl != null) {
    event.image = imageUrl;
  }

  if (isUpdating) {
    event.updatedAt = Timestamp.now();

    await eventRef.document(event.id).updateData(event.toMap());

    eventUploaded(event);
    print('updated event with id: ${event.id}');
  } else {
    event.createdAt = Timestamp.now();

    DocumentReference documentRef = await eventRef.add(event.toMap());

    event.id = documentRef.documentID;

    print('uploaded evemt successfully: ${event.toString()}');

    await documentRef.setData(event.toMap(), merge: true);

    eventUploaded(event);
  }
}

//removing an event from collection
deleteEvent(Event event, Function eventDeleted) async {
  if (event.image != null) {
    StorageReference storageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(event.image);

    print(storageReference.path);

    await storageReference.delete();

    print('image deleted');
  }

  await Firestore.instance.collection('events').document(event.id).delete();
  eventDeleted(event);
}