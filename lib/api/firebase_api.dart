import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:instagram/main.dart';

class FirebaseApi {
  final _firebaseMessaging =
      FirebaseMessaging.instance; //instance of firebase messaging

  //funtion to initialize notifi
  Future<void> initNotifications() async {
    //request permission from user
    await _firebaseMessaging.requestPermission();

    //fetech FCM token from the device
    final fCMToken = await _firebaseMessaging.getAPNSToken();

    print("Token $fCMToken");
  }

//function to handle receive message
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      'chat_messages.dart',
      arguments: message,
    );
  }

  //function to initialize background settings
  Future initPushNotifications() async {
    //handle notification if the app is terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    //attach event listener for when a notification opens in the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
