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
import 'package:verum_flutter/screens/comments_screen.dart';
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
  userModel.User _user = userModel.User(
      email: '', username: '', bio: '', avatarURL: placeholderAvatarImageURL);

  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    var user = await FirestoreMethods().fetchUser(widget.post.uid);
    print(user);
    setState(() {
      _user = user;
    });
  }

  // int countLikes(List<String> uid) {
  //   if (uid != null) {
  //     return uid.length;
  //   }
  //   return 0;
  // }

  @override
  Widget build(BuildContext context) {
    // final User scrollingUser = Provider.of<UserProvider>(context).getUser;
    final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
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
            onDoubleTap: () async {
              await FirestoreMethods()
                  .likePost(widget.post.uid, currentUserUid, widget.post.likes);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.post.mediaURL,
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
                isAnimating: widget.post.likes.contains(currentUserUid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                        widget.post.uid, currentUserUid, widget.post.likes);
                  },
                  icon: widget.post.likes.contains(currentUserUid)
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
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(post: widget.post),
                  ),
                ),
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
                    // ${widget.post.likes.length}
                    '${widget.post.likes.length} likes',
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
                          TextSpan(text: widget.post.caption)
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all comments...',
                      style:
                          const TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    widget.post.creationDate.toString(),
                    style: const TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                )
              ],
            ),
          ),
        ]));
  }
}
