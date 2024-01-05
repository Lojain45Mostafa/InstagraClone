import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/chatRoom.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/screens/feed_screen.dart';
import 'package:instagram/screens/new_message.dart';
import 'package:instagram/screens/search.dart';
import 'package:instagram/services/chatTest_service.dart';
import 'package:provider/provider.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Messages'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context); // ;This will navigate back to the previous screen (FeedScreen)
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle searching (you can implement searching logic here)
              // print('Search button clicked!');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ChatRoom>>(
        // rebuilds UI whenver the data is received
        // Listen to the stream of messages
        future: ChatService.getAllChatRoomsById(
            context.read<UserProvider>().getUser.uid),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!chatSnapshots.hasData || chatSnapshots.data!.isEmpty) {
            print(chatSnapshots.data);
            return const Center(
              child: Text('No messages found.'),
            );
          }

          final loadedMessages = chatSnapshots.data!;

          return ListView.builder(
            itemCount: loadedMessages.length,
            itemBuilder: (ctx, index) {
              User user = context.read<UserProvider>().getUser;
              String username = loadedMessages[index].receiver.username;
              if (loadedMessages[index].receiver.uid == user.uid) {
                username = loadedMessages[index].sender.username;
              }
              final text = loadedMessages[index].receiver.email;

              // final photoURL = messageData['photoURL'];

              return _buildChatMessage(username, text, loadedMessages[index],
                  loadedMessages[index].receiver);
            },
          );
        },
      ),
    );
  }

  Widget _buildChatMessage(
      String username, String text, ChatRoom room, User reciever) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewMessage(
                      room: room,
                      reciever: reciever,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CircleAvatar(
            //   radius: 20,
            //   backgroundImage: NetworkImage(photoURL ??
            //       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLorGAuZfVX3ZCV_Pz0QZlcOvXzPHKELhVPA&usqp=CAU'),
            // ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
