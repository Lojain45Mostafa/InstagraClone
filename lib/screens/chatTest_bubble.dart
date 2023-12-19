import 'package:flutter/material.dart';

class ChatTestBubble extends StatelessWidget {
  final String message;
  const ChatTestBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue,
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }
}
