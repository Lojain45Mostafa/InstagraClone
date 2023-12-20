import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/screens/new_message.dart';
import 'package:instagram/screens/search.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
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
        title: Text('Chat Messages'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Handle adding a new chat
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewMessage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle searching (you can implement searching logic here)
              // print('Search button clicked!');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        // rebuilds UI whenver the data is received
        // Listen to the stream of messages
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy(
              'createdAt',
              descending: false,
            )
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found.'),
            );
          }

          final loadedMessages = chatSnapshots.data!.docs;

          return ListView.builder(
            itemCount: loadedMessages.length,
            itemBuilder: (ctx, index) {
              final messageData = loadedMessages[index].data();
              final username = messageData['username'];
              final text = messageData['text'];
              // final photoURL = messageData['photoURL'];

              return _buildChatMessage(username, text);
            },
          );
        },
      ),
    );
  }

  Widget _buildChatMessage(String username, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CircleAvatar(
          //   radius: 20,
          //   backgroundImage: NetworkImage(photoURL ??
          //       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLorGAuZfVX3ZCV_Pz0QZlcOvXzPHKELhVPA&usqp=CAU'),
          // ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
