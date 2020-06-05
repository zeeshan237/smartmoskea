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

final StorageReference storageReference =
    FirebaseStorage.instance.ref().child("Post Pictures");

final postsReference = Firestore.instance.collection("posts");
//upload page

class HomeMsg extends StatefulWidget {
  final User gCurrentUser;
  HomeMsg({this.gCurrentUser});

  @override
  _HomeMsg createState() => _HomeMsg();
}

class _HomeMsg extends State<HomeMsg> {
//Needs Integration captureImageWithCamera method
  
  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
