import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  //properties of user class
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List following;
  final List followers;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.following,
    required this.followers,
  });
//function will take a document snapshot and return user model
//we did this here once because we are gonna use it again so we don't have to do it ecerytime we will just call it
static User fromSnap(DocumentSnapshot snap){
  var snapshot = snap.data() as Map<String,dynamic>;

  return User(
    username: snapshot['username'],
    uid: snapshot['uid'],
    email: snapshot['email'],
    photoUrl: snapshot['photoUrl'],
    bio: snapshot['bio'],
    followers: snapshot['followers'],
    following: snapshot['following'],
  );
}


  //this method will convert whatever user object we require from here to an object
  Map<String,dynamic> toJson() =>{
    "username": username,
    "uid": uid,
    "email": email,
    "photoUrl":photoUrl,
    "bio":bio,
    "followers": followers,
    "following": following,
  };
}