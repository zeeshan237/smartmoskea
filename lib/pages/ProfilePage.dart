import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_moskea/pages/PhotoUpload.dart';
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
  String postOrientation = "list";
  Future<bool> _future;

  @override
  void initState() {
    super.initState();
    _future = getAllProfilePosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: header(context, titleText: 'Profile'),
      body: FutureBuilder<bool>(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data) return circularProgress();

            return ListView(
              children: <Widget>[
                // buildProfileHeader(),
                createListAndGridPostOrientation(),
                Divider(
                  height: 10.0,
                ),
                displayProfilePost(),
              ],
            );
          }),
    );
  }

// display post from post widget to profile
  displayProfilePost() {
    if (postOrientation == "list") {
      return Column(
        children: postsList,
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
        physics: NeverScrollableScrollPhysics(),
        children: gridTilesList,
      );
    }
  }

  // Future<bool> getAllProfilePosts() async {
  //   QuerySnapshot querySnapshot = await postsReference.getDocuments();
  //   for (int i = 0; i < querySnapshot.documents.length; i++) {
  //     var document = querySnapshot.documents[i];
  //     var userPosts = document.reference.collection("usersPosts");
  //     QuerySnapshot postsSnapshot =
  //         await userPosts.orderBy("timestamp", descending: true).getDocuments();
  //     countPost = postsSnapshot.documents.length;
  //     postsList = postsSnapshot.documents
  //         .map((document) => Post.fromDocument(document))
  //         .toList();
  //   }
  //   return true;
  // }

// ProfilePage (Heart Icon) code 2 this one is working code
  Future<bool> getAllProfilePosts() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("users").getDocuments();

    for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
      QuerySnapshot userPosts = await postsReference
          .document(documentSnapshot.documentID)
          .collection("usersPosts")
          .orderBy("timestamp", descending: true)
          .getDocuments();

      postsList.addAll(userPosts.documents
          .map((documentSnapshot) => Post.fromDocument(documentSnapshot)));
    }
    postsList.sort((a, b) {
      DateTime one = a.timestamp;
      DateTime two = b.timestamp;
      int val = two.compareTo(one);

      return val;
    });
    countPost = postsList.length;

    print("Profile: all users post count: $countPost");
    return true;
  }

  // Future<bool> getAllProfilePosts() async {
  //   postsList.clear();
  //   QuerySnapshot querySnapshot = await Firestore.instance
  //       .collection("posts")
  //       .orderBy("timestamp", descending: true)
  //       .getDocuments();

  //   for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
  //     postsList.add(Post.fromDocument(documentSnapshot));
  //   }
  //   // for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
  //   //   QuerySnapshot userPosts = await postsReference
  //   //       .document()
  //   //       .collection(documentSnapshot.documentID)
  //   //       // .orderBy("timestamp", descending: true)
  //   //       .getDocuments();
  //   //   postsList.addAll(userPosts.documents
  //   //       .map((documentSnapshot) => Post.fromDocument(documentSnapshot)));
  //   // }
  //   countPost = postsList.length;
  //   print("all users post count: $countPost");
  //   return true;
  // }
//g code

  // Future<bool> getAllProfilePosts() async {
  //   if (postsList.isNotEmpty) return true;
  //   QuerySnapshot querySnapshot = await postsReference.getDocuments();
  //   for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
  //     QuerySnapshot userPosts = await postsReference
  //         .document(documentSnapshot.documentID)
  //         .collection("usersPosts")
  //         .orderBy("timestamp", descending: true)
  //         .getDocuments();
  //     postsList.addAll(userPosts.documents
  //         .map((documentSnapshot) => Post.fromDocument(documentSnapshot)));

  //     // if (userPosts == null) {
  //     //   print(" post List is empty:" + userPosts);
  //     // } else {
  //     //   print("post List is not empty");
  //     // }
  //   }
  //   countPost = postsList.length;
  //   print("all users post count: $countPost");
  //   //}
  //   return true;
  // }

// // last time checking
//   Future<bool> getAllProfilePosts() async {
//     if (postsList.isNotEmpty) return true;
//     List documentIdList = [];

//     var respectsQuery = Firestore.instance.collection('posts');
//     var postDocLength = await respectsQuery.getDocuments();
//     for (int i = 0; i < postDocLength.documents.length; i++) {
//       documentIdList.add(postDocLength.documents[i].documentID);
//       print("print document id" + postDocLength.documents[i].documentID);
//     }

//     for (int i = 0; i < documentIdList.length; i++) {
//       QuerySnapshot querySnapshot = await postsReference
//           .document(documentIdList[i])
//           .collection("usersPosts")
//           .orderBy("timestamp", descending: true)
//           .getDocuments();

//       postsList = querySnapshot.documents
//           .map((documentSnapshot) => Post.fromDocument(documentSnapshot))
//           .toList();
//     }
//     countPost = postsList.length;
//     print("all users post count: $countPost");
//     print(documentIdList.length);
//     return true;
//   }

  // //working but small confusion end

  // Future<bool> getAllProfilePosts() async {
  //   QuerySnapshot querySnapshot = await postsReference.getDocuments();
  //   for (int i = 0; i < querySnapshot.documents.length; i++) {
  //     var document = querySnapshot.documents[i];
  //     var userPosts = document.reference
  //         .collection("usersPosts")
  //         .orderBy("timestamp", descending: true)
  //         .getDocuments();
  //     countPost = querySnapshot.documents.length;
  //     postsList = querySnapshot.documents
  //         .map((documentSnapshot) => Post.fromDocument(documentSnapshot))
  //         .toList();
  //   }
  //   return true;
  // }

  // create createListAndGridPostOrientation
  createListAndGridPostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => setOrientation("list"),
          icon: Icon(Icons.list),
          color: postOrientation == "list"
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => setOrientation("grid"),
          icon: Icon(Icons.grid_on),
          color: postOrientation == "grid"
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
