import 'package:flutter/material.dart';
import 'package:instagram/screens/Notifications.dart';
import 'package:instagram/screens/Profile_screen.dart';
import 'package:instagram/screens/add_post_screen.dart';
import 'package:instagram/screens/feed_screen.dart';
import 'package:instagram/screens/search.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const Search(),
  const AddPostScreen(),
  const Notifications(),
  const Profile()
];
