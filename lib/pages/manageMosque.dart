import 'package:flutter/material.dart';

class ManageMosque extends StatefulWidget {
  @override
  _ManageMosqueState createState() => _ManageMosqueState();
}

class _ManageMosqueState extends State<ManageMosque> {
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 15.0,
        ),
        buildTile1(
          context,
          "Update Prayer Time",
          Icons.update,
        ),
        buildTile2(context, "Add Announcements", Icons.announcement),
        buildTile3(context, "View Annoucements", Icons.view_headline),
        buildTile4(context, "Remove Mosque", Icons.remove),
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
          onTap: () {},
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
          onTap: () {},
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
          onTap: () {},
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
          onTap: () {},
        ),
        Divider(
          height: 6.0,
        ),
      ],
    );
  }
}
