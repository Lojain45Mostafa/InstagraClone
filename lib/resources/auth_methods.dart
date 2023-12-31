import 'dart:io'; // Import the dart:io library for input/output operations.
import 'dart:typed_data'; // Import the dart:typed_data library for working with typed data.
import 'package:camera/camera.dart'; // Import the camera package for camera-related functionality.
import 'package:cloud_firestore/cloud_firestore.dart'; // Import the cloud_firestore package for Firestore database interaction.
import 'package:firebase_auth/firebase_auth.dart'; // Import the firebase_auth package for Firebase authentication.
import 'package:flutter/material.dart'; // Import the Flutter material library.
import 'package:instagram/resources/storage_methods.dart'; // Import a custom storage_methods file.
import 'package:instagram/models/user.dart'
    as model; // Import a custom user model file with an alias 'model'.

// Class responsible for authentication methods.
class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth
      .instance; // Initialize FirebaseAuth instance for user authentication.
  final FirebaseFirestore _firestore = FirebaseFirestore
      .instance; // Initialize Firestore instance for database operations.

  // Get user details from Firestore.
  Future<model.User> getUserDetails() async {
    User currentUser =
        _auth.currentUser!; // Get the current authenticated user.
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get(); // Get the user document from Firestore.
    return model.User.fromSnap(
        snap); // Create a User object from the Firestore document.
  }

  // Sign up a new user with provided details.
  Future<String> signUpUser({
    required username,
    required email,
    required password,
    required bio,
    required XFile file,
  }) async {
    String res =
        "Error occurred"; // Initialize the result variable with an error message.

    try {
      if (email.isNotEmpty &&
          username.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty) {
        // Register user with email and password.
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (cred.user != null) {
          // Upload user profile picture to Firebase Storage.
          String photoUrl = await StorageMethods().uploadImageToFirebaseStorage(
            'profilePics',
            file,
            false,
          );

          // Create a new User object.
          model.User user = model.User(
            username: username,
            email: email,
            bio: bio,
            uid: cred.user!.uid,
            followers: [],
            following: [],
            photoUrl: photoUrl,
          );

          // Add user to the Firestore database.
          await _firestore.collection('users').doc(cred.user!.uid).set(
                user.toJson(),
              );

          res =
              "success"; // Set result to success if user registration is successful.
        } else {
          res =
              "User registration failed"; // Set result to failure if user registration fails.
        }
      } else {
        res =
            "Please enter all the fields"; // Set result to a message if any required field is empty.
      }
    } catch (err) {
      res = err
          .toString(); // Set result to the error message if an exception occurs.
    }

    return res; // Return the result of the sign-up operation.
  }

  // Log in a user with provided email and password.
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    String res =
        "Error Occurred"; // Initialize the result variable with an error message.

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Log in user with email and password.
        final credentials = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        return {
          "res": credentials.user,
          "error": false
        }; // Return user credentials and set error to false.
      } else {
        return {
          "res": "Please enter all the fields",
          "error": true
        }; // Return a message and set error to true if fields are empty.
      }
    } catch (err) {
      res =
          "Error: ${err.toString()}"; // Set result to the error message if an exception occurs.
      return {
        "res": res,
        "error": true
      }; // Return the result and set error to true.
    }
  }

  // Sign out the current user.
  Future<void> signOut() async {
    await _auth.signOut(); // Sign out the current user using FirebaseAuth.
  }
}
