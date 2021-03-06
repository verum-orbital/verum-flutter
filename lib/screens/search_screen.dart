import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:verum_flutter/screens/profile_screen.dart';
import 'package:verum_flutter/utils/colors.dart';
import 'package:verum_flutter/utils/global_variables.dart';

import '../models/user.dart';
import '../resources/firestore_methods.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  List<String> _userFollows = List.empty();

  @override
  void initState() {
    super.initState();
    _getFollows();
  }

  void _getFollows() async {
    Iterable<String> userFollows =
        await FirestoreMethods().fetchUserFollowing();
    List<String> res = [];
    res.addAll(userFollows);
    setState(() {
      _userFollows = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration:
                const InputDecoration(labelText: 'Search for a user...'),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
            },
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final snapshotData = snapshot.data! as QuerySnapshot;

                return ListView.builder(
                  itemCount: snapshotData.docs.length,
                  itemBuilder: (context, index) {
                    final uid = snapshotData.docs[index].id;
                    final doc =
                        snapshotData.docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => ProfileScreen(uid: uid))),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          doc.containsKey('avatarURL') ? doc['avatarURL'] : '',
                        ),
                        radius: 16,
                      ),
                      title: Text(
                        doc.containsKey('username') ? doc['username'] : '',
                      ),
                    );
                    // InkWell(
                    //   onTap: () => Navigator.of(context).push(
                    //     MaterialPageRoute(
                    //       builder: (context) => ProfileScreen(
                    //         uid: (snapshot.data! as dynamic).docs[index]['uid'],
                    //       ),
                    //     ),
                    //   ),
                    //   child: ListTile(
                    //     leading: CircleAvatar(
                    //       backgroundImage: NetworkImage(
                    //         (snapshot.data! as dynamic).docs[index]
                    //             ['avatarURL'],
                    //       ),
                    //       radius: 16,
                    //     ),
                    //     title: Text(
                    //       (snapshot.data! as dynamic).docs[index]['username'],
                    //     ),
                    //   ),
                    // );
                  },
                );
              },
            )
          : FutureBuilder(
              future:
                  FirebaseFirestore.instance.collectionGroup('userPosts').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => Image.network(
                    (snapshot.data! as dynamic).docs[index]['mediaURL'],
                    fit: BoxFit.cover,
                  ),
                  staggeredTileBuilder: (index) => MediaQuery.of(context)
                              .size
                              .width >
                          webScreenWidth
                      ? StaggeredTile.count(
                          (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                      : StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              },
            ),
    );
  }
}
