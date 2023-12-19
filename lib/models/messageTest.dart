import "package:cloud_firestore/cloud_firestore.dart";

class Message {
  final String senderld;
  final String senderEmail;
  final String receiverld;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderld,
    required this.senderEmail,
    required this.receiverld,
    required this.timestamp,
    required this.message,
  });

// convert to a map
  Map<String, dynamic> toMap() {
    return {
      'senderld': senderld,
      'senderEmail': senderEmail,
      'receiverld': receiverld,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
