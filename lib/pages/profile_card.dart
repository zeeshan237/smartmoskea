import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String fullName;
  final String mail;

  ProfileCard({this.fullName, this.mail});

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[card(context)],
    );
  }

  Widget card(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          colorBox(Colors.black),
          SizedBox(height:20.0),
          profilePic(context),
          nameNnumber(),
        ],
      ),
    );
  }

  Widget colorBox(Color color) {
    return Container(
      height: 220.0,
      decoration: BoxDecoration(
          color: Colors.deepOrange,
          shape: BoxShape.rectangle,
    ));
  }

  Widget profilePic(BuildContext context) {
    //double width = MediaQuery.of(context).size.width / 2 - 64.0;
    
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      alignment: Alignment.topCenter,
      child: Icon(
        Icons.account_circle,
        size: 124.0,
        color: Colors.deepOrangeAccent,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget nameNnumber() {
    Text name = Text(
      fullName,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 21.0,
        fontWeight: FontWeight.w400,
      ),
    );

    Text number = Text(
      mail,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
      ),
    );
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: 155.0,
      ),
      child: Column(
        children: <Widget>[
          name,
          SizedBox(
            height: 1.0,
          ),
          number
        ],
      ),
    );
  }
}
