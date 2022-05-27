import 'package:flutter/material.dart';
import 'package:verum_flutter/models/user.dart';
import 'package:verum_flutter/screens/add_post_screen.dart';
import 'package:verum_flutter/screens/feed_screen.dart';
import 'package:verum_flutter/screens/profile_screen.dart';

const webScreenWidth = 600;
const placeholderAvatarImageURL =
    'https://www.kindpng.com/picc/m/207-2074624_white-gray-circle-avatar-png-transparent-png.png';
const placeholderUser = User(
    email: '', username: '', bio: '', avatarURL: placeholderAvatarImageURL);
const homeScreenWidgets = [
  FeedScreen(),
  Text('Search'),
  AddPostScreen(),
  Text('Notifications'),
  ProfileScreen(),
];
