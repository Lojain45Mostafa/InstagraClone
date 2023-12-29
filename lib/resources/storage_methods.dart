import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //adding image to firebase storage
  Future<String> uploadImageToFirebaseStorage(
      String childName, XFile file, bool isPost) async {
    //a link of an errored image or image not found
    if (file == null) {
      print("file is nullllllllllllllll");
      return "Error";
    }
    Reference refreenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDir = refreenceRoot.child('testing');
    Reference oldRef = referenceDir.child(_auth.currentUser!.uid);
    //asking for childname and going to create folder at that childname then uplaod the image and get the URL of it
    //we will have a child of posts then a folder of the uid of the user
    if (isPost) {
      //if it's a post we will just generate a unique id
      String id = const Uuid().v1();
      oldRef = referenceDir.child(id).child(file.name);
    }

    try {
      await oldRef.putFile(File(file.path));

      String downloadUrl = await oldRef.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    } catch (e) {
      print("errorrrrrrrr" + e.toString());
    }
    return "error";
  }
}
