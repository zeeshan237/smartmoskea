library timeago_flutter;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_moskea/pages/PhotoUpload.dart';
import 'package:smart_moskea/widgets/header.dart';
import 'package:smart_moskea/widgets/postWidget.dart';
import 'package:smart_moskea/widgets/progress.dart';
import 'package:timeago/timeago.dart' as tAgo;

class CommentsPage extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postImageUrl;

  CommentsPage({this.postId, this.postOwnerId, this.postImageUrl});
  @override
  CommentsPageState createState() => CommentsPageState(
      postId: postId, postOwnerId: postOwnerId, postImageUrl: postImageUrl);
}

class CommentsPageState extends State<CommentsPage> {
  final String postId;
  final String postOwnerId;
  final String postImageUrl;

  TextEditingController commentTextEditingController = TextEditingController();

  CommentsPageState({this.postId, this.postOwnerId, this.postImageUrl});

  updateDetails() {
    setState(() {});
  }

  String currentOnlineUserId;
  String currentOnlineUserName;
  String currentOnlineUserUrl;
  void initState() {
    super.initState();
    getUserId().then((value) {
      currentOnlineUserId = value;
      updateDetails();
    });

    getUserName().then((value) {
      currentOnlineUserName = value;
      updateDetails();
    });

    // getUserPostIMGUrl().then((value) {
    //   currentOnlineUserUrl = value;
    //   updateDetails();
    // });
  }

  retrieveComments() {
    return StreamBuilder(
      stream: commentsReference
          .document(postId)
          .collection('comments')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        List<Comment> comments = [];
        dataSnapshot.data.documents.forEach((document) {
          comments.add(Comment.fromDocument(document));
        });
        return ListView(children: comments);
      },
    );
  }

  saveComment() {
    commentsReference.document(postId).collection('comments').add({
      'name': currentOnlineUserName,
      'comment': commentTextEditingController.text,
      'timestamp': DateTime.now(),
      // 'url': currentOnlineUserUrl,
      'userId': currentOnlineUserId,
    });
    bool isNotCommentOwner = postOwnerId != currentOnlineUserId;
    if (isNotCommentOwner) {
      activityFeedReference.document(postOwnerId).collection('feedItems').add({
        'type': 'comment',
        'commentData': commentTextEditingController.text,
        'timestamp': timestamp,
        'postId': postId,
        'username': currentOnlineUserName,
        'userId': currentOnlineUserId,
        // 'userProfileImg': currentUser.photoUrl,
        //"url": currentOnlineUserUrl,
      });
    }
    commentTextEditingController.clear();
  }

//get User Id

  Future<String> getUserId() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    print('my uid' + user.uid);

    print('my email' + user.email);

    return user.uid;
  }

//get User name

  Future<String> getUserName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot ds =
        await Firestore.instance.collection('users').document(user.uid).get();
    print('my uid' + user.uid);
    print('my name' + ds.data['name']);
    print('my email' + user.email);

    return ds.data['name'];
  }

  //get User post question image url

//  Future<String> getUserPostIMGUrl() async {
//     FirebaseUser user = await FirebaseAuth.instance.currentUser();
//     DocumentSnapshot ds =
//         await Firestore.instance.collection('users').document(user.uid).get();
//     print('my uid' + user.uid);
//     print('my name' + ds.data['name']);
//     print('my email' + user.email);

//     return ds.data['url'];
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   color: Colors.black,
        //   onPressed: clearPostInfo,
        // ),
        title: new Text("Comments"),
        centerTitle: true,
      ),
      // appBar: header(context, titleText: 'Comments'),
      body: Column(
        children: <Widget>[
          Expanded(
            child: retrieveComments(),
          ),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentTextEditingController,
              decoration: InputDecoration(
                labelText: 'Write a comment....',
                labelStyle: TextStyle(color: Colors.green),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)),
              ),
              style: TextStyle(color: Colors.green),
            ),
            trailing: OutlineButton(
              onPressed: saveComment,
              borderSide: BorderSide.none,
              child: Text(
                'Published',
                style: TextStyle(
                    color: Colors.lightGreenAccent,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String name;
  final String userId;
  //final String url;
  final String comment;
  final Timestamp timestamp;

  Comment({this.name, this.userId, this.comment, this.timestamp});

  factory Comment.fromDocument(DocumentSnapshot documentSnapshot) {
    return Comment(
      name: documentSnapshot["name"],
      userId: documentSnapshot["userId"],
      //url: documentSnapshot["url"],
      comment: documentSnapshot["comment"],
      timestamp: documentSnapshot["timestamp"],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.deepOrangeAccent[100],
        child: Column(children: <Widget>[
          ListTile(
              title: Text(
                name + ":   " + comment,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
              ),
              leading: CircleAvatar(
                  backgroundImage:
                      new NetworkImage("http://i.pravatar.cc/300")),
              subtitle: Text(
                tAgo.format(timestamp.toDate()),
                style: TextStyle(color: Colors.black),
              )),
        ]),
      ),
    );
  }
}
