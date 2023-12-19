import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/notificationType.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications {
  Notifications(
      {required this.reciever,
      required this.sender,
      required this.post,
      required this.type});

  final User reciever;
  final User sender;
  final Post post;
  final NotificationType type;

  static Future<User> GetUserById(String userId) async {
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: userId)
        .limit(1)
        .get();
    var snap = doc.docs.first;
    return User(
        email: snap["email"],
        uid: snap["uid"],
        photoUrl: snap["photoUrl"],
        username: snap["username"],
        bio: snap["bio"],
        following: snap["following"],
        followers: snap["followers"]);
  }

  static Future<Post> GetPostById(String postId) async {
    var doc = await FirebaseFirestore.instance
        .collection("posts")
        .where("postId", isEqualTo: postId)
        .limit(1)
        .get();
    var snap = doc.docs.first;
    Timestamp firebaseTimestamp = snap["datePublished"];
    return Post(
        description: snap["description"],
        uid: snap["uid"],
        username: snap["username"],
        likes: snap["likes"],
        postId: postId,
        datePublished: firebaseTimestamp.toDate(),
        postUrl: snap["postUrl"],
        profImage: snap["profImage"]);
  }

  static Future<NotificationType> GetNotificatioTypeById(String notificationTypeId) async {
    var snap = await FirebaseFirestore.instance
        .collection("notification_types")
        .doc(notificationTypeId)
        .get();
    return NotificationType(description: snap["description"], name: snap["name"], id: snap.id);
  }

  static Future<Notifications> fromSnap(DocumentSnapshot snap) async {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Notifications(
      reciever: await Notifications.GetUserById(snapshot["receiverID"]),
      sender: await Notifications.GetUserById(snapshot["senderID"]),
      post: await Notifications.GetPostById(snapshot["postID"]),
      type: await Notifications.GetNotificatioTypeById(snapshot["typeID"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "receiverID": reciever.uid,
        "senderID": sender.uid,
        "postID": post.postId,
        "typeID": type.id,
      };

      static Future<void> sendNotification({
    required String senderID,
    required String receiverID,
    required String postID,
    required String typeID,
  }) async {
    // Fetch sender, receiver, post, and notification type
    User sender = await GetUserById(senderID);
    User receiver = await GetUserById(receiverID);
    Post post = await GetPostById(postID);
    NotificationType type = await GetNotificatioTypeById(typeID);

    // Create a new notification
    Notifications notification = Notifications(
      reciever: receiver,
      sender: sender,
      post: post,
      type: type,
    );

    // Add the notification to Firestore or your preferred data store
    await FirebaseFirestore.instance.collection('notifications').add(
      notification.toJson(),
    );

    // You can also implement additional logic for sending push notifications, etc.
  }
}
