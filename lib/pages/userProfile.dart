import 'package:flutter/material.dart';
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
            UserProfile(),
          ],
        ),
      ),
    );
  }
}
