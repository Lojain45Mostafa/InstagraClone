import 'package:firebase_messaging/firebase_messaging.dart';

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
}
