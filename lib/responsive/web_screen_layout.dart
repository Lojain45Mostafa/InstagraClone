import 'package:flutter/material.dart';
import 'package:instagram/models/notificationType.dart';
import 'package:instagram/models/notifications.dart';

import '../models/post.dart';
import '../models/user.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: IconButton(onPressed:() async {
       Notifications.sendNotification(senderID: "Ge74dteyqZN1qFWyUeO8MW3KBiz1", receiverID: "UUnNUkznPCcNmMFLbH71v2uptpG2", postID: "99e08680-fd7a-1e08-82f4-37c53fe15271", typeID: "5ds9o3g3tG4x81i44rs7");
      }, icon: Icon(Icons.abc))
    );
  }
}