import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_moskea/pages/ProfilePage.dart';
import 'package:smart_moskea/pages/userProfile.dart';
import 'package:smart_moskea/requests/authServices.dart';
import 'NotificationsPage.dart';
import 'qibla_direction.dart';
import 'map.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:smart_moskea/pages/forum.dart';
import 'package:flutter/material.dart';

class LoggedInMainScreen extends StatefulWidget {
  LoggedInMainScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoggedInMainScreenState createState() => _LoggedInMainScreenState();
}

class _LoggedInMainScreenState extends State<LoggedInMainScreen> {
  FirebaseAuth auth;
  // ignore: unused_field
  int _counter = 0;
  int _current = 2;
  //User userr;
  updateDetails() {
    setState(() {});
  }

  _LoggedInMainScreenState() {
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

    userCurrentID().then((value) {
      if (value != null) {
        this.accountID = value;
        updateDetails();
      }
    });
  }

  Widget callPage(int index) {
    switch (index) {
      case 0:
        return Forum();
      case 1:
        return qibla_direction();
      case 2:
        return Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: map());
      case 3:
        return ProfilePage(userProfileId: accountID);
      //case 4: return LoginPage();
      case 4:
        return App();
    }
    return null;
  }

  String accountEmail = "";
  String accountName = "";
  String accountID = "";
  // ignore: unused_element
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you exit the app?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("NO"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text("YES"),
                  onPressed: () => Navigator.pop(context, true),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: new AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          //  leading: new Icon(Icons.menu),
          title: new Text(
            "Smart Moskea",
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NotificationsPage()));
              },
            ),
          ],
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text(accountName),
                accountEmail: new Text(accountEmail),
                decoration: BoxDecoration(color: Colors.deepOrangeAccent),
                currentAccountPicture: new CircleAvatar(
                  backgroundImage: new NetworkImage(
                      "https://png.pngtree.com/element_our/png/20181206/users-vector-icon-png_260862.jpg"),
                ),
              ),
              new ListTile(
                trailing: new Icon(Icons.settings),
                title: new Text("Settings"),
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => BeforeLoggedInMainScreen()));
                },
              ),
              new Divider(),
              new ListTile(
                trailing: new Icon(Icons.exit_to_app),
                title: new Text("Logout"),
                onTap: () {
                  AuthServices().signOut(context);
                },
              ),
            ],
          ),
        ),
        body: callPage(_current),
        // This trailing comma makes auto-formatting nicer for build methods.
        bottomNavigationBar: CurvedNavigationBar(
          height: 50,
          backgroundColor: Colors.white,
          color: Colors.deepOrangeAccent,
          items: <Widget>[
            Icon(Icons.forum, size: 30, color: Colors.black),
            Icon(Icons.directions, size: 30, color: Colors.black),
            Icon(Icons.add, size: 30, color: Colors.black),
            Icon(Icons.favorite, size: 30, color: Colors.black),
            Icon(Icons.person, size: 30, color: Colors.black),
          ],
          index: 2,
          onTap: (index) {
            setState(() {
              _current = index;
            });
          },
        ),
      ),
    );
  }

  //var usb = "dfgk";
  // profile getter
  Future<String> userPRofileGet() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print('you are' + user.uid);
    print('your email' + user.email);

    //uuuser.get;
    //final String email = user.uid.toString();
    return user.email;
  }

  Future<String> userCurrentID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print('you are' + user.uid);
    print('your email' + user.email);

    //uuuser.get;
    //final String email = user.uid.toString();
    return user.uid;
  }

  //get current user
  FirebaseAuth _firebaseAuth;
  Future getCurrentUser() async {
    return await _firebaseAuth.currentUser();
  }

  // //fetch user name and other fields

  // Future<DocumentSnapshot> getUserInfo() async {
  //   var firebaseUser = await FirebaseAuth.instance.currentUser();
  //   return await Firestore.instance
  //       .collection("users")
  //       .document(firebaseUser.uid)
  //       .get();
  // }

  Future<String> getUserName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot ds =
        await Firestore.instance.collection('users').document(user.uid).get();
    print('my uid' + user.uid);
    print('my name' + ds.data['name']);
    print('my email' + user.email);

    return ds.data['name'];
  }
}

// Future<bool> getAllProfilePosts() async {
//     if (postsList.isNotEmpty) return true;
//     List documentIdList = [];
//     QuerySnapshot snapshot =
//         await Firestore.instance.collection('users').getDocuments();

//     snapshot.documents.forEach((element) {
//       for (int i = 0; i < element.data.length; i++)
//         documentIdList.add(element.data[i]['uid']);
//     });

//     //var postList = [];

//     for (int i = 0; i < documentIdList.length; i++) {
//       QuerySnapshot querySnapshot = await postsReference
//           .document(documentIdList[i])
//           .collection("usersPosts")
//           .orderBy("timestamp", descending: true)
//           .getDocuments();
//       countPost = querySnapshot.documents.length;
//       postsList = querySnapshot.documents
//           .map((documentSnapshot) => Post.fromDocument(documentSnapshot))
//           .toList();
//     }
//     return true;
//   }
