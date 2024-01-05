import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/add_post_screen.dart';
import 'package:instagram/screens/chat_messages.dart';
import 'package:instagram/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatMessages()),
              );
            },
            icon: const Icon(
              Icons.messenger_outline,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        //using streambuilder to listen to the real time database
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        //we are not using get because this is realtime database (using snapshot) and we are not using .doc(id) cuz we want all the documents
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //checking the connection state
            return const Center(
              child: CircularProgressIndicator(),
              //It blocks the user from interacting with the application when it is busy
              //It is used in instances such as downloading and uploading content, fetching data from api, processing data etc
              //A widget that shows progress along a circle
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No posts available'),
            );
          }
          return ListView.builder(
            //counting this snapshot data and it can't be null
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => PostCard(
              //render data that is present in the post card
              // we are going to grab one doc at a time cuz we are calling list view builder it will rend as the number of documents
              //and index will be 0 the first time, 1 the second time  and so on
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
    );
  }
}
