import "package:cloud_firestore/cloud_firestore.dart";
import "package:instagram/models/user.dart";

class ChatRoom {
  final String id;
  final User sender;
  final User receiver;

  ChatRoom({
    required this.id,
    required this.sender,
    required this.receiver,
  });

// convert to a map
  Map<String, dynamic> toMap() {
    return {
      'senderld': sender.uid,
      'receiverld': receiver.uid,
    };
  }
}
