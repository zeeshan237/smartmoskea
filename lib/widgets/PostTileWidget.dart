import 'package:flutter/material.dart';
import 'package:smart_moskea/pages/PostScreenPage.dart';
import 'package:smart_moskea/widgets/postWidget.dart';

class PostTile extends StatelessWidget {
  final Post post;
  PostTile(this.post);

//New code 13-june grid open image
  displayFullPost(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PostScreenPage(
                  postId: post.postId,
                  userId: post.ownerId,
                )));
  }

// New code 13-june grid open image end
  @override
  Widget build(BuildContext context) {
    if (post.url == "abc") {
      return GestureDetector(
        onTap: () => displayFullPost(context),
        child: Image.network(
            'https://responsewebrecruitment.co.uk/wp-content/uploads/2013/06/question-bubble.jpg'),
      );
    } else {
      return GestureDetector(
        onTap: () => displayFullPost(context),
        child: Image.network(post.url),
      );
      // return GestureDetector(
      //   onTap: () => showPost(context),
      //   child: cachedNetworkImage(post.mediaUrl),
      // );
    }
  }
}
