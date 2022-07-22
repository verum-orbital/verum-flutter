import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:verum_flutter/models/user.dart' as userModel;
import 'package:verum_flutter/providers/user_provider.dart';
import 'package:verum_flutter/resources/firestore_methods.dart';
import 'package:verum_flutter/utils/colors.dart';
import 'package:verum_flutter/utils/global_variables.dart';
import 'package:verum_flutter/models/user.dart' as model;
import 'package:verum_flutter/utils/utils.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import '../resources/auth_methods.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  Uint8List? _image;
  bool _isUploading = false;

  model.User userData = placeholderUser;

  bool _canPost = false;

  late Timer timer;
  @override
  void initState() {
    getData();
    timer = Timer.periodic(
        Duration(seconds: 1), (Timer t) => _updatePostRestrictionStatus());
    super.initState();
  }

  getData() async {
    final String? uid = FirebaseAuth.instance.currentUser!.uid;
    AuthMethods().getUserDetails(uid: uid).then((value) {
      setState(() {
        userData = value;
      });
    });
  }

  void _updatePostRestrictionStatus() {
    final DateTime now = DateTime.now();

    final DateTime userPostTime = userData.postTime;
    if (userPostTime != null) {
      setState(() {
        _canPost = now.compareTo(userPostTime) >= 0 &&
            now.subtract(const Duration(minutes: 15)).compareTo(userPostTime) <=
                0;
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy HH:mm').format(dateTime);
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  var image = await selectImage(ImageSource.camera);
                  setState(() {
                    _image = image;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Upload from Library'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  var image = await selectImage(ImageSource.gallery);
                  setState(() {
                    _image = image;
                    print('User selected Image');
                  });
                },
              ),
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop())
            ],
          );
        });
  }

  Future<void> uploadImage() async {
    if (_image != null) {
      setState(() {
        _isUploading = true;
      });

      await FirestoreMethods()
          .createPost(caption: _captionController.text, image: _image!);

      setState(() {
        _isUploading = false;
      });

      showSnackBar('Post uploaded successfully!', context);
      clearImage();
    } else {
      showSnackBar("Please select an image to upload", context);
    }
  }

  void clearImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  void dispose() {
    _captionController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _image == null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: const Text('Create Post'),
              centerTitle: false,
            ),
            body: Center(
              child: Column(
                children: [
                  Text(_canPost
                      ? "CAN POST UNITL"
                      : "NO POSTING \nLAST ALLOWED POST TIME:"),
                  Text(_formatDateTime(userData.postTime
                      .add(Duration(minutes: _canPost ? 15 : 0)))),
                  IconButton(
                    icon: Icon(Icons.upload,
                        color: _canPost ? Colors.white : Colors.grey),
                    onPressed: _canPost ? () => _selectImage(context) : () {},
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text('Create Post'),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: uploadImage,
                    child: const Text('Post',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)))
              ],
            ),
            body: Column(
              children: [
                _isUploading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0)),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(userData.avatarURL),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _captionController,
                        decoration: const InputDecoration(
                            hintText: 'Caption...', border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(_image!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
