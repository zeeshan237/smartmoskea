import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:smart_moskea/models/user.dart';
import 'package:smart_moskea/pages/CommentsPage.dart';
import 'package:smart_moskea/pages/PhotoUpload.dart';
import 'package:smart_moskea/pages/loggedInMainScreen.dart';
import 'package:smart_moskea/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smart_moskea/widgets/CImageWidget.dart';
import 'package:smart_moskea/pages/PhotoUpload.dart';

final usersRef = Firestore.instance.collection('users');
final DateTime timestamp = DateTime.now();

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String url;
  final String email;
  final String description;
  final dynamic likes;
  final int catogery;

  Post({
    this.postId,
    this.ownerId,
    this.username,
    this.url,
    this.email,
    this.description,
    this.likes,
    this.catogery,
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
        catogery: documentSnapshot["catogery"]);
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
        catogery: this.catogery,
      );
}

class _PostState extends State<Post> {
  final String postId;
  final String ownerId;
  final String username;
  final String url;
  final String email;
  final String description;
  Map likes;
  String currentUserId;
  int likeCount;
  bool isLiked;
  bool showHeart = false;
  int catogery;
  //String currentOnlineUserId;

  _PostState({
    this.postId,
    this.ownerId,
    this.username,
    this.url,
    this.email,
    this.description,
    this.likes,
    this.likeCount,
    this.catogery,
  });

  updateDetails() {
    setState(() {});
  }

  String currentOnlineUserId;
  void initState() {
    super.initState();
    getUserId().then((value) {
      currentOnlineUserId = value;
      updateDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    {
      isLiked = (likes[currentOnlineUserId] == true);
    }
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

        bool isPostOwner = user.id == ownerId && user.catogery == 1;

        return ListTile(
          leading: CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider("http://i.pravatar.cc/300"),
            backgroundColor: Colors.black,
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
                    color: Colors.black,
                  ),
                  onPressed: () => print("deleted"),
                )
              : Text(""),
        );
      },
    );
  }

  removeLike() async {
    FirebaseUser cCurrentUser = await FirebaseAuth.instance.currentUser();
    bool isNotPostOwner = cCurrentUser.uid != ownerId;
    print("current user id in remove like " + cCurrentUser.uid);

    if (isNotPostOwner) {
      activityFeedReference
          .document(ownerId)
          .collection("feedItems")
          .document(postId)
          .get()
          .then((document) {
        if (document.exists) {
          document.reference.delete();
        }
      });
    }
  }

  addLike() async {
    final currentUserID = await getUserId();
    bool isNotPostOwner = currentUserID != ownerId;
    if (isNotPostOwner) {
      activityFeedReference
          .document(ownerId)
          .collection("feedItems")
          .document(postId)
          .setData({
        "type": "likes", //test change
        // "email": currentUser.email,
        "userId": currentUserID,
        "timeStamp": timestamp,
        // "url" : url,
        "postId": postId,
      });
    }
  }

  controlUserLikePost() async {
    final currentUserID = await getUserId();
    print("current user id in control user like " + currentUserID);
    bool _liked = likes[currentUserID] == true;
    if (_liked) {
      postsReference
          .document(ownerId)
          .collection('usersPosts')
          .document(postId)
          .updateData({
        'likes.$currentUserID': false,
      });
      removeLike();
      setState(() {
        likeCount = likeCount - 1;
        isLiked = false;
        likes[currentUserID] = false;
      });
    } else if (!_liked) {
      postsReference
          .document(ownerId)
          .collection('usersPosts')
          .document(postId)
          .updateData({
        'likes.$currentUserID': true,
      });
      addLike();

      setState(() {
        likeCount = likeCount + 1;
        isLiked = true;
        likes[currentUserID] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 800), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  createPostPicture() {
    return GestureDetector(
      onDoubleTap: () => controlUserLikePost(),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.network(
            url,
            height: 300,
            width: 320,
            fit: BoxFit.fitWidth,
          ),
          showHeart
              ? Icon(
                  Icons.favorite,
                  size: 100.0,
                  color: Colors.pink,
                )
              : Text(""),
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
              onTap: () => controlUserLikePost(),
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 28.0,
                color: Colors.pink,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 18.0)),
            GestureDetector(
              onTap: () => displayComments(context,
                  postId: postId, ownerId: ownerId, url: url),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 28.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 20.0, bottom: 5.0),
                child: Text(
                  "$likeCount likes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ))
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 40.0, left: 20.0, right: 5.0),
              child: Text(
                "Question:",
                // "$username ",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0),
              ),
            ),
            Expanded(
                child: Text(
              description,
              style: TextStyle(color: Colors.black, fontSize: 15.0),
            ))
          ],
        )
      ],
    );
  }

  //get User Id

  Future<String> getUserId() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    print('my uid' + user.uid);

    print('my email' + user.email);

    return user.uid;
  }

  displayComments(BuildContext context,
      {String postId, String ownerId, String url}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CommentsPage(
          postId: postId, postOwnerId: ownerId, postImageUrl: url);
    }));
  }
}
