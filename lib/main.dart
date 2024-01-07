import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/api/firebase_api.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/responsive/responsive_layout_screens.dart';
import 'package:instagram/screens/add_post_screen.dart';
import 'package:instagram/screens/chat_messages.dart';
import 'package:instagram/screens/feed_screen.dart';
// import 'package:instagram/screens/fingerPrint.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';
import 'responsive/mobile_screen_layout.dart';
import 'responsive/web_screen_layout.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
//   // Ensure that plugin services are initialized so that `availableCameras()`
//   WidgetsFlutterBinding.ensureInitialized();

// // Obtain a list of the available cameras on the device.
//   final cameras = await availableCameras();

// // Get a specific camera from the list of available cameras.
//   final firstCamera = cameras.first;
//   WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  // initialise app based on platform- web or mobile
  // if (kIsWeb) {
  //   await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: 'AIzaSyCq7Sk-bFCy_v0s1G778NptPt2mnp44ak8',
  //   appId: '1:257455787498:android:48cd7a3b42eda970f2f693',
  //   messagingSenderId: '257455787498',
  //   projectId: 'instagram-project-871da',
  //   storageBucket: 'instagram-project-871da.appspot.com',)
  //   );
  // } else {
  //   await Firebase.initializeApp();
  // }
  runApp(MultiProvider(
      //as our app gets bigger it's gonna use multiple providers so just wrap it with MultiProvider and it's gonna be a one time setup for us
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget home = const ResponsiveLayout(
      mobileScreenLayout: MobileScreenLayout(),
      webScreenLayout: WebScreenLayout(),
    );
    if (context.read<UserProvider>().isLogin() == false) {
      home = LoginScreen();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),

      home: home,
      // home: ResponsiveLayout(
      //   mobileScreenLayout: MobileScreenLayout(),
      //   webScreenLayout: WebScreenLayout(),
      // ),

      // home: SignupScreen(),
      // home: LoginScreen(),
      // home: ChatMessages(),
      // home: const ChatTestPage(
      //   receiverUserEmail: 'lojain22@gmail.com',
      //   receiverUserID: 'Ge74dteyqZN1qFWyUeO8MW3KBiz1',
      // home: FeedScreen(),
      // home: AddPostScreen(),
      // home: FingerPrint(),
      // ),
    );
  }
}
