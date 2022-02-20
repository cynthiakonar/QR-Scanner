// import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qr_scanner/models/user.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final googleSignIn = GoogleSignIn();

class AuthService {
  //Create user object based on Firebase user
  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // Auth change user stream
  Stream<MyUser?> get user {
    return _auth
        .authStateChanges()
        //.map((User? user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // sign in anonymously
  Future signInAnon() async {
    try {
      //AuthResult class name has changed to UserCredential
      UserCredential result = await _auth.signInAnonymously();
      //FirebaseUser class name has changed to User
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (ex) {
      print(ex.toString());
      return null;
    }
  }

  // sign Up  with email & password
  Future emailSignUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (ex) {
      switch (ex) {
        case 'email-already-in-use':
          print(ex.toString());
          return null;
        case 'invalid-email':
          print(ex.toString());
          return null;
        case 'weak-password':
          print(ex.toString());
          return null;
        case 'operation-not-allowed':
          print(ex.toString());
          return null;
        default:
          print(ex.toString());
          return null;
      }
    }
  }

  // login with email & password
  Future emailLogin(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (ex) {
      switch (ex) {
        case 'user-disabled':
          print(ex.toString());
          return null;
        case 'invalid-email':
          print(ex.toString());
          return null;
        case 'user-not-found':
          print(ex.toString());
          return null;
        case 'wrong-password':
          print(ex.toString());
          return null;
        default:
          print(ex.toString());
          return null;
      }
    }
  }

  // Google Sign in
  Future googleLogin() async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential result = await _auth.signInWithCredential(credential);
    User? user = result.user;
    return _userFromFirebaseUser(user);
  }

  // Facebook Sign in
  Future logInWithFacebook(context) async {
    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();

      final facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

      //Storing user info in firestore
      await FirebaseFirestore.instance.collection('users').add(
        {
          'email': userData['email'],
          'imageUrl': userData['picture']['data']['url'],
          'name': userData['name'],
        },
      );
      User? user = await _auth.currentUser;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (ex) {
      var title = '';
      switch (ex.code) {
        case 'account-exists-with-different-credential':
          title = 'This account exists with a different sign in provider';
          break;
        case 'invalid-credential':
          title = 'Unknown error has occured';
          break;
        case 'operation-not-allowed':
          title = 'This operation is not allowed';
          break;
        case 'user-disabled':
          title = 'The user you tried to log into is disabled';
          break;
        case 'user-not-found':
          title = 'The user you tried to log into was not found';
          break;
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Log in with facebook failed'),
          content: Text(title),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok')),
          ],
        ),
      );
    }
  }

  //signout
  Future signOut() async {
    try {
      User? user = await _auth.currentUser;
      if (user?.providerData[1].providerId == 'google.com') {
        return await googleSignIn.disconnect();
      }
      return await _auth.signOut();
    } catch (ex) {
      print(ex.toString());
      return null;
    }
  }
}
