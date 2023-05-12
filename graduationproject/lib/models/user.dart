import 'package:cloud_firestore/cloud_firestore.dart';

class UserInformation {
  final String id;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;

  UserInformation({
    this.id,
    this.username,
    this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
  });

  factory UserInformation.fromDocument(DocumentSnapshot doc) {
    return UserInformation(
      id: doc['id'],
      email: doc.data()['email'],
      username: doc.data()['username'],
      photoUrl: doc.data()['photoUrl'],
      displayName: doc.data()['displayName'],
      bio: doc.data()['bio'],
    );
  }

}
