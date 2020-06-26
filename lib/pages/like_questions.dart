import "package:flutter/material.dart";


// ignore: camel_case_types
class like_questions extends StatefulWidget {
 @override
_like_questionsState createState
  () => _like_questionsState();
}

// ignore: camel_case_types
class _like_questionsState extends State<like_questions> {
  @override
  Widget build(BuildContext context) {
    return  new Container(
        constraints: BoxConstraints(
        maxWidth: 1000.0
        ),
        padding: EdgeInsets.only(left: 10.0,top: 10.0),
        child:
            new ListView(
              children: <Widget>[
                new ListTile(
                  leading: new CircleAvatar(
                    backgroundImage: new NetworkImage("http://i.pravatar.cc/300"),
                  ),
                  title: new RichText(
                    text: new TextSpan(
                      style:new TextStyle(
                         color: Colors.black,
                         fontSize: 14.0,
                      ),
                      children: <TextSpan>[
                        new TextSpan(text:"Muhammad Ahmad ", style: new TextStyle(fontWeight: FontWeight.bold,)),
                        new TextSpan(text: "Likes your question 'What is the difference.... '")
                      ]
                    ),
                  ),
                  subtitle: new Text("2 minutes ago"),
                ),
                new Divider(),
                new ListTile(
                  leading: new CircleAvatar(
                    backgroundImage: new NetworkImage("http://i.pravatar.cc/300"),
                  ),
                  title: new RichText(
                    text: new TextSpan(
                      style:new TextStyle(
                         color: Colors.black,
                         fontSize: 14.0,
                      ),
                      children: <TextSpan>[
                        new TextSpan(text:"Muhammad Ahmad ", style: new TextStyle(fontWeight: FontWeight.bold,)),
                        new TextSpan(text: "Likes your question 'What is the difference.... '")
                      ]
                    ),
                  ),
                  subtitle: new Text("2 minutes ago"),
                ),
                new Divider(),
                new ListTile(
                  leading: new CircleAvatar(
                    backgroundImage: new NetworkImage("http://i.pravatar.cc/300"),
                  ),
                  title: new RichText(
                    text: new TextSpan(
                      style:new TextStyle(
                         color: Colors.black,
                         fontSize: 14.0,
                      ),
                      children: <TextSpan>[
                        new TextSpan(text:"Muhammad Ahmad ", style: new TextStyle(fontWeight: FontWeight.bold,)),
                        new TextSpan(text: "Likes your question 'What is the difference.... '")
                      ]
                    ),
                  ),
                  subtitle: new Text("2 minutes ago"),
                ),
                new Divider(),
                new ListTile(
                  leading: new CircleAvatar(
                    backgroundImage: new NetworkImage("http://i.pravatar.cc/300"),
                  ),
                  title: new RichText(
                    text: new TextSpan(
                      style:new TextStyle(
                         color: Colors.black,
                         fontSize: 14.0,
                      ),
                      children: <TextSpan>[
                        new TextSpan(text:"Muhammad Ahmad ", style: new TextStyle(fontWeight: FontWeight.bold,)),
                        new TextSpan(text: "Likes your question 'What is the difference.... '")
                      ]
                    ),
                  ),
                  subtitle: new Text("2 minutes ago"),
                ),
                new Divider(),
                new ListTile(
                  leading: new CircleAvatar(
                    backgroundImage: new NetworkImage("http://i.pravatar.cc/300"),
                  ),
                  title: new RichText(
                    text: new TextSpan(
                      style:new TextStyle(
                         color: Colors.black,
                         fontSize: 14.0,
                      ),
                      children: <TextSpan>[
                        new TextSpan(text:"Muhammad Ahmad ", style: new TextStyle(fontWeight: FontWeight.bold,)),
                        new TextSpan(text: "Likes your question 'What is the difference.... '")
                      ]
                    ),
                  ),
                  subtitle: new Text("2 minutes ago"),
                ),
                new Divider(),
                new ListTile(
                  leading: new CircleAvatar(
                    backgroundImage: new NetworkImage("http://i.pravatar.cc/300"),
                  ),
                  title: new RichText(
                    text: new TextSpan(
                      style:new TextStyle(
                         color: Colors.black,
                         fontSize: 14.0,
                      ),
                      children: <TextSpan>[
                        new TextSpan(text:"Muhammad Ahmad ", style: new TextStyle(fontWeight: FontWeight.bold,)),
                        new TextSpan(text: "Likes your question 'What is the difference.... '")
                      ]
                    ),
                  ),
                  subtitle: new Text("2 minutes ago"),
                ),
                new Divider(),
                
              ],
            )
      );
  }
}