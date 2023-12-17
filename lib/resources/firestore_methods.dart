// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:instagram/models/post.dart';
// import 'package:instagram/resources/storage_methods.dart';

// class FirestoreMethods{
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   //upload post
//   Future<String> uploadPost{
//     //we will take them from user
//   String description ,
//   Uint8List file, 
//   String uid,
//   string username,
//   } 
//   async{
//     String res = "some error occured";
//     try{
//       String photoUrl = await StorageMethods().uploadImageToStorage('posts',file,true)
//       // we need to await because it will return a future string
//       Post post = Post{
//        //passing arguments
//        description: description,
//        uid: uid,
//        username: username,

//       };
//     }
//     catch(err){

//     }
//   }
// }