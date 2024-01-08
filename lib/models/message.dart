import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/user.dart';

class Message {
  final String message;
  final Timestamp timestamp;
  final String? imageUrl;
  final User sender;
  final User receiver;
  Message(
      {required this.sender,
      required this.receiver,
      required this.message,
      required this.timestamp,
      this.imageUrl});
}
