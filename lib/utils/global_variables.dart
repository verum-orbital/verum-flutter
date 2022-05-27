import 'package:flutter/material.dart';
import 'package:verum_flutter/models/user.dart';

const webScreenWidth = 600;
const placeholderAvatarImageURL =
    'https://www.kindpng.com/picc/m/207-2074624_white-gray-circle-avatar-png-transparent-png.png';
const placeholderUser = User(
    email: '', username: '', bio: '', avatarURL: placeholderAvatarImageURL);
const homeScreenWidgets = [
  Text('Feed'),
  Text('Search'),
  Text('Add Post'),
  Text('Notifications'),
  Text('Profile'),
];
