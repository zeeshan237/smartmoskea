import "package:flutter/material.dart";

class about extends StatefulWidget {
  @override
  _aboutState createState() => _aboutState();
}

class _aboutState extends State<about> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: new Text(
            "About",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: new Container(
            padding: EdgeInsets.only(top: 10.0, left: 10.0), child: Text("")));
  }
}
