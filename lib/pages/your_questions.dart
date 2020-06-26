import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_moskea/pages/PhotoUpload.dart';
import 'package:smart_moskea/models/user.dart';
import 'package:smart_moskea/pages/answered.dart';
import 'package:smart_moskea/pages/favorite.dart';
import 'package:smart_moskea/pages/loggedInMainScreen.dart';
import 'package:smart_moskea/widgets/PostTileWidget.dart';
import 'package:smart_moskea/widgets/postWidget.dart';
import 'package:smart_moskea/widgets/progress.dart';

final StorageReference storageReference =
    FirebaseStorage.instance.ref().child("Post Pictures");
final usersRef = Firestore.instance.collection('users');
final postsReference = Firestore.instance.collection("posts");

//upload page

class YourQuestion extends StatefulWidget {
  // final User gCurrentUser;
  // HomeMsg({this.gCurrentUser});
// Forum code from favortie icon Start
  final String userProfileId;
  //HomeMsg({this.userProfileId});
  YourQuestion({this.userProfileId});
// Forum code from favortie icon End
  @override
  _YourQuestion createState() => _YourQuestion();
}

class _YourQuestion extends State<YourQuestion> {
//Needs Integration captureImageWithCamera method

// Forum code from favortie icon Start
  bool loading = false;
  int countPost = 0;
  List<Post> postsList = [];
  String postOrientation = "list";
// Forum code from favortie icon End

  // Forum code from favortie icon Start

  // Forum code from favortie icon End
  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Forum code from favortie icon Start

      body: FutureBuilder<bool>(
          future: getAllProfilePosts(),
          builder: (context, snapshot) {
            //  print(postsList[0].timestamp);
            if (!snapshot.hasData || !snapshot.data) return circularProgress();
            return ListView(
              children: <Widget>[
                // buildProfileHeader(),
                createListAndGridPostOrientation(),
                Divider(
                  height: 5.0,
                ),
                displayProfilePost(),
                // Divider(),
                // buildTogglePostOrientation(),
                // Divider(
                //   height: 0.0,
                // ),
                //  buildProfilePosts(),
              ],
            );
          }),

      // Forum code from favortie icon End
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrangeAccent,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return new UploadPhotoPage();
            }));
          }

          // file == null ? takeImage(context) : displayUploadFormScreen(),
          //this on pressed when called takeImage will be called success but
          //after image taken it should be displayUploadFormScreen() called but its not working, check this small issue so i will also judge your expertise then we will discuss project details budget and document
          //add question here.
          // r u there?????
          ),
    );
  }

  /// display post from post widget to profile
  displayProfilePost() {
    // if (postsList.isEmpty) {
    //   print("List Empty hai");
    //   return Container(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         Padding(
    //           padding: EdgeInsets.all(30.0),
    //           child: Icon(
    //             Icons.photo_library,
    //             color: Colors.grey,
    //             size: 200.0,
    //           ),
    //         ),
    //         Padding(
    //           padding: EdgeInsets.only(top: 20.0),
    //           child: Text(
    //             "No Posts",
    //             style: TextStyle(
    //                 color: Colors.black,
    //                 fontSize: 40.0,
    //                 fontWeight: FontWeight.bold),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // } else
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

  // // g code 2 this one is working code just ascending order is issue
  // Future<bool> getAllProfilePosts() async {
  //   QuerySnapshot querySnapshot =
  //       await Firestore.instance.collection("users").getDocuments();
  //   postsList.clear();
  //   for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
  //     QuerySnapshot userPosts = await postsReference
  //         .document(documentSnapshot.documentID)
  //         .collection("usersPosts")
  //         .orderBy("timestamp", descending: true)
  //         .getDocuments();

  //     postsList.addAll(userPosts.documents
  //         .map((documentSnapshot) => Post.fromDocument(documentSnapshot)));
  //   }
  //   countPost = postsList.length;

  //   print("all users post count: $countPost");
  //   return true;
  // }

  // Future<bool> getAllProfilePosts() async {
  //   // postsList.clear();
  //   QuerySnapshot querySnapshot = await Firestore.instance
  //       .collection("posts")
  //       .orderBy("timestamp", descending: true)
  //       .getDocuments();
  //   //  postsList.clear();

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

// working code with particular user id start
  Future<bool> getAllProfilePosts() async {
    if (postsList.isNotEmpty) return true;
    QuerySnapshot querySnapshot = await postsReference
        .document(widget.userProfileId)
        .collection("usersPosts")
        .orderBy("timestamp", descending: true)
        .getDocuments();
    countPost = querySnapshot.documents.length;
    postsList = querySnapshot.documents
        .map((documentSnapshot) => Post.fromDocument(documentSnapshot))
        .toList();
    return true;
  }

  // working code with particular user id end

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

  // Forum code from favortie icon End

// //Text Editing Controller
//   TextEditingController descriptionTextEditingController =
//       TextEditingController();
//   TextEditingController locationTextEditingController = TextEditingController();

//   captureImageWithCamera() async {
//     Navigator.pop(context);
//     File imageFile = await ImagePicker.pickImage(
//       source: ImageSource.camera,
//       maxHeight: 680,
//       maxWidth: 970,
//     );
//     setState(() {
//       this.file = imageFile;
//     });
//   }

// // Needs integration pickImageFromGallery method
//   void pickImageFromGallery() async {
//     Navigator.pop(context);
//     var imageFile = await ImagePicker.pickImage(
//       source: ImageSource.gallery,
//     );
//     setState(() {
//       file = imageFile;
//     });
//   }

// // Needs integration takeImage method
//   takeImage(mContext) {
//     return showDialog(
//       context: mContext,
//       builder: (context) {
//         return SimpleDialog(
//           title: Text(
//             "Ask Your Question By: ",
//             style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//           ),
//           children: <Widget>[
//             SimpleDialogOption(
//               child: Text(
//                 "ASK Question                                (without Image)",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.bold),
//               ),
//               //onPressed: (),
//             ),
//             SimpleDialogOption(
//               child: Text(
//                 "ASK Question                                     (with Camera Image)",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.bold),
//               ),
//               onPressed: captureImageWithCamera,
//             ),
//             SimpleDialogOption(
//               child: Text(
//                 "ASK Question                                     (with Gallery Image)",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.bold),
//               ),
//               onPressed: pickImageFromGallery,
//             ),
//             SimpleDialogOption(
//               child: Text(
//                 "Cancel",
//                 style: TextStyle(color: Colors.black, fontSize: 15.0),
//               ),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ],
//         );
//       },
//     );
//   }

// //Needs Integration display page widget
//   displayUploadScreen() {
//     print("on pressed call mid");

//     return Container(
//       color: Theme.of(context).accentColor.withOpacity(0.5),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Icon(
//             Icons.add_photo_alternate,
//             color: Colors.grey,
//             size: 200.0,
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 20.0),
//             child: RaisedButton(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(9.0),
//                 ),
//                 child: Text(
//                   "Upload Image",
//                   style: TextStyle(color: Colors.white, fontSize: 20.0),
//                 ),
//                 color: Colors.green,
//                 onPressed: () => takeImage(context)),
//           ),
//         ],
//       ),
//     );
//   }

