import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_moskea/pages/about.dart';
import 'package:smart_moskea/pages/manageMosque.dart';
import 'package:smart_moskea/pages/profile_card.dart';

import 'favorite.dart';
import 'forum.dart';
import 'settings.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  updateDetails() {
    setState(() {});
  }
  String accountEmail = "";
  String accountName = "";

  _UserProfileState() {
    userPRofileGet().then((value) {
      if (value != null) {
        this.accountEmail = value;
        updateDetails();
      }
    });

    getUserName().then((value) {
      if (value != null) {
        this.accountName = value;
        updateDetails();
      }
    });
  }

  Future<String> userPRofileGet() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print('you are' + user.uid);
    print('your email' + user.email);
    return user.email;
  }

  Future<String> getUserName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot ds =
        await Firestore.instance.collection('users').document(user.uid).get();
    print('my uid' + user.uid);
    print('my name' + ds.data['name']);
    print('my email' + user.email);

    return ds.data['name'];
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ProfileCard(
          fullName: accountName,
          mail: accountEmail,
        ),
        SizedBox(
          height: 15.0,
        ),
        buildTile1(
          context,
          "Questions Asked",
          Icons.question_answer,
        ),
        buildTile2(context, "Total Aswered", Icons.history),
        buildTile3(context, "Favourite Mosques", Icons.favorite),
        buildTile4(context, "Settings", Icons.settings_applications),
        buildTile5(context, "Manage Mosques", Icons.help_outline),
        buildTile6(context, "About", Icons.info),
        buildTile7(context, "Logout", Icons.exit_to_app),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  Widget buildTile1(BuildContext context, String title, IconData icon) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          leading: Icon(icon),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Forum()));
          },
        ),
        Divider(
          height: 6.0,
        ),
      ],
    );
  }

  Widget buildTile2(BuildContext context, String title, IconData icon) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          leading: Icon(icon),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Forum()));
          },
        ),
        Divider(
          height: 6.0,
        ),
      ],
    );
  }

  Widget buildTile3(BuildContext context, String title, IconData icon) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          leading: Icon(icon),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Favorite()));
          },
        ),
        Divider(
          height: 6.0,
        ),
      ],
    );
  }

  Widget buildTile4(BuildContext context, String title, IconData icon) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          leading: Icon(icon),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsScreen()));
          },
        ),
        Divider(
          height: 6.0,
        ),
      ],
    );
  }

  Widget buildTile5(BuildContext context, String title, IconData icon) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          leading: Icon(icon),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ManageMosque()));
          },
        ),
        Divider(
          height: 6.0,
        ),
      ],
    );
  }

  Widget buildTile6(BuildContext context, String title, IconData icon) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          leading: Icon(icon),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => About()));
          },
        ),
        Divider(
          height: 6.0,
        ),
      ],
    );
  }

  Widget buildTile7(BuildContext context, String title, IconData icon) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          leading: Icon(icon),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            //FirebaseAuth.instance.signOut();
          },
        ),
        Divider(
          height: 6.0,
        ),
      ],
    );
  }
}
