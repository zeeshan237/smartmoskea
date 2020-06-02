import 'package:flutter/material.dart';
import 'profile_card.dart';
import 'user_profile.dart';

void main() {
  runApp(App());
}




class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            ProfileCard(
              fullName: "Sheikh Hassan",
              mail: "hassan57928@gmail.com",
            ),
            userProfile(),
          ],
        ),
      ),
    );
  }
}
