import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(
    //we will take them from user
  String description ,
  Uint8List file, 
  String uid,
  String username,
  String profImage,
  ) async{
    String res = "some error occured";
    try{
      String photoUrl = await StorageMethods().uploadImageToFirebaseStorage('posts',file,true);
      // we need to await because it will return a future string

      String postId = const Uuid().v1();
      // v1 makes a unique Id everytime based on time 
      Post post = Post(
       //passing arguments
       description: description,
       uid: uid,
       username: username,
       postId: postId,
       //for the postId there will be multiple posts for the same user that will get overridden so we will generate different postId
       datePublished:DateTime.now(),
       postUrl: photoUrl,
       profImage: profImage,
       likes: [],
      );
    
    //storing posts in firestore
    _firestore.collection('posts').doc(postId).set(post.toJson(),);
    res ="success";
    
    }catch(err){
      res = err.toString();
    }
    return res; 
  }
}