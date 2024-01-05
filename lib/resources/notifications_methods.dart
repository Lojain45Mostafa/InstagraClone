import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/notifications.dart';

class NotificationsMethods {
  static Future<List<Notifications>> GetNotifications(String userID) async {
    List<Notifications> notifications = [];

    var noti = await FirebaseFirestore.instance
        .collection("notifications")
        .where("receiverID", isEqualTo: userID)
        .get();
    for (var notification in noti.docs) {
      notifications.add(await Notifications.fromSnap(notification));
    }
    print(notifications.toString());
    return notifications;
  }

  static Future<void> deleteNotification(Notifications notification) async {
    try {
      // Assuming you have a Firestore collection named 'notifications'
      CollectionReference notificationsCollection =
          FirebaseFirestore.instance.collection('notifications');

      // Delete the notification from the database using the document ID
      await notificationsCollection.doc(notification.id).delete();

      // Print a message or handle success as needed
      print('Notification deleted successfully');
    } catch (e) {
      // Handle errors, e.g., show an error message
      print('Error deleting notification: $e');
    }
  }

  static Future<void> deleteNotificationByDetails(
      String senderID, String receiverID, String postID, String typeID) async {
    try {
      // Assuming you have a Firestore collection named 'notifications'
      var notificationsCollection = FirebaseFirestore.instance
          .collection('notifications');
          var notificationDoc = await notificationsCollection
          .where("senderID", isEqualTo: senderID)
          .where("receiverID", isEqualTo: receiverID)
          .where("postID", isEqualTo: postID)
          .where("typeID", isEqualTo: typeID)
          .limit(1)
          .get();

      // Delete the notification from the database using the document ID
      var firstDoc = notificationDoc.docs[0];
      String docID = firstDoc.id;
      await notificationsCollection.doc(docID).delete();

      // Print a message or handle success as needed
      print('Notification deleted successfully');
    } catch (e) {
      // Handle errors, e.g., show an error message
      print('Error deleting notification: $e');
    }
  }
}
