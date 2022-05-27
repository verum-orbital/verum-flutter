import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verum_flutter/models/user.dart' as model;
import 'package:verum_flutter/providers/user_provider.dart';
import 'package:verum_flutter/utils/colors.dart';
import 'package:verum_flutter/utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _page);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Center(
          child: PageView(
        children: homeScreenWidgets,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      )),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
              backgroundColor: _page == 0 ? primaryColor : secondaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
              backgroundColor: _page == 1 ? primaryColor : secondaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              label: '',
              backgroundColor: _page == 2 ? primaryColor : secondaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: '',
              backgroundColor: _page == 3 ? primaryColor : secondaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
              backgroundColor: _page == 4 ? primaryColor : secondaryColor),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
