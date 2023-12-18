import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/screens/camera_test.dart';
import 'package:instagram/utils/utils.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key});

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  Uint8List? _image;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    // send to Firebase
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    await FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });

    _messageController.clear();
    FocusScope.of(context).unfocus(); // close any open keyboard
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  // Function to open the camera when the camera icon is pressed
  void openCamera() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      // Handle the case where no cameras are available on the device.
      print('No cameras available on the device.');
      return;
    }

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    // Navigate to the TakePictureScreen with the obtained camera description.
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(camera: firstCamera),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Your existing chat messages or any other content here
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        InputDecoration(labelText: 'Enter your message'),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _submitMessage,
                ),
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    pickImage(ImageSource.gallery);
                  },
                ),
                // IconButton for taking a photo using the camera
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    openCamera(); // Pass the context to the function
                  },
                ),
              ],
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
