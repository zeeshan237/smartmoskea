import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_moskea/pages/PhotoUpload.dart';
import 'package:smart_moskea/widgets/header.dart';
import 'package:smart_moskea/widgets/postWidget.dart';
import 'package:smart_moskea/widgets/progress.dart';
import 'package:smart_moskea/widgets/postTileWidget.dart';

class ProfilePage extends StatefulWidget {
  final String userProfileId;

  ProfilePage({this.userProfileId});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool loading = false;
  int countPost = 0;
  List<Post> postsList = [];
  String postOrientation = "grid";

  void initState() {
    getAllProfilePosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: 'Profile'),
      body: ListView(
        children: <Widget>[
          // buildProfileHeader(),
          createListAndGridPostOrientation(),
          Divider(
            height: 0.0,
          ),
          displayProfilePost(),
          // Divider(),
          // buildTogglePostOrientation(),
          // Divider(
          //   height: 0.0,
          // ),
          //  buildProfilePosts(),
        ],
      ),
    );
  }

// display post from post widget to profile
  displayProfilePost() {
    if (loading) {
      return circularProgress();
    } else if (postsList.isEmpty) {
      print("List Empty hai");
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Icon(
                Icons.photo_library,
                color: Colors.grey,
                size: 200.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "No Posts",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    } else if (postOrientation == "grid") {
      List<GridTile> gridTilesList = [];
      postsList.forEach((eachPost) {
        gridTilesList.add(GridTile(child: PostTile(eachPost)));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        //physics: NeverScrollableScrollPhysics(),
        children: gridTilesList,
      );
    } else if (postOrientation == "list") {
      return Column(
        children: postsList,
      );
    }
  }

  getAllProfilePosts() async {
    setState(() {
      loading = true;
    });

    QuerySnapshot querySnapshot = await postsReference
        .document(widget.userProfileId)
        .collection("time")
        .orderBy("timestamp", descending: true)
        .getDocuments();

    setState(() {
      loading = false;
      countPost = querySnapshot.documents.length;
      postsList = querySnapshot.documents
          .map((documentSnapshot) => Post.fromDocument(documentSnapshot))
          .toList();
    });
  }

  // create createListAndGridPostOrientation
  createListAndGridPostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => setOrientation("grid"),
          icon: Icon(Icons.grid_on),
          color: postOrientation == "grid"
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => setOrientation("list"),
          icon: Icon(Icons.list),
          color: postOrientation == "list"
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
      ],
    );
  }

  setOrientation(String orientation) {
    setState(() {
      this.postOrientation = orientation;
    });
  }
}
