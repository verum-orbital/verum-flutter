import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:verum_flutter/models/post.dart';
import 'package:verum_flutter/models/user.dart';
import 'package:verum_flutter/providers/user_provider.dart';
import 'package:verum_flutter/resources/firestore_methods.dart';
import 'package:verum_flutter/utils/colors.dart';
import 'package:verum_flutter/utils/global_variables.dart';
import 'package:verum_flutter/widgets/like_animation.dart';

import '../models/user.dart' as userModel;

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late Post post = widget.post;

  userModel.User _user = userModel.User(
      email: '',
      username: '',
      bio: '',
      avatarURL: placeholderAvatarImageURL,
      postTime: DateTime.now(),
      numPostOpportunities: 0);

  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> refreshPost() async {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(post.uid)
        .collection('userPosts')
        .doc(post.postId)
        .get()
        .then((value) {
      print("GOT POST");
      setState(() {
        post = Post.fromSnapshot(value);
      });
    });
  }

  bool checkUserLikes(dynamic likes) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || likes == null) {
      // Error handling
      return false;
    }
    return likes.contains(uid);
  }

  void likePost() async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      // Error handling
      return;
    }
    await FirestoreMethods()
        .likePost(post.postId, post.uid, post.likes, uid)
        .then((_) => refreshPost());

    setState(() {
      isLikeAnimating = true;
    });
  }

  void getUser() async {
    var user = await FirestoreMethods().fetchUser(post.uid);
    print(user);
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userModel.User scrollingUser =
        Provider.of<UserProvider>(context).getUser;
    return Container(
        color: mobileBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(children: [
          // HEADER
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(_user.avatarURL),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _user.username,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              child: ListView(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: ['Delete']
                                    .map((content) => InkWell(
                                          onTap: () {},
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Text(content),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ));
                  },
                  icon: const Icon(Icons.more_vert),
                )
              ],
            ),
          ),

          //IMAGE
          GestureDetector(
            onDoubleTap: likePost,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    post.mediaURL,
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: (() {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    }),
                  ),
                )
              ],
            ),
          ),
          // LIKE, COMMENT SECTION
          Row(
            children: [
              LikeAnimation(
                isAnimating: checkUserLikes(post.likes),
                smallLike: true,
                child: IconButton(
                  onPressed: likePost,
                  icon: checkUserLikes(post.likes)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.comment_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),

          // CAPTION and COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    // ${post.likes.length}
                    '${post.likes.length} likes',
                    style: Theme.of(context).textTheme.bodyText2,
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: post.caption)
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: const Text(
                      'View all comments...',
                      style:
                          const TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    post.creationDate.toString(),
                    style: const TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                )
              ],
            ),
          ),
        ]));
  }
}