// //remove Image Method
//   removeImage() {
//     setState(() {
//       file = null;
//     });
//   }

// // Needs Integration getUserCurrentLocation method for location of user in post
//   getUserCurrentLocation() async {
//     Position position = await Geolocator()
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     List<Placemark> placemarks = await Geolocator()
//         .placemarkFromCoordinates(position.latitude, position.longitude);
//     Placemark mPlaceMark = placemarks[0];
//     String completeAddressInfo =
//         "${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare}, ${mPlaceMark.subLocality} ${mPlaceMark.locality}, ${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, ${mPlaceMark.postalCode} ${mPlaceMark.country}";

//     String specificAddress = '${mPlaceMark.locality}, ${mPlaceMark.country} ';
//     locationTextEditingController.text = specificAddress;
//   }

// // Needs Integration display Screent to get description Question
//   Future<Widget> displayUploadFormScreen() async {
//     print("displayUploadFormScreen Called success");
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             ),
//             onPressed: removeImage),
//         title: Text(
//           "New Post",
//           style: TextStyle(
//               fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         actions: <Widget>[
//           FlatButton(
//             onPressed: () => print("tapped"),
//             child: Text(
//               "Share",
//               style: TextStyle(
//                   color: Colors.lightGreenAccent,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16.0),
//             ),
//           ),
//         ],
//       ),
//       body: ListView(
//         children: <Widget>[
//           Container(
//             height: 230.0,
//             width: MediaQuery.of(context).size.width * 0.8,
//             child: Center(
//               child: AspectRatio(
//                 aspectRatio: 16 / 9,
//                 child: Container(
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                     image: FileImage(file),
//                     fit: BoxFit.cover,
//                   )),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 12.0),
//           ),
//           ListTile(
//             // leading: CircleAvatar(
//             //   backgroundImage:
//             //       CachedNetworkImageProvider(widget.gCurrentUser.url),
//             // ),
//             title: Container(
//                 width: 250.0,
//                 child: TextField(
//                   style: TextStyle(color: Colors.black),
//                   controller: descriptionTextEditingController,
//                   decoration: InputDecoration(
//                     hintText: "Say Something About Image.",
//                     hintStyle: TextStyle(color: Colors.black),
//                     border: InputBorder.none,
//                   ),
//                 )),
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(
//               Icons.person_pin_circle,
//               color: Colors.white,
//               size: 36.0,
//             ),
//             title: Container(
//                 width: 250.0,
//                 child: TextField(
//                   style: TextStyle(color: Colors.white),
//                   controller: locationTextEditingController,
//                   decoration: InputDecoration(
//                     hintText: "Write the location here",
//                     hintStyle: TextStyle(color: Colors.white),
//                     border: InputBorder.none,
//                   ),
//                 )),
//           ),
//           Container(
//               width: 220.0,
//               height: 110,
//               alignment: Alignment.center,
//               child: RaisedButton.icon(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(35.0)),
//                 color: Colors.green,
//                 icon: Icon(
//                   Icons.location_on,
//                   color: Colors.white,
//                 ),
//                 label: Text(
//                   "Get my Current Location",
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onPressed: getUserCurrentLocation,
//               ))
//         ],
//       ),
//     );
//   }

  // body: new Container(
  //     constraints: BoxConstraints(maxWidth: 1000.0),
  //     padding: EdgeInsets.only(left: 10.0, top: 10.0),
  //     child: new ListView(
  //       children: <Widget>[
  //         new ListTile(
  //             title: new RichText(
  //               text: new TextSpan(
  //                   style: new TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 14.0,
  //                   ),
  //                   children: <TextSpan>[
  //                     new TextSpan(
  //                         text: "You asked ",
  //                         style: new TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                         )),
  //                     new TextSpan(
  //                         text:
  //                             "'What is the difference sunnah and faraiz deeds'")
  //                   ]),
  //             ),
  //             subtitle: new Text("2 minutes ago"),
  //             trailing: IconButton(
  //               icon: Icon(
  //                 Icons.delete_outline,
  //               ),
  //               onPressed: () {},
  //             )),
  //         new Divider(),
  //         new ListTile(
  //             title: new RichText(
  //               text: new TextSpan(
  //                   style: new TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 14.0,
  //                   ),
  //                   children: <TextSpan>[
  //                     new TextSpan(
  //                         text: "You asked ",
  //                         style: new TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                         )),
  //                     new TextSpan(text: "'What is the meaning of shirq'")
  //                   ]),
  //             ),
  //             subtitle: new Text("2 minutes ago"),
  //             trailing: IconButton(
  //               icon: Icon(
  //                 Icons.delete_outline,
  //               ),
  //               onPressed: () {},
  //             )),
  //         new Divider(),
  //         new ListTile(
  //           title: new RichText(
  //             text: new TextSpan(
  //                 style: new TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 14.0,
  //                 ),
  //                 children: <TextSpan>[
  //                   new TextSpan(
  //                       text: "You asked ",
  //                       style: new TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                       )),
  //                   new TextSpan(
  //                       text: "'Is it good to sleep after fajar prayer'")
  //                 ]),
  //           ),
  //           subtitle: new Text("2 hours ago"),
  //           trailing: IconButton(
  //             icon: Icon(
  //               Icons.delete_outline,
  //             ),
  //             onPressed: () {},
  //           ),
  //         ),
  //         new Divider(),
  //         new ListTile(
  //             title: new RichText(
  //               text: new TextSpan(
  //                   style: new TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 14.0,
  //                   ),
  //                   children: <TextSpan>[
  //                     new TextSpan(
  //                         text: "You asked ",
  //                         style: new TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                         )),
  //                     new TextSpan(
  //                         text: "'how to jugde a double face person'")
  //                   ]),
  //             ),
  //             subtitle: new Text("2 minutes ago"),
  //             trailing: IconButton(
  //               icon: Icon(
  //                 Icons.delete_outline,
  //               ),
  //               onPressed: () {},
  //             )),
  //         new Divider(),
  //         new ListTile(
  //             title: new RichText(
  //               text: new TextSpan(
  //                   style: new TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 14.0,
  //                   ),
  //                   children: <TextSpan>[
  //                     new TextSpan(
  //                         text: "You asked ",
  //                         style: new TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                         )),
  //                     new TextSpan(
  //                         text:
  //                             "'What is the difference between those who fast and one who dont'")
  //                   ]),
  //             ),
  //             subtitle: new Text("2 month ago"),
  //             trailing: IconButton(
  //               icon: Icon(
  //                 Icons.delete_outline,
  //               ),
  //               onPressed: () {},
  //             )),
  //         new Divider(),
  //         new ListTile(
  //             title: new RichText(
  //               text: new TextSpan(
  //                   style: new TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 14.0,
  //                   ),
  //                   children: <TextSpan>[
  //                     new TextSpan(
  //                         text: "You asked ",
  //                         style: new TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                         )),
  //                     new TextSpan(
  //                         text: "'Which islamic name is best for a boy'")
  //                   ]),
  //             ),
  //             subtitle: new Text("2 minutes ago"),
  //             trailing: IconButton(
  //               icon: Icon(
  //                 Icons.delete_outline,
  //               ),
  //               onPressed: () {},
  //             )),
  //         new Divider(),
  //       ],
  //     )),

}
