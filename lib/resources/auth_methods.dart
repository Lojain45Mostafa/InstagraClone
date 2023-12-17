import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //signup user
  Future<String> signUpUser({
    required username,
    required email,
    required password,
    required bio,
    required Uint8List file,
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

          // Add user to the database
          await _firestore.collection('users').doc(cred.user!.uid).set({
            'username': username,
            'email': email,
            'bio': bio,
            'uid': cred.user!.uid,
            'followers': [],
            'followings': [],
            'photoUrl': photoUrl,
          });

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
  Future<String> loginUser({
    required email,
    required password,
  }) async {
    String res = "Error Occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

//signing out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
