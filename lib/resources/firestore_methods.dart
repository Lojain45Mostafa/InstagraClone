import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(
    //we will take them from user
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "some error occured";
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToFirebaseStorage('posts', file, true);
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
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      //storing posts in firestore
      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        //if following, this fumction is going to unfollow
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([
            uid //remove the current user id from the list of followers of the followId user
          ])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([
            followId //remove the followed user id from the followings of the current user
          ])
        });
      } else {
        //user doesnt follow the other user, this is for following

        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }


  Future<void> likePost(String postId , String uid , List likes) async{
    try{
         if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        //that checks if we already liked the post so that we can dislike it
        await _firestore.collection('posts').doc(postId).update({
          //going to the specific post to update likes array
          'likes': FieldValue.arrayRemove([uid])
          //in this field likes remove like with this id from the array
        });
      }else {
        // else we need to add uid to the likes array
       await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    }catch(e){
      print(e.toString(),);
    }
  }
Future<String> postComment(String postId,String text , String uid ,String name ,String profilePic) async{
   String res = "Some error occurred";
 try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
       await  _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
}

//deleting post
 Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

}

