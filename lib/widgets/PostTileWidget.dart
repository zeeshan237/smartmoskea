import 'package:flutter/material.dart';

import 'package:smart_moskea/widgets/postWidget.dart';

class PostTile extends StatelessWidget {
  final Post post;
  PostTile(this.post);

  // showPost(context) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => PostScreen(
  //                 postId: this.post.postId,
  //                 userId: this.post.ownerId,
  //               )));
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.network(post.url),
    );
    // return GestureDetector(
    //   onTap: () => showPost(context),
    //   child: cachedNetworkImage(post.mediaUrl),
    // );
  }
}
