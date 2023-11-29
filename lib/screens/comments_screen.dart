import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('comments'),
        centerTitle: false,
      ),
      body: CommentCard(),
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
                backgroundImage: NetworkImage('https://tse1.mm.bing.net/th?id=OIP.zgHJll70H9gbc-RGAvfwmgHaFj&pid=Api&P=0&h=220'
                  ),
                 radius: 18,
               ),
               Expanded(
                 child: Padding(
                   padding: const EdgeInsets.only( left: 16 , right: 8),
                   child: TextField(
                      decoration: InputDecoration(
                        hintText: 'comment as @farahhamedd',
                        border: InputBorder.none,
                      ),
                   ),
                 ),
               ),
               InkWell(
                onTap: (){},
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