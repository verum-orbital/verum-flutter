import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:verum_flutter/models/user.dart' as model;
import 'package:verum_flutter/screens/add_post_screen.dart';
import 'package:verum_flutter/screens/feed_screen.dart';
import 'package:verum_flutter/screens/profile_screen.dart';
import 'package:verum_flutter/screens/search_screen.dart';

const webScreenWidth = 600;
const placeholderAvatarImageURL =
    'https://www.kindpng.com/picc/m/207-2074624_white-gray-circle-avatar-png-transparent-png.png';
final placeholderUser = model.User(
    email: '',
    username: '',
    bio: '',
    avatarURL: placeholderAvatarImageURL,
    postTime: DateTime.now(),
    numPostOpportunities: 0);

const double userScoreMultiplier = 0.6;

final homeScreenWidgets = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('Notifications'),
  ProfileScreen(uid: null),
];
