// this is for our auth services

// ignore_for_file: avoid_print

import 'package:eliana/models/app_user.dart';
import 'package:eliana/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // underscore at the beginning means that this property is private meaning I can only use it in this file and not in another file
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  AppUser? _appUserFromUser(User? user) {
    // ignore: unnecessary_null_comparison
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // auth change user stream
  // get keyword is used to return value of private variable.
  /* 
  easy example: 
    String get level => this._level;
    
  use it:
    instance.level = 'beginner';
   */
  Stream<AppUser?> get user {
    return _auth.authStateChanges().map((User? user) => _appUserFromUser(user));
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _appUserFromUser(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  // register wth email & password
  Future registerWithEmailAndPassword(
      String username, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      // create a new document for the user with the uid
      await DatabaseService(uid: user!.uid).createUserDetail(
          username,
          email,
          password,
          "https://cdn.discordapp.com/attachments/983275821630357534/994459026320543764/userimg2.jpg");
      return _appUserFromUser(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  Future sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (err) {
      print(err.toString());
    }
  }
}
