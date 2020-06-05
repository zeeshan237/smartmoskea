import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:smart_moskea/pages/HomeMsg.dart';
import 'package:smart_moskea/models/User.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;
import 'package:path_provider/path_provider.dart';
import '../widgets/progress.dart';

final StorageReference storageReference =
    FirebaseStorage.instance.ref().child("Post Pictures");

final postsReference = Firestore.instance.collection("posts");

class UploadPhotoPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _UploadPhotoPageState();
  }
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  final DateTime timestamp = DateTime.now();
  File sampleImage;
  bool uploading = false;
  String postId = Uuid().v4();

  TextEditingController descriptionTextEditingController =
      TextEditingController();

  String _myValue;
  final formKey = new GlobalKey<FormState>();

  //getting users details
  updateDetails() {
    setState(() {});
  }

  _UploadPhotoPageState() {
    userPRofileGet().then((value) {
      if (value != null) {
        this.accountEmail = value;
        updateDetails();
      }
    });

    getUserName().then((value) {
      if (value != null) {
        this.accountName = value;
        updateDetails();
      }
    });

    getUserId().then((value) {
      if (value != null) {
        this.accountId = value;
        updateDetails();
      }
    });
  }

  String accountEmail = "";
  String accountName = "";
  String accountId = "";

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

//remove Image Method
  clearPostInfo() {
    descriptionTextEditingController.clear();
    setState(() {
      sampleImage = null;
    });
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
          title: new Text("Upload Image"),
          centerTitle: true,
        ),
        body: new Center(
          child:
              sampleImage == null ? Text("Select and Image") : enableUpload(),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepOrangeAccent,
            child: Icon(Icons.add),
            onPressed: () {
              takeImage(context);
            }));

    // file == null ? takeImage(context) : displayUploadFormScreen(),
    //this on pressed when called takeImage will be called success but
    //after image taken it should be displayUploadFormScreen() called but its not working, check this small issue so i will also judge your expertise then we will discuss project details budget and document
    //add question here.
    // r u there?????

    //   body: new Center(
    //     child: sampleImage == null ? Text("Select and Image") : enableUpload(),
    //   ),
    //   floatingActionButton: new FloatingActionButton(
    //     onPressed: getImage,
    //     tooltip: 'Add Image',
    //     child: new Icon(Icons.add_a_photo),
    //   ),
    // );
  }

  //Compressing the photo
  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(sampleImage.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 90));
    setState(() {
      sampleImage = compressedImageFile;
    });
  }

// handle submit post

  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });

    await compressingPhoto();

    String downloadUrl = await uploadPhoto(sampleImage);

    savePostInfoToFirestore(
        url: downloadUrl, description: descriptionTextEditingController.text);

    descriptionTextEditingController.clear();

    setState(() {
      sampleImage = null;
      uploading = false;
      postId = Uuid().v4();
    });
  }

  //getting user email
  Future<String> userPRofileGet() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print('you are' + user.uid);
    print('your email' + user.email);

    //uuuser.get;
    //final String email = user.uid.toString();
    return user.email;
  }

  //get User Id
  Future<String> getUserId() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot ds =
        await Firestore.instance.collection('users').document(user.uid).get();
    print('my uid' + user.uid);
    print('my name' + ds.data['name']);
    print('my email' + user.email);

    return ds.data['uid'];
  }

//getting userName
  Future<String> getUserName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot ds =
        await Firestore.instance.collection('users').document(user.uid).get();
    print('my uid' + user.uid);
    print('my name' + ds.data['name']);
    print('my email' + user.email);

    return ds.data['name'];
  }

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // getCurrentUser() async {
  //   final FirebaseUser user = await _auth.currentUser();
  //   final uid = user.uid;
  //   // Similarly we can get email as well
  //   //final uemail = user.email;
  //   print(uid);
  //   //print(uemail);
  // }

  //String gettCurrentUser;
  // send to firestore
  savePostInfoToFirestore({String url, String description}) {
    postsReference
        .document(accountId)
        .collection('usersPosts')
        .document(postId)
        .setData({
      "postId": postId,
      "ownerId": accountId,
      "username": accountName,
      "mediaUrl": url,
      "email": accountEmail,
      "description": description,
      "timestamp": timestamp,
      "likes": {},
    });
  }

// method for uploadImage
  Future<String> uploadPhoto(mImageFile) async {
    StorageUploadTask mStorageUploadTask =
        storageReference.child("post_$postId.jpg").putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await mStorageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Widget enableUpload() {
    return new Container(
        child: new Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          uploading ? linearProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: FileImage(sampleImage),
                    fit: BoxFit.cover,
                  )),
                ),
              ),
            ),
          ),

          // Image.file(
          //   sampleImage,
          //   height: 25.0,
          //   width: 20.0,
          // ),
          SizedBox(
            height: 15.0,
          ),
          TextFormField(
            controller: descriptionTextEditingController,
            decoration: new InputDecoration(labelText: 'Description'),
            validator: (value) {
              return value.isEmpty ? 'Description is required' : null;
            },
            onSaved: (value) {
              return _myValue = value;
            },
          ),
          SizedBox(
            height: 15.0,
          ),
          RaisedButton(
            elevation: 10.0,
            child: Text("Add a New Post"),
            textColor: Colors.white,
            color: Colors.pink,
            onPressed:

                // { validateAndSave;
                uploading ? null : () => controlUploadAndSave(),
            // }
          )
        ],
      ),
    ));
  }

  // Needs integration takeImage method
  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Ask Your Question By: ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Text(
                "ASK Question                                (without Image)",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              //onPressed: (),
            ),
            SimpleDialogOption(
              child: Text(
                "ASK Question                                     (with Camera Image)",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: captureImageWithCamera,
            ),
            SimpleDialogOption(
              child: Text(
                "ASK Question                                     (with Gallery Image)",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: pickImageFromGallery,
            ),
            SimpleDialogOption(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  captureImageWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      sampleImage = imageFile;
    });
  }

// Needs integration pickImageFromGallery method
  void pickImageFromGallery() async {
    Navigator.pop(context);
    var imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      sampleImage = imageFile;
    });
  }
}