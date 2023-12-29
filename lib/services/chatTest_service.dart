import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/chatRoom.dart';
import 'package:instagram/models/message.dart';
import 'package:instagram/models/notifications.dart';
import 'package:provider/provider.dart';
import 'package:instagram/models/user.dart' as model;

class ChatService extends ChangeNotifier {
  // get instance of auth and firestore
  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;
// SEND MESSAGE
  // Future<void> sendMessage(
  //     String receiverld, String message, String senderId) async {
  //   // get current user info

  //   final Timestamp timestamp = Timestamp.now();
  //   model.User sender = await Notifications.GetUserById(senderId);
  //   model.User receiver = await Notifications.GetUserById(receiverld);
  //   //create new message
  //   Message newMessage = Message(
  //     sender: sender,
  //     receiver: receiver,
  //     timestamp: timestamp,
  //     message: message,
  //   );

  //   //create new message to the database
  //   await fireStore.collection('chats').doc().set(newMessage.toMap());
  // }

  // Stream<QuerySnapshot> getMessages(String senderId, String receiverId) {
  //   //constract chat room id from the user ids (stored to ensure that it matches the id used )

  //   List<String> ids = [userId, otherUserId];
  //   ids.sort();
  //   String chatRoomId = ids.join("_");
  //   return fireStore
  //       .collection('chat_rooms')
  //       .doc(chatRoomId)
  //       .collection('messages')
  //       .orderBy('timestamp', descending: false)
  //       .snapshots();
  // }
  static Future<Map<ChatRoom, List<Message>>> getMessages(
      String senderId) async {
    //constract chat room id from the user ids (stored to ensure that it matches the id used )
    Map<ChatRoom, List<Message>> allMessages = {};

    var mergedSnapshot = await getAllChatRooms(senderId);

    for (var snapshot in mergedSnapshot) {
      var messagesCollection = snapshot.reference.collection('messages');
      var messagesQuerySnapshot = await messagesCollection.get();
      List<Message> tempMessages = [];
      for (var snap in messagesQuerySnapshot.docs) {
        String? imageUrl = snap["imageUrl"];
        if (snap["imageUrl"] == "") {
          imageUrl = null;
        }
        ;
        Message(
            message: snap["message"],
            timestamp: snap["date"],
            imageUrl: imageUrl,
            sender: await Notifications.GetUserById(snap["senderId"]),
            receiver: await Notifications.GetUserById(snap["receiverId"]));
      }

      allMessages[await getChatRoomById(snapshot.id)] = tempMessages;
    }
    return allMessages;
  }

  static Future<ChatRoom> getChatRoomById(String chatRoomId) async {
    var query = await fireStore.collection("chat_room").doc(chatRoomId).get();
    ChatRoom chatRoom = ChatRoom(
        id: query.id,
        sender: await Notifications.GetUserById(query["senderId"]),
        receiver: await Notifications.GetUserById(query["receiverId"]));
    return chatRoom;
  }

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getAllChatRooms(String senderId) async {
    print("idddddddddddddddd " + senderId);
    var query1 = fireStore
        .collection('chat_room')
        .where("senderId", isEqualTo: senderId);
    var query2 = fireStore
        .collection('chat_room')
        .where("receiverId", isEqualTo: senderId);
    var query1Snapshot = await query1.get();
    var query2Snapshot = await query2.get();
    var mergedSnapshot = query1Snapshot.docs + query2Snapshot.docs;
    return mergedSnapshot;
  }

  static Future<List<ChatRoom>> getAllChatRoomsById(String senderId) async {
    List<ChatRoom> rooms = [];

    var mergedSnapshot = await getAllChatRooms(senderId);
    for (var doc in mergedSnapshot) {
      ChatRoom room = ChatRoom(
          id: doc.id,
          sender: await Notifications.GetUserById(doc["senderId"]),
          receiver: await Notifications.GetUserById(doc["receiverId"]));
      rooms.add(room);
    }

    return rooms;
  }

  static Future<List<Message>> getMessagesByChatRoom(String ChatRoomId) async {
    //constract chat room id from the user ids (stored to ensure that it matches the id used )
    try {
      var snapshot =
          await fireStore.collection("chat_room").doc(ChatRoomId).get();

      var messagesCollection =
          snapshot.reference.collection('messages').orderBy("date");
      var messagesQuerySnapshot = await messagesCollection.get();
      List<Message> tempMessages = [];
      for (var snap in messagesQuerySnapshot.docs) {
        String? imageUrl = snap["imageUrl"];
        if (snap["imageUrl"] == "") {
          imageUrl = null;
        }
        print(snap["senderId"]);
        print(snap["receiverId"]);
        Message message = Message(
            message: snap["message"],
            timestamp: snap["date"],
            imageUrl: imageUrl,
            sender: await Notifications.GetUserById(snap["senderId"]),
            receiver: await Notifications.GetUserById(snap["receiverId"]));
        tempMessages.add(message);
      }
      return tempMessages;
    } catch (e) {
      print("erooorrrrr " + e.toString());
    }
    return [];
  }
}
