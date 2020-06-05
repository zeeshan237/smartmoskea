import 'package:flutter/material.dart';

//Needs Integration display Screent to get description Question
displayUploadFormScreen() {
  print("displayUploadFormScreen Called success");
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      // leading: IconButton(
      //     icon: Icon(
      //       Icons.arrow_back,
      //       color: Colors.white,
      //     ),
      //     onPressed: //removeImage),
      title: Text(
        "New Post",
        style: TextStyle(
            fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => print("tapped"),
          child: Text(
            "Share",
            style: TextStyle(
                color: Colors.lightGreenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
          ),
        ),
      ],
    ),
    body: ListView(
      children: <Widget>[
        Container(
          height: 230.0,
          //  width: MediaQuery.of(context).size.width * 0.8,
          child: Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              // child: Container(
              //   decoration: BoxDecoration(
              //       image: DecorationImage(
              //    // image: FileImage(file),
              //     fit: BoxFit.cover,
              //   )),
              // ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
        ),
        ListTile(
          // leading: CircleAvatar(
          //   backgroundImage:
          //       CachedNetworkImageProvider(widget.gCurrentUser.url),
          // ),
          title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.black),
                //   controller: descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: "Say Something About Image.",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
              )),
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.person_pin_circle,
            color: Colors.white,
            size: 36.0,
          ),
          title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.white),
                //  controller: locationTextEditingController,
                decoration: InputDecoration(
                  hintText: "Write the location here",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
              )),
        ),
        Container(
          width: 220.0,
          height: 110,
          alignment: Alignment.center,
          //     child: RaisedButton.icon(
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(35.0)),
          //       color: Colors.green,
          //       icon: Icon(
          //         Icons.location_on,
          //         color: Colors.white,
          //       ),
          //       label: Text(
          //         "Get my Current Location",
          //         style: TextStyle(color: Colors.white),
          //       ),
          //  //     onPressed: getUserCurrentLocation,
          //     )
        )
      ],
    ),
  );
}
