import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String username;
  final String bio;
  final String avatarURL;

  const User(
      {required this.email,
      required this.username,
      required this.bio,
      required this.avatarURL});

  Map<String, dynamic> toJson() => {
        'username': username,
        'avatarURL': avatarURL,
        'email': email,
        'bio': bio,
      };

  static User fromJson(Map<String, dynamic> data) {
    return User(
        email: data['email'],
        username: data['username'],
        bio: data['bio'],
        avatarURL: data['avatarURL']);
  }

  static User fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return User(
        email: data['email'],
        username: data['username'],
        bio: data['bio'],
        avatarURL: data['avatarURL']);
  }
}
