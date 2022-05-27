import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Upload an image to firestore and returns its download URL
  Future<String> uploadImage(
      String folderName, Uint8List image, bool isUserPost) async {
    // Uploads the given image to /folderName/<currentUserUID>
    Reference ref =
        storage.ref().child(folderName).child(auth.currentUser!.uid);

    if (isUserPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask = ref.putData(image);

    TaskSnapshot snapshot = await uploadTask;

    print('Uploaded image to path: ' + ref.fullPath);

    return snapshot.ref.getDownloadURL();
  }
}
