import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_moskea/pages/BeforeLoggedInMainScreen.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
      );

  // // Email & Password Signup

  void signOut() {
    FirebaseAuth.instance.signOut();
    //FirebaseUser user = FirebaseAuth.instance.currentUser;
    //print('$user');
    runApp(new MaterialApp(
      home: new BeforeLoggedInMainScreen(),
    ));
  }
}
