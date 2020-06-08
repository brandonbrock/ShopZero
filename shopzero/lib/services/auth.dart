import 'package:ShopZero/models/user.dart';
import 'package:ShopZero/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthService {
 //private property to be used in all files
 final FirebaseAuth _auth = FirebaseAuth.instance;

 // create individual firebase user
 User _userFromFirebaseUser(FirebaseUser user) {
  return user != null ? User(uid: user.uid) : null;
 }

 // auth change user stream
 Stream < User > get user {
  return _auth.onAuthStateChanged
   .map((FirebaseUser user) => _userFromFirebaseUser(user));
 }

 // sign in with email and password
 Future signInWithEmailAndPassword(String email, String password) async {
  try {
   //.trim removes whitespacing
   AuthResult result = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
   FirebaseUser user = result.user;
   return user;
  } catch (error) {
   print(error.toString());
   return null;
  }
 }

 //register with email and password
 Future registerWithEmailAndPassword({
  @required String displayName,
  @required String fullName,
  @required String email,
  @required String password,
  String userRole = 'user',
  int scans = 0,
  int scansLeft = 10,
  double scansPercent = 0,
 }) async {
  try {
   AuthResult result = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password.trim(), );
   FirebaseUser user = result.user;

   await DatabaseService(uid: user.uid).updateUser(displayName, fullName, email, userRole, scans, scansLeft, scansPercent);

   print('display name: $displayName');
   print('full name: $fullName');
   print('email: $email');
   print('userrole: $userRole');
   print('scans: $scans');
   print('scans left: $scansLeft');
   print('scans percent: $scansPercent');

   return _userFromFirebaseUser(user);

  } catch (error) {
   print(error.toString());
   if(error is PlatformException) {
    if(error.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
      /// `foo@bar.com` has alread been registered.
    }
  }
  }
 }

 // sign out
 Future signOut() async {
  try {
   return await _auth.signOut();
  } catch (error) {
   print(error.toString());
   return null;
  }
 }

 //reset password
 Future sendPasswordResetEmail(String email) async {
  return _auth.sendPasswordResetEmail(email: email);
 }

 //change password 
 Future changePassword(String password) async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();

  //Pass in the password to updatePassword.
  user.updatePassword(password).then((_) {
   print("Succesfull changed password");
  }).catchError((error) {
   print("Password can't be changed" + error.toString());
   //wrong password entered
  });
 }

 //reset email
 Future emailReset(String email, password) async {
  return EmailAuthProvider.getCredential(email: 'email', password: 'password');
 }

 // Create Anonymous User
 Future singInAnonymously() {
  return _auth.signInAnonymously();
 }
}