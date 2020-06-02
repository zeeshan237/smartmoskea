import 'package:flutter/material.dart';
import 'package:smart_moskea/pages/about.dart';
import 'package:smart_moskea/pages/manageMosque.dart';

import 'favorite.dart';
import 'forum.dart';
import 'settings.dart';

class userProfile extends StatefulWidget {
  @override
  _userProfileState createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 15.0, 
        ),
        buildTile1(context, "Questions Asked",Icons.question_answer,),
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
               Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => forum()));
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
             Navigator.of(context).push(
             MaterialPageRoute(builder: (context) => forum()));
              
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
             Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => favorite()));
              
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

                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => manageMosque()));
           
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
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => about()));
         
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
