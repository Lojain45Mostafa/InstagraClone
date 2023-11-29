import 'package:flutter/material.dart';
import 'package:instagram/screens/add_post_screen.dart';
import 'package:instagram/screens/feed_screen.dart';


const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const AddPostScreen(),
  const Text('notifications'),
];