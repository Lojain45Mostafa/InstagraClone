import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/comment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/utils/global_variables.dart';
import 'package:instagram/models/user.dart' as model;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
   const CommentsScreen({Key? key, required this.snap}) : super(key: key);
  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
    final TextEditingController commentEditingController =
      TextEditingController();
      @override
  void dispose() {
    // TODO: implement dispose
    commentEditingController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.
        collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments')
        .orderBy('datePublished' , descending: true)
        .snapshots(),
        builder: (context, snapshot) {
           print(snapshot);
          if(snapshot.connectionState == ConnectionState.waiting){
            //checking the connection state
            return const  Center(
              child: CircularProgressIndicator(),
              //It blocks the user from interacting with the application when it is busy
              //It is used in instances such as downloading and uploading content, fetching data from api, processing data etc
              //A widget that shows progress along a circle
            );
          }
          return ListView.builder(
            //counting this snapshot data and it can't be null
            itemCount: (snapshot.data! as dynamic).docs.length ,
            itemBuilder: (context, index) {
                    final dynamic document =
                        (snapshot.data! as QuerySnapshot<Object?>).docs[index];

                    // Check if the document exists and contains data
                    if (document != null && document is Map<String, dynamic>) {
                      return CommentCard(
                        snap: document,
                      );
                    } else {
                      // Handle if the document doesn't exist or data is null
                      return SizedBox(); // Or any placeholder widget
                    }
              },

           
            );
        }, 
        ),
      bottomNavigationBar: SafeArea(
        child: Container(
           height: kToolbarHeight,
           margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            padding: const EdgeInsets.only( left: 16 , right: 8),
              child : Row(
                children: [
               CircleAvatar(
                backgroundImage: NetworkImage(
                  user.photoUrl,
                  ),
                 radius: 18,
               ),
               Expanded(
                 child: Padding(
                   padding: const EdgeInsets.only( left: 16 , right: 8),
                   child: TextField(
                     controller:commentEditingController,
                      decoration: InputDecoration(
                        hintText: 'comment as ${user.username}',
                        border: InputBorder.none,
                      ),
                   ),
                 ),
               ),
               InkWell(
                onTap: () async{
                   await FirestoreMethods().postComment(
                    widget.snap['postId'], 
                    commentEditingController.text,
                    user.uid,
                    user.username,
                    user.photoUrl,);
                    setState(() {
                      commentEditingController.text ='';
                    });
                },
               child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
                child: const Text(
                  'post',
                  style: TextStyle(
                  color: blueColor,
                  ),
                ),
               ),
               ),
              ],
              ),
        ),
        ),
    );
  }
}