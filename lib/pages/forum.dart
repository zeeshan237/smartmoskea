import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_moskea/models/user.dart';
import 'package:smart_moskea/pages/HomeMsg.dart';
import 'package:smart_moskea/pages/your_questions.dart';
//import 'package:smart_moskea/pages/messages.dart';
import 'package:flutter/cupertino.dart';

class forum extends StatefulWidget {
  @override
  _forumState createState() => _forumState();
}

class _forumState extends State<forum> {
// Forum code from favortie icon Start
  updateDetails() {
    setState(() {});
  }

  int currentOnlineUserCategory;
  _forumState() {
    userCurrentID().then((value) {
      if (value != null) {
        this.accountID = value;
        updateDetails();
      }
    });

    getUserCategory().then((value) {
      if (value != null) {
        this.currentOnlineUserCategory = value;
        updateDetails();
      }
    });
  }

  int selectPage = 0;
  final List<String> category = ["Forum", "My Questions"];

  User currentUser;
  String accountID = "";

  Widget callPage(int index) {
    switch (index) {
      case 0:
        return HomeMsg(
            userProfileId: accountID, userCategory: currentOnlineUserCategory);
      case 1:
        return YourQuestion(
          userProfileId: accountID,
        );
      // case 2:
      //   return answered();
      // case 3:
      //   return like_questions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        height: 60.0,
        color: Colors.deepOrangeAccent, //Theme.of(context).b,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: category.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectPage = index;
                });
              },
              child: new Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 45.0,
                ),
                child: new Text(
                  category[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: index == selectPage ? Colors.black : Colors.white70,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            );
          },
          //physics: NeverScrollableScrollPhysics(),
        ),
      ),
      Expanded(
        child: new Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: callPage(selectPage),
        ),
      ),
    ]);
  }

  // Forum code from favortie icon Start

  Future<String> userCurrentID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    // print('you are' + user.uid);
    //print('your email' + user.email);

    //uuuser.get;
    //final String email = user.uid.toString();
    return user.uid;
  }

  //get User Category

  Future<int> getUserCategory() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot ds =
        await Firestore.instance.collection('users').document(user.uid).get();
    // print('my uid' + user.uid);
    //print('my name' + ds.data['name']);
    //print('my email' + user.email);

    return ds.data['catogery'];
  }

  // Forum code from favortie icon End
}
