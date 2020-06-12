import 'package:cloud_firestore/cloud_firestore.dart';

//THis class is not used

class User {
  final String id;
  final String name;
  final String url;
  final String email;
  final String password;
  final int catogery;

  User({
    this.id,
    this.name,
    this.url,
    this.email,
    this.password,
    this.catogery,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        id: doc.documentID,
        name: doc['name'],
        email: doc['email'],
        password: doc['password'],
        url: doc['url'],
        catogery: doc['catogery']);
  }
}
