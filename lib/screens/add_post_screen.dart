import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:verum_flutter/utils/utils.dart';

import '../utils/colors.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  Uint8List? _image;
  bool _isUploading = false;

  void clearImage() {
    setState(() {
      _image = null;
    });
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

  @override
  Widget build(BuildContext context) {
    return _image == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
                backgroundColor: mobileBackgroundColor,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back), onPressed: clearImage),
                title: const Text('Create Post'),
                centerTitle: false,
                actions: [
                  TextButton(
                      onPressed: () {},
                      child: const Text('Post',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)))
                ]),
            body: Column(
              children: [
                _isUploading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0)),
                const Divider(),
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
                TextField(
                  controller: _captionController,
                  decoration: const InputDecoration(
                      hintText: 'Caption...', border: InputBorder.none),
                  maxLines: 8,
                ),
              ],
            ));
  }
}
