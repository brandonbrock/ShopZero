import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String title;
  String date;
  String location;
  String image;
  String description;
  Timestamp createdAt;
  Timestamp updatedAt;

  Event();

  //display event by snapshot
  Event.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    date = data['date'];
    location = data['location'];
    image = data['image'];
    description = data['description'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'location': location,
      'image': image,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}