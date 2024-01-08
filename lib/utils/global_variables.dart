import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/Notifications.dart';
import 'package:instagram/screens/Profile_screen.dart';
import 'package:instagram/screens/add_post_screen.dart';
import 'package:instagram/screens/feed_screen.dart';
import 'package:instagram/screens/search.dart';

import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Notifications(),
  Profile(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
  const LoginScreen()
];
