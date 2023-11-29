import 'package:flutter/material.dart';
import 'package:instagram/responsive/responsive_layout_screens.dart';
import 'package:instagram/screens/feed_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'responsive/mobile_screen_layout.dart';
import 'responsive/web_screen_layout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home:FeedScreen(),
      );
  }
}

