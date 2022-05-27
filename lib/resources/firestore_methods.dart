import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:verum_flutter/models/user.dart' as userModel;
import 'package:verum_flutter/models/post.dart' as model;
import 'package:verum_flutter/resources/storage_methods.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> createPost(
      {required String caption, required Uint8List image}) async {
    try {
      String mediaURL =
          await StorageMethods().uploadImage('userPosts', image, true);

      model.Post post = model.Post(
          uid: _auth.currentUser!.uid,
          caption: caption,
          creationDate: DateTime.now(),
          mediaURL: mediaURL);

      await _firestore
          .collection("posts")
          .doc(_auth.currentUser!.uid)
          .collection("userPosts")
          .add(post.toJson());

      return "success";
    } catch (err) {
      return err.toString();
    }
  }

  Future<userModel.User> fetchUser(String uid) {
    return _firestore.collection('users').doc(uid).get().then((value) {
      print(value.data());
      return userModel.User.fromJson(value.data()!);
    });
  }
}
