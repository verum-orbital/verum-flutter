import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:verum_flutter/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _image;

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
        : SizedBox(
            child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: MemoryImage(_image!),
                    fit: BoxFit.fitWidth,
                    alignment: FractionalOffset.topCenter)),
          ));
  }
}
