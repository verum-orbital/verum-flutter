import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
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
      String postId = const Uuid().v1();

      model.Post post = model.Post(
        uid: _auth.currentUser!.uid,
        caption: caption,
        creationDate: DateTime.now(),
        mediaURL: mediaURL,
        postId: postId,
        likes: [],
      );

      await _firestore
          .collection("posts")
          .doc(_auth.currentUser!.uid)
          .collection("userPosts")
          .doc(postId)
          .set(post.toJson());

      return "success";
    } catch (err) {
      return err.toString();
    }
  }

  Future<void> updateUserFCMToken(String? token) async {
    if (token == null) {
      return;
    }

    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    _firestore
        .collection('users')
        .doc(uid)
        .update({'fcmToken': token}).then((_) {
      print("Updated user of id $uid with fcm token $token");
    });
  }

  Future<userModel.User> fetchUser(String uid) {
    return _firestore.collection('users').doc(uid).get().then((value) {
      print(value.data());
      return userModel.User.fromJson(value.data()!);
    });
  }

  Future<Iterable<String>> fetchUserFollowing({String? uid}) {
    final uidToFetch = uid ?? _auth.currentUser!.uid;
    // gets the ids of all users that the current user is following
    return _firestore
        .collection("users")
        .doc(uidToFetch)
        .collection("following")
        .get()
        .then((value) => value.docs.map((e) => e.id));
  }

  Future<Iterable<String>> fetchUserFollowers({String? uid}) {
    final uidToFetch = uid ?? _auth.currentUser!.uid;
    // gets the ids of all users that the current user is following
    return _firestore
        .collection("users")
        .doc(uidToFetch)
        .collection("followers")
        .get()
        .then((value) => value.docs.map((e) => e.id));
  }

  Future<void> followUser(uid) async {
    // update current user's following collection
    _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("following")
        .doc(uid)
        .set({});

    // update followed user's follows collection
    _firestore
        .collection("users")
        .doc(uid)
        .collection("followers")
        .doc(_auth.currentUser!.uid)
        .set({});
  }

  Future<void> unfollowUser(uid) async {
    // update current user's following collection
    _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("following")
        .doc(uid)
        .delete();

    // update followed user's follows collection
    _firestore
        .collection("users")
        .doc(uid)
        .collection("followers")
        .doc(_auth.currentUser!.uid)
        .delete();
  }

  Future<Iterable<String>> fetchAllUsers() {
    // gets the ids of all users that the current user is following
    return _firestore
        .collection("users")
        .get()
        .then((value) => value.docs.map((e) => e.id));
  }

  Future<void> likePost(
      String postId, String uid, List likes, String username) async {
    try {
      if (likes.contains(username)) {
        print('Like present');
        await _firestore
            .collection("posts")
            .doc(uid)
            .collection("userPosts")
            .doc(postId)
            .update({
          'likes': FieldValue.arrayRemove([username]),
        });
      } else {
        print('Just liked the picture');
        await _firestore
            .collection("posts")
            .doc(uid)
            .collection("userPosts")
            .doc(postId)
            .update({
          'likes': FieldValue.arrayUnion([username]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
