import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/notifications_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/models/notificationType.dart';
import 'package:instagram/models/notifications.dart' as model;
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../models/user.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class NotificationItem {
  final String username;
  final String action;
  final String postText;

  NotificationItem(
      {required this.username, required this.action, required this.postText});
}

class _NotificationsState extends State<Notifications> {

  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: mobileBackgroundColor,
      ),
      body: FutureBuilder<List<model.Notifications>>(
        future: NotificationsMethods.GetNotifications(context.read<UserProvider>().getUser.uid), // Your asynchronous function call
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while waiting for the Future
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display an error message if the Future fails
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Display the data using ListView.builder once the Future completes
            var data = snapshot.data!;
            return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          model.Notifications not = data[index];
          print(not.id);
          NotificationItem notification = NotificationItem(username: not.sender.username, action: not.type.description, postText: not.post.description);
          return Dismissible(
            key: Key(notification.username + index.toString()),
            onDismissed: (direction) async {
              // Remove the item from the data source
              final removedNotification = data.removeAt(index);
              await NotificationsMethods.deleteNotification(not);
              // Show a snackbar to indicate the item is dismissed
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Notification dismissed'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () async {
                      // Restore the removed notification
                      await model.Notifications.sendNotification(senderID: "Ge74dteyqZN1qFWyUeO8MW3KBiz1", receiverID: "UUnNUkznPCcNmMFLbH71v2uptpG2", postID: "99e08680-fd7a-1e08-82f4-37c53fe15271", typeID: "5ds9o3g3tG4x81i44rs7");

                      setState(() {
                        data.insert(index, removedNotification);
                      });
                    },
                  ),
                ),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.person),
              ),
              title: Text(
                notification.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: buildNotificationSubtitle(notification),
              onTap: () {
                // Handle notification tap
              },
            ),
          );
        },
      );
          }
        }, // FutureBuilder ends here
      ), //
    );
  }

  Widget buildNotificationSubtitle(NotificationItem notification) {
    String actionText = notification.action;
    if (notification.action == 'liked' || notification.action == 'commented') {
      actionText += ' your post: "${notification.postText}"';
    }
    return Text(actionText);
  }
}
