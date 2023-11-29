import 'package:flutter/material.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({super.key});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
     padding: EdgeInsets.symmetric( vertical: 18, horizontal: 16,),
     child: Row(
      children: [
        CircleAvatar(
                backgroundImage: NetworkImage('https://tse1.mm.bing.net/th?id=OIP.zgHJll70H9gbc-RGAvfwmgHaFj&pid=Api&P=0&h=220'
                  ),
                 radius: 18,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(text:TextSpan(
                  children: [
                    TextSpan(
                  text: 'username',
                  style: const TextStyle(fontWeight: FontWeight.bold,),
                ),
                 TextSpan(
                  text: '  some description',
                ),
                  ],
                ), 
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4,),
                  child: Text(
                    '6/11/2023',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: const Icon(Icons.favorite , size: 16,),
        ),
      ],
     ),
    );
  }
}