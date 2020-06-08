import 'package:ShopZero/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseService {

 final String uid;
 DatabaseService({
  this.uid
 });

 // collection reference
 final CollectionReference usersCollection = Firestore.instance.collection('users');

 //update user info 
 Future < void > updateUser(String displayName, String fullName, String email, String userRole, int scans, int scansLeft, double scansPercent) async {
  return await usersCollection.document(uid).setData({
   'displayName': displayName,
   'fullName': fullName,
   'email': email,
   'userRole': userRole,
   "scans": scans,
   "scansLeft": scansLeft,
   "scansPercent": scansPercent,
  });
 }

 //update user scans 
 Future < void > updateScans(int scans, int scansLeft, double scansPercent) async {
  return await usersCollection.document(uid).updateData({
   "scans": FieldValue.increment(1),
   "scansLeft": FieldValue.increment(-1),
   "scansPercent": FieldValue.increment(0.1),
  });
 }

 //reset user scans 
 Future < void > resetScans(int scans, int scansLeft, double scansPercent) async {
  return await usersCollection.document(uid).updateData({
   "scans": 0,
   "scansLeft": 10,
   "scansPercent": 0.0,
  });
 }

 //update user profile 
 Future < void > updateEditProfile(String displayName, String fullName, String email) async {
  return await usersCollection.document(uid).updateData({
   'displayName': displayName,
   'fullName': fullName,
   'email': email,
  });
 }

 // user data from snapshots
 UserData _userFromSnapshot(DocumentSnapshot snapshot) {
  return UserData(
   uid: uid,
   displayName: snapshot.data['displayName'],
   fullName: snapshot.data['fullName'],
   email: snapshot.data['email'],
   userRole: snapshot.data['userRole'],
   scans: snapshot.data['scans'],
   scansLeft: snapshot.data['scansLeft'],
   scansPercent: snapshot.data['scansPercent'],
  );
 }

 // get user doc stream
 Stream < UserData > get userData {
  return usersCollection.document(uid).snapshots()
   .map(_userFromSnapshot);
 }
}