import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/responsive/responsive_layout_screens.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'responsive/mobile_screen_layout.dart';
import 'responsive/web_screen_layout.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCTNFGUcZYIRFbRM26VP799afZ68SX_puA",
        appId: "1:257455787498:web:023a6b0f1a8d7f24f2f693",
        messagingSenderId: "257455787498",
        projectId: "instagram-project-871da",
        storageBucket: 'instagram-project-871da.appspot.com'
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: ResponsiveLayout(
        mobileScreenLayout: MobileScreenLayout(),
        webScreenLayout: WebScreenLayout(),
      ),

      // home: SignupScreen(),
      //home: LoginScreen(),
    );
  }
}
