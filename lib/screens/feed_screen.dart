import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:verum_flutter/resources/firestore_methods.dart';
import 'package:verum_flutter/utils/colors.dart';
import 'package:verum_flutter/widgets/post_card.dart';

import '../models/post.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> _posts = List.empty();

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  void getPosts() async {
    Iterable<String> userFollows =
        await FirestoreMethods().fetchUserFollowing();

    List<Post> res = <Post>[];
    userFollows.forEach((uid) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(uid)
          .collection('userPosts')
          .get()
          .then((value) => value.docs.forEach((element) {
                print(element.data());
                res.add(Post.fromQuerySnapshot(element, uid));
                setState(() {
                  _posts = res;
                  print(_posts);
                });
              }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: const Text('Verum'),
      ),
      body: ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (context, index) => PostCard(post: _posts[index])),
    );
  }
}
