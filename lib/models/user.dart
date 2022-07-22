import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:verum_flutter/utils/extensions.dart';

class User {
  final String email;
  final String username;
  final String bio;
  final String avatarURL;
  final DateTime postTime;
  final int numPostOpportunities;

  const User(
      {required this.email,
      required this.username,
      required this.bio,
      required this.avatarURL,
      required this.postTime,
      required this.numPostOpportunities});

  Map<String, dynamic> toJson() => {
        'username': username,
        'avatarURL': avatarURL,
        'email': email,
        'bio': bio,
        'postTime': postTime,
        'numPostOps': numPostOpportunities,
      };

  static User fromJson(Map<String, dynamic> data) {
    return User(
        email: data['email'],
        username: data['username'],
        bio: data['bio'],
        avatarURL: data['avatarURL'],
        postTime: (data['postTime'] as Timestamp).toDate(),
        numPostOpportunities: data['numPostOps']);
  }

  static User fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return User(
        email: data['email'],
        username: data['username'],
        bio: data['bio'],
        avatarURL: data['avatarURL'],
        postTime: (data['postTime'] as Timestamp).toDate(),
        numPostOpportunities: data['numPostOps']);
  }
}
