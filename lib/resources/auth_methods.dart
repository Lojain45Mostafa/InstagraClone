import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:instagram/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return model.User.fromSnap(snap);
  }

  //signup user
  Future<String> signUpUser({
    required username,
    required email,
    required password,
    required bio,
    required XFile file,
  }) async {
    String res = "Error occurred";

    try {
      if (email.isNotEmpty &&
          username.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty) {
        // Register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (cred.user != null) {
          String photoUrl = await StorageMethods().uploadImageToFirebaseStorage(
            'profilePics',
            file,
            false,
          );
          //create a new user
          model.User user = model.User(
            username: username,
            email: email,
            bio: bio,
            uid: cred.user!.uid,
            followers: [],
            following: [],
            photoUrl: photoUrl,
          );

          // Add user to the database
          await _firestore.collection('users').doc(cred.user!.uid).set(
                user.toJson(),
              );
          //this will return map for us as an object by json

          res = "success";
        } else {
          res = "User registration failed";
        }
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //function for login
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Error Occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // logging in user with email and password
        final credentials = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return {"res": credentials.user, "error": false};
      } else {
        return {"res": "Please enter all the fields", "error": true};
      }
    } catch (err) {
      res = "Error: ${err.toString()}";
      return {"res": res, "error": true};
    }
  }

//signing out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
