import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:verum_flutter/models/post.dart';
import 'package:verum_flutter/resources/firestore_methods.dart';
import 'package:verum_flutter/utils/colors.dart';
import 'package:verum_flutter/utils/global_variables.dart';

import '../models/user.dart' as userModel;

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  userModel.User _user = userModel.User(
      email: '',
      username: 'Testing',
      bio: '',
      avatarURL: placeholderAvatarImageURL);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: mobileBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(children: [
          //IMAGE
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              widget.post.mediaURL,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 8),
            child: RichText(
              text: TextSpan(
                  style: const TextStyle(color: primaryColor),
                  children: [
                    TextSpan(
                        text: '${_user.username} ',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: widget.post.caption)
                  ]),
            ),
          ),
        ]));
  }
}
