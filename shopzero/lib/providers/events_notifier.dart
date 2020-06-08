import 'dart:collection';
import 'package:ShopZero/models/events.dart';
import 'package:flutter/cupertino.dart';

class EventsNotifier with ChangeNotifier {
 List < Event > _eventList = [];
 Event _currentEvent;

 UnmodifiableListView < Event > get eventList => UnmodifiableListView(_eventList);

 Event get currentEvent => _currentEvent;

//display list of events in database
 set eventList(List < Event > eventList) {
  _eventList = eventList;
  notifyListeners();
 }

//get the current event on tap
 set currentEvent(Event event) {
  _currentEvent = event;
  notifyListeners();
 }

//add event to the event list to display
 addEvent(Event event) {
  _eventList.insert(0, event);
  notifyListeners();
 }

//remove an event from the event list getting the event id
 removeEvent(Event event) {
  _eventList.removeWhere((_event) => _event.id == _event.id);
  notifyListeners();
 }
}