import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/chatTest_bubble.dart';
import 'package:instagram/services/chatTest_service.dart';
import 'package:instagram/widgets/text_field_input.dart';

class ChatTestPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  const ChatTestPage(
      {super.key,
      required this.receiverUserEmail,
      required this.receiverUserID});

  @override
  State<ChatTestPage> createState() => _ChatTestPageState();
}

class _ChatTestPageState extends State<ChatTestPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);
      _messageController
          .clear(); //celaring message controller after sending the message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
      ),
      body: Column(
        children: [
          //messages
          Expanded(child: _buildMessageList()),
          //user input
          _buildMessageInput(),
        ],
      ),
    );
  }

  //build message  list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (data == null ||
        !data.containsKey('senderId') ||
        !data.containsKey('senderEmail') ||
        !data.containsKey('message')) {
      // Handle the case where data is null or does not contain required fields
      return Container();
    }

    // Alignment of the messages
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Text(data['senderEmail'] ?? ''), // Use the null-aware operator
          const SizedBox(
            height: 5,
          ),
          ChatTestBubble(
              message: data['message'] ?? ''), // Use the null-aware operator
        ],
      ),
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        //text field
        Expanded(
          child: TextFieldInput(
            hintText: "Enter your email",
            obscureText: false,
            textEditingController: _messageController,
            textInputType: TextInputType.text,
          ),
        ),
        //send button
        IconButton(onPressed: sendMessage, icon: Icon(Icons.send))
      ],
    );
  }
}
