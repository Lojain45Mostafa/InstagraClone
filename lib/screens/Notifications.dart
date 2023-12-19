import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';

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
  final List<NotificationItem> notifications = [
    NotificationItem(
        username: 'UserA', action: 'liked', postText: 'Awesome photo!'),
    NotificationItem(
        username: 'UserB', action: 'commented', postText: 'Great shot!'),
    NotificationItem(
        username: 'UserC',
        action: 'followed',
        postText: 'Started following you'),
    NotificationItem(
        username: 'UserD',
        action: 'requested to follow',
        postText: 'Wants to follow you'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: mobileBackgroundColor,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          NotificationItem notification = notifications[index];
          return Dismissible(
            key: Key(notification.username + index.toString()),
            onDismissed: (direction) {
              // Remove the item from the data source
              final removedNotification = notifications.removeAt(index);

              // Show a snackbar to indicate the item is dismissed
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Notification dismissed'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      // Restore the removed notification
                      setState(() {
                        notifications.insert(index, removedNotification);
                      });
                    },
                  ),
                ),
              );

              // You also need to remove the Dismissible widget from the tree
              // to resolve the warning
              setState(() {});
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.person),
              ),
              title: Text(
                notification.username,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: buildNotificationSubtitle(notification),
              onTap: () {
                // Handle notification tap
              },
            ),
          );
        },
      ),
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
