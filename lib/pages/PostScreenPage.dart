import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_moskea/widgets/postWidget.dart';

//New code 13-june grid open image

import '../widgets/progress.dart';

final postsReference = Firestore.instance.collection("posts");

class PostScreenPage extends StatelessWidget {
  final String userId;
  final String postId;
  final String currrentUserID;

  PostScreenPage({this.postId, this.userId, this.currrentUserID});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postsReference
          .document(userId)
          .collection('usersPosts')
          .document(postId)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        Post post = Post.fromDocument(snapshot.data);
        return Center(
          child: Scaffold(
            appBar: new AppBar(
              backgroundColor: Colors.deepOrangeAccent,
              title: new Text(
                "Question",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // appBar: header(context, titleText: post.description),
            body: ListView(
              children: <Widget>[
                Container(
                  child: post,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
