import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/models/place.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/screens/feed_screen.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/widgets/Location_inputs.dart';
import 'package:provider/provider.dart';
import 'package:instagram/providers/user_provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  XFile? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  PlaceLocation? _pickedLocation;

  void postImage(
    //they are accepting arguments from here because there is a provider down
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
        _pickedLocation,
      );

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });

        //Widgets have a property called mounted which indicates whether
        //they are currently part of the widget tree and thus able to be rendered on the screen.
        //When you check if (context.mounted), you're ensuring that the widget associated with the provided BuildContext
        // is still available and active in the widget tree before performing certain actions
        if (context.mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
        }
        ClearImage();
        // Navigate back to the FeedScreen after posting successfully
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MobileScreenLayout()),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  XFile file = await pickImage(
                    ImageSource.camera,
                  );
                  StorageMethods storageMethods = StorageMethods();
                  await storageMethods.uploadImageToFirebaseStorage(
                      "testing", file, true);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  XFile file = await pickImage(
                    ImageSource.gallery,
                  );

                  StorageMethods storageMethods = StorageMethods();
                  await storageMethods.uploadImageToFirebaseStorage(
                      "testing", file, true);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void ClearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    // var user;
    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: ClearImage,
              ),
              title: const Text('Post to'),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () => postImage(
                          userProvider.getUser.uid,
                          userProvider.getUser.username,
                          userProvider.getUser.photoUrl,
                        ),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ))
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          context.read<UserProvider>().getUser.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'write a caption',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        //Maintains the aspect ratio of the image preview container.
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: FileImage(File(_file!.path)),
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                          )),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
                Container(
                  child: LocationInput(
                      key: UniqueKey(),
                      onLocationSelected: (PlaceLocation location) {
                        setState(() {
                          _pickedLocation = location;
                        });
                      }),
                ),
              ],
            ),
          );
  }
}
