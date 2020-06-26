import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_moskea/models/user.dart';
import 'package:smart_moskea/pages/CommentsPage.dart';
import 'package:smart_moskea/pages/CommentsPage1.dart';

import 'package:smart_moskea/pages/PhotoUpload.dart';
import 'package:smart_moskea/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';

final usersRef = Firestore.instance.collection('users');
final DateTime timestamp = DateTime.now();

// ignore: must_be_immutable
class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String url;
  final String email;
  final String description;
  final dynamic likes;
  final int catogery;
  DateTime timestamp;

  Post({
    this.postId,
    this.ownerId,
    this.username,
    this.url,
    this.email,
    this.description,
    this.likes,
    this.catogery,
    this.timestamp,
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
        catogery: documentSnapshot["catogery"],
        timestamp: documentSnapshot["timestamp"].toDate());
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
        timestamp: this.timestamp,
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
  DateTime timestamp;
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
    this.timestamp,
  });

  updateDetails() {
    setState(() {});
  }

  String currentOnlineUserId;
  int currentOnlineUserCategory;
  String currentUserName;
  void initState() {
    super.initState();
    getUserId().then((value) {
      currentOnlineUserId = value;
      //updateDetails();
    });

    getUserCategory().then((value) {
      currentOnlineUserCategory = value;
      //updateDetails();
    });

    getUserName().then((value) {
      currentUserName = value;
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
          Divider(
            color: Colors.black,
            height: 10.0,
          ),
          createPostHead(),
          createPostFooter(),
          createPostPicture(),
          createPostFooterComentLike(),
        ],
      ),
    );
  }

// delete post code 26 june
  handleDeletePost(BuildContext parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) => SimpleDialog(
        title: Text("Remove this post ?"),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              deletePost();
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text("Your Question is Deleted"),
                    );
                  });
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          )
        ],
      ),
    );
  }

  // To delete a post, ownerId and currentUserId must be equal.
  deletePost() async {
    // delete post itself
    postsReference
        .document(ownerId)
        .collection('usersPosts')
        .document(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // delete uploaded image from the post
    storageReference.child('post_$postId.jpg').delete();

    // delete all activity field notifications
    QuerySnapshot activityFeedSnapshot = await activityFeedReference
        .document(ownerId)
        .collection('feedItems')
        .where('postId', isEqualTo: postId)
        .getDocuments();
    activityFeedSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // delete all comments
    QuerySnapshot commentsSnapshot = await commentsReference
        .document(postId)
        .collection('comments')
        .getDocuments();
    commentsSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  createPostHead() {
    return FutureBuilder(
      future: usersRef.document(ownerId).get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(dataSnapshot.data);

        bool isPostOwner = user.id == ownerId || user.catogery == 3;

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
                "https://png.pngtree.com/element_our/png/20181206/users-vector-icon-png_260862.jpg"),
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
                  onPressed: () => handleDeletePost(context),
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
    // final currentUserName = await getUserName();
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
        "timestamp": DateTime.now(),
        // "url" : url,
        "postId": postId,
        "username": currentUserName,
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
      if (url == "abc") {
        setState(() {
          likeCount = likeCount + 1;
          isLiked = true;
          likes[currentUserID] = true;
          showHeart = false;
        });
      } else {
        setState(() {
          likeCount = likeCount + 1;
          isLiked = true;
          likes[currentUserID] = true;
          showHeart = true;
        });
      }

      Timer(Duration(milliseconds: 800), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  createPostPicture() {
    if (url == "abc") {
      return GestureDetector(
        onDoubleTap: () => print("double tap"),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
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
    } else {
      return GestureDetector(
        onDoubleTap: () => controlUserLikePost(),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.network(
              url,
              height: 250,
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
  }

//createPostFooter method

  createPostFooter() {
    if (url == "abc") {
      return Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 15.0, left: 15.0, right: 10.0),
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
          ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 30.0, left: 15.0, right: 10.0),
                child: Text(
                  "Question:",
                  // "$username ",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0),
                ),
              ),
              Container(
                  constraints: BoxConstraints(maxWidth: 250.0),
                  // padding: EdgeInsets.only(left: 10.0, top: 10.0),
                  margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                  child: Text(
                    description,
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                  ))
            ],
          ),
        ],
      );
    }
  }

  // for question on top of the image and like coment at the bottom

  createPostFooterComentLike() {
    return FutureBuilder(
      future: usersRef.document(ownerId).get(),
      builder: (context, dataSnapshot) {
        // User user = User.fromDocument(dataSnapshot.data);
        bool isPostOwner =
            currentOnlineUserId == ownerId || currentOnlineUserCategory == 3;
        // print("category yeh hai");
        // print(currentOnlineUserCategory);
        if (url == "abc") {
          if (isPostOwner) {
            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 30.0, left: 20.0)),
                    GestureDetector(
                      onTap: () => controlUserLikePost(),
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 24.0,
                        color: Colors.pink,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(right: 15.0)),
                    GestureDetector(
                      onTap: () => displayComments(context,
                          postId: postId, ownerId: ownerId, url: url),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        size: 24.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 20.0, bottom: 0.0),
                        child: Text(
                          "$likeCount likes",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ],
            );
          } else {
            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 30.0, left: 20.0)),
                    GestureDetector(
                      onTap: () => controlUserLikePost(),
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 24.0,
                        color: Colors.pink,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(right: 15.0)),
                    GestureDetector(
                      onTap: () => displayComments1(context,
                          postId: postId, ownerId: ownerId, url: url),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        size: 24.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 20.0, bottom: 0.0),
                        child: Text(
                          "$likeCount likes",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ],
            );
          }
        } else {
          if (isPostOwner) {
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
                        size: 24.0,
                        color: Colors.pink,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(right: 15.0)),
                    GestureDetector(
                      onTap: () => displayComments(context,
                          postId: postId, ownerId: ownerId, url: url),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        size: 24.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 20.0, bottom: 0.0),
                        child: Text(
                          "$likeCount likes",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ],
            );
          } else {
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
                        size: 24.0,
                        color: Colors.pink,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(right: 15.0)),
                    GestureDetector(
                      onTap: () => displayComments1(context,
                          postId: postId, ownerId: ownerId, url: url),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        size: 24.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 20.0, bottom: 0.0),
                        child: Text(
                          "$likeCount likes",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ],
            );
          }
        }
      },
    );
  }

  //get User Id

  Future<String> getUserId() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    // print('my uid' + user.uid);

    // print('my email' + user.email);

    return user.uid;
  }

//get User Category

  Future<int> getUserCategory() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot ds =
        await Firestore.instance.collection('users').document(user.uid).get();
    // print('my uid' + user.uid);
    // print('my name' + ds.data['name']);
    // print('my email' + user.email);

    return ds.data['catogery'];
  }

  //get user name
  Future<String> getUserName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot ds =
        await Firestore.instance.collection('users').document(user.uid).get();
    // print('my uid' + user.uid);
    // print('my name' + ds.data['name']);
    // print('my email' + user.email);

    return ds.data['name'];
  }

  displayComments(BuildContext context,
      {String postId, String ownerId, String url}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CommentsPage(
          postId: postId, postOwnerId: ownerId, postImageUrl: url);
    }));
  }

  displayComments1(BuildContext context,
      {String postId, String ownerId, String url}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CommentsPage1(
          postId: postId, postOwnerId: ownerId, postImageUrl: url);
    }));
  }
}
