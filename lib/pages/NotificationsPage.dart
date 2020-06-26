import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_moskea/pages/PhotoUpload.dart';
import 'package:smart_moskea/pages/PostScreenPage.dart';
import 'package:smart_moskea/pages/ProfilePage.dart';
import 'package:smart_moskea/widgets/header.dart';
import 'package:smart_moskea/widgets/progress.dart';
import 'package:timeago/timeago.dart' as tAgo;

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  updateDetails() {
    setState(() {});
  }

  String currentOnlineUserId;
  int currentOnlineUserCategory;
  void initState() {
    super.initState();
    getUserId().then((value) {
      currentOnlineUserId = value;
      updateDetails();
    });

    // getUserCategory().then((value) {
    //   currentOnlineUserCategory = value;
    //   updateDetails();
    // });
  }

  //get User Id

  Future<String> getUserId() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    print('my uid' + user.uid);

    print('my email' + user.email);

    return user.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   color: Colors.black,
        //   onPressed: clearPostInfo,
        // ),
        title: new Text("Notification"),
        centerTitle: true,
      ),
      // appBar: header(
      //   context,
      //   titleText: "Notification",
      // ),
      body: Container(
        child: FutureBuilder(
          future: retrieveNotification(),
          builder: (context, dataSnapshot) {
            if (!dataSnapshot.hasData) {
              return circularProgress();
            }
            return ListView(
              children: dataSnapshot.data,
            );
          },
        ),
      ),
    );
  }

  retrieveNotification() async {
    QuerySnapshot querySnapshot = await activityFeedReference
        .document(currentOnlineUserId)
        .collection("feedItems")
        .orderBy("timestamp", descending: true)
        .limit(60)
        .getDocuments();

    List<NotificationsItem> notificationsItem = [];
    querySnapshot.documents.forEach((docuement) {
      notificationsItem.add(NotificationsItem.fromDocument(docuement));
    });
    return notificationsItem;
  }
}

String notificationItemText;
Widget mediaPreview;

class NotificationsItem extends StatelessWidget {
  final String username;
  final String type;
  final String commentData;
  final String postId;
  final String userId;
  final Timestamp timestamp;

  NotificationsItem(
      {this.username,
      this.type,
      this.commentData,
      this.postId,
      this.userId,
      this.timestamp});

  factory NotificationsItem.fromDocument(DocumentSnapshot documentSnapshot) {
    return NotificationsItem(
      username: documentSnapshot["username"],
      type: documentSnapshot["type"],
      commentData: documentSnapshot["commentData"],
      postId: documentSnapshot["postId"],
      userId: documentSnapshot["userId"],
      timestamp: documentSnapshot["timestamp"],
    );
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.deepOrangeAccent[100],
        child: ListTile(
          title: GestureDetector(
            onTap: () => displayUserProfile(context, userProfileId: userId),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: TextStyle(fontSize: 14.0, color: Colors.black),
                  children: [
                    TextSpan(
                        text: username,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " $notificationItemText"),
                  ]),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                "https://png.pngtree.com/element_our/png/20181206/users-vector-icon-png_260862.jpg"),
          ),
          subtitle: Text(
            tAgo.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

// To check the type of notificaiton it is
  configureMediaPreview(context) {
    if (type == "comment" || type == "likes") {
      mediaPreview = GestureDetector(
        onTap: () => displayFullPost(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    "https://png.pngtree.com/element_our/png/20181206/users-vector-icon-png_260862.jpg"),
              )),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text("");
    }

    if (type == "likes") {
      notificationItemText = "Liked your post";
    } else if (type == "comment") {
      notificationItemText = "replied : $commentData";
    } else {
      notificationItemText = "Error, Unknown type = $type ";
    }
  }

  displayFullPost(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostScreenPage(postId: postId, userId: userId),
        ));
  }

  displayUserProfile(BuildContext context, {String userProfileId}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(userProfileId: userProfileId)));
  }
}
