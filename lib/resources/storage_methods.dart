import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
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
      return "Error";
    }
    Reference refreenceRoot = FirebaseStorage.instance.ref();
    //byrouh ll root bta3 el storage

    Reference referenceDir = refreenceRoot.child('testing');
    //by3ml folder esmo testing gwa el root dh

    Reference oldRef = referenceDir.child(_auth.currentUser!.uid);
    //by3ml folder gwa el testing b esm el ID bta3 el user
    //asking for childname and going to create folder at that childname then uplaod the image and get the URL of it
    //we will have a child of posts then a folder of the uid of the user

    //lw el ispost b true el oldref bttghyar (overide) w byt3mlha unique Id gdeed bythat fih el image bta3t el post
    if (isPost) {
      //if it's a post we will just generate a unique id
      String id = const Uuid().v1();
      oldRef = referenceDir.child(id).child(file.name);
    }

    try {
      //put file di el actually bt3mlo upload 
      await oldRef.putFile(File(file.path));

      String downloadUrl = await oldRef.getDownloadURL();
      //btgeeb el url bta3 el sora 
      return downloadUrl;
    } catch (e) {
      return "error";
    }

  }
}
