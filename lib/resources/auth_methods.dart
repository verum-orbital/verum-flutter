import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:verum_flutter/models/user.dart' as model;
import 'package:verum_flutter/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<model.User> getUserDetails({String? uid}) async {
    final uidToFetch = uid ?? _auth.currentUser!.uid;

    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(uidToFetch).get();

    return model.User.fromSnapshot(snapshot);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? file,
  }) async {
    print("SINGNING UP");
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty &&
          file != null) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String userAvatarDownloadURL =
            await StorageMethods().uploadImage('userAvatars', file, false);

        // adding user in our database
        model.User user = model.User(
            username: username,
            email: email,
            avatarURL: userAvatarDownloadURL,
            bio: bio,
            postTime: DateTime.now(),
            numPostOpportunities: 0);

        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";
        print('successfully registered user: ${cred.user?.uid}');
      } else {
        res = file == null
            ? "Please add a profile picture"
            : "Please enter all the fields";
      }
    } on FirebaseAuthException catch (err) {
      switch (err.code) {
        case 'invalid-email':
          return 'The email is badly formatted';
        case 'weak-password':
          return 'The password should be at least 6 characters';
        default:
          return err.toString();
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return "success";
      } else {
        return "Please enter all the fields";
      }
    } on FirebaseAuthException catch (err) {
      switch (err.code) {
        case 'invalid-email':
          return 'The email is badly formatted';
        case 'user-not-found':
          return 'There is no user corresponding to this identifier.';
        case 'wrong-password':
          return 'The password is invalid or the user does not have a password';
        default:
          return err.toString();
      }
    } catch (err) {
      return err.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
