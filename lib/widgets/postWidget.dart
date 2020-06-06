import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:smart_moskea/models/user.dart';
import 'package:smart_moskea/pages/PhotoUpload.dart';
import 'package:smart_moskea/pages/HomeMsg.dart';
import 'package:smart_moskea/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smart_moskea/widgets/CImageWidget.dart';

class Post extends StatefulWidget {
//   Post() {

//   }));
//  }
  //final Post post;

  //PostWidget(this.post);

  final String postId;
  final String ownerId;
  final String username;
  final String url;
  final String email;
  final String description;
  final dynamic likes;

  Post({
    this.postId,
    this.ownerId,
    this.username,
    this.url,
    this.email,
    this.description,
    this.likes,
  });

  factory Post.fromDocument(DocumentSnapshot documentSnapshot) {
    return Post(
      postId: documentSnapshot["postId"],
      ownerId: documentSnapshot["ownerId"],
      username: documentSnapshot["username"],
      url: documentSnapshot["url"],
      email: documentSnapshot["email"],
      description: documentSnapshot["description"],
      likes: documentSnapshot["likes"],
    );
  }

  int getTotalNumberOfLikes(likes) {
    if (likes == null) {
      return 0;
    }

    int counter = 0;
    likes.values.forEach((eachValue) {
      if (eachValue == true) {
        counter = counter + 1;
      }
    });
    return counter;
  }

  @override
  _PostState createState() => _PostState(
        postId: this.postId,
        ownerId: this.ownerId,
        username: this.username,
        url: this.url,
        email: this.email,
        description: this.description,
        likes: this.likes,
        likeCount: getTotalNumberOfLikes(this.likes),
      );
}

class _PostState extends State<Post> {
  updateDetails() {
    setState(() {});
  }

  void initState() {
    super.initState();
    getUserId().then((value) => ((uid) {
          currentOnlineUserId = uid;
          print("meri id yeh hai" + currentOnlineUserId);

          updateDetails();
        }));
  }

  // updateDetails() {
  //   setState(() {});
  // }

  // Post() {
  //   getUserId().then((value) {
  //     if (value != null) {
  //       this.accountId = value;
  //       updateDetails();
  //     }
  //   });
  // }

  // String accountEmail = "";
  // String accountName = "";
  // String accountId = "";

  final String postId;
  final String ownerId;
  final String username;
  final String url;
  final String email;
  final String description;
  Map likes;
  int likeCount;
  bool isLiked;
  bool showHeart = false;
  String currentOnlineUserId;

  _PostState({
    this.postId,
    this.ownerId,
    this.username,
    this.url,
    this.email,
    this.description,
    this.likes,
    this.likeCount,
  });

  //final usersReference = Firestore.instance.collection("users");
  //final CollectionReference usersReference = Firestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          createPostHead(),
          createPostPicture(),
          createPostFooter()
        ],
      ),
    );
  }

  createPostHead() {
    return FutureBuilder(
      future: usersRef.document(ownerId).get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(dataSnapshot.data);
        bool isPostOwner = currentOnlineUserId == ownerId;

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.url),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () => print("Show Profile"),
            child: Text(
              user.name,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          trailing: isPostOwner
              ? IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  onPressed: () => print("deleted"),
                )
              : Text(""),
        );
      },
    );
  }

  createPostPicture() {
    return GestureDetector(
      onDoubleTap: () => print("Post Liked"),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.network(url),
        ],
      ),
    );
  }

//createPostFooter method

  createPostFooter() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            GestureDetector(
              onTap: () => print("liked Post"),
              child: Icon(
                Icons.favorite, color: Colors.grey,
                // isLiked ? Icons.favorite : Icons.favorite_border,
                // size: 20.0,
                // color: Colors.pink,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: () => print("Show Comments"),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 28.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  "StickerCount Likes",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ))
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$username ",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
                child: Text(
              description,
              style: TextStyle(color: Colors.white),
            ))
          ],
        )
      ],
    );
  }

  //@override
  // String currentUserId = currentUser?.id;
  // int likeCount;
  // bool isLiked;
  // Map likes;
  // bool showHeart = false;

  //get User Id

  Future<String> getUserId() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    print('my uid' + user.uid);

    print('my email' + user.email);

    return user.uid;
  }
}
