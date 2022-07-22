import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:verum_flutter/models/user.dart' as model;
import 'package:verum_flutter/resources/auth_methods.dart';
import 'package:verum_flutter/screens/login_screen.dart';
import 'package:verum_flutter/utils/colors.dart';
import 'package:verum_flutter/utils/utils.dart';

import '../resources/firestore_methods.dart';
import '../utils/global_variables.dart';
import '../widgets/follow_button.dart';
import '../widgets/user_score_indicator.dart';

class ProfileScreen extends StatefulWidget {
  final String? uid;
  const ProfileScreen({Key? key, this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void signOutUser() async {
    await AuthMethods().signOut().then((value) => Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen())));
  }

  late String uid;
  late Future<QuerySnapshot> userPostsSnapshot;
  model.User? userData;
  int postLen = 0;
  int numFollowers = 0;
  int numFollowing = 0;
  bool isFollowing = false;
  bool isLoading = false;
  double userScore = 0;

  @override
  void initState() {
    super.initState();
    print('INITED WITH UID: ${widget.uid}');
    setState(() {
      uid = widget.uid ?? FirebaseAuth.instance.currentUser!.uid;
    });
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final followers = (await FirestoreMethods().fetchUserFollowers(uid: uid));
      final following = (await FirestoreMethods().fetchUserFollowing(uid: uid));

      AuthMethods().getUserDetails(uid: uid).then((value) {
        setState(() {
          userData = value;

          // get post lENGTH
          userPostsSnapshot = FirebaseFirestore.instance
              .collection('posts')
              .doc(uid)
              .collection('userPosts')
              .get();

          userPostsSnapshot.then((value) => setState(() {
                postLen = value.docs.length;
                userScore = min(
                        1,
                        postLen /
                            ((userData?.numPostOpportunities ?? 1) *
                                userScoreMultiplier)) *
                    100;
              }));

          numFollowers = followers.length;
          numFollowing = following.length;

          isFollowing = following.contains(uid);
        });
      });

      setState(() {});
    } catch (e) {
      showSnackBar(
        e.toString(),
        context,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('widget: ${widget.uid}');
    print(FirebaseAuth.instance.currentUser?.uid);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userData?.username ?? '',
              ),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                  userData?.avatarURL ??
                                      placeholderAvatarImageURL,
                                ),
                                radius: 40,
                              ),
                              UserScoreIndicator(score: userScore),
                            ],
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, "posts"),
                                    buildStatColumn(numFollowers, "followers"),
                                    buildStatColumn(numFollowing, "following"),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            uid
                                        ? Center(
                                            child: InkWell(
                                              onTap: signOutUser,
                                              child: Container(
                                                child: const Text(
                                                  "Sign Out",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                width: 250,
                                                height: 40,
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                decoration: const ShapeDecoration(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4))),
                                                    color: blueColor),
                                              ),
                                            ),
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                text: 'Unfollow',
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                borderColor: Colors.grey,
                                                function: () async {
                                                  await FirestoreMethods()
                                                      .unfollowUser(uid);

                                                  setState(() {
                                                    isFollowing = false;
                                                    numFollowers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                text: 'Follow',
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                borderColor: Colors.blue,
                                                function: () async {
                                                  await FirestoreMethods()
                                                      .followUser(uid);

                                                  setState(() {
                                                    isFollowing = true;
                                                    numFollowers++;
                                                  });
                                                },
                                              )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          userData?.username ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userData?.bio ?? '',
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: userPostsSnapshot,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return StaggeredGridView.countBuilder(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      // TODO: We may want to load a grey placeholder image if null
                      itemBuilder: (context, index) => Image.network(
                        (snapshot.data! as dynamic).docs[index]['mediaURL'],
                        fit: BoxFit.cover,
                      ),
                      staggeredTileBuilder: (index) =>
                          MediaQuery.of(context).size.width > webScreenWidth
                              ? StaggeredTile.count((index % 7 == 0) ? 1 : 1,
                                  (index % 7 == 0) ? 1 : 1)
                              : StaggeredTile.count((index % 7 == 0) ? 2 : 1,
                                  (index % 7 == 0) ? 2 : 1),
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    );
                  },
                )
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
