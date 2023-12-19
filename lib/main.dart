import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/responsive/responsive_layout_screens.dart';
import 'package:instagram/screens/chatTest_page.dart';
import 'package:instagram/screens/chat_messages.dart';
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

  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCTNFGUcZYIRFbRM26VP799afZ68SX_puA",
          appId: "1:257455787498:web:023a6b0f1a8d7f24f2f693",
          messagingSenderId: "257455787498",
          projectId: "instagram-project-871da",
          storageBucket: 'instagram-project-871da.appspot.com'),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //as our app gets bigger it's gonna use multiple providers so just wrap it with MultiProvider and it's gonna be a one time setup for us
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),

        // home: ResponsiveLayout(
        //   mobileScreenLayout: MobileScreenLayout(),
        //   webScreenLayout: WebScreenLayout(),
        // ),

        // home: SignupScreen(),
        home: LoginScreen(),
        // home: ChatMessages(),
        // home: const ChatTestPage(
        //   receiverUserEmail: 'lojain22@gmail.com',
        //   receiverUserID: 'Ge74dteyqZN1qFWyUeO8MW3KBiz1',
        // ),
      ),
    );
  }
}
