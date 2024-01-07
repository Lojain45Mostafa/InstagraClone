import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/resources/notifications_methods.dart';
import 'package:instagram/screens/Profile_screen.dart';
import 'package:instagram/screens/comments_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/translator.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/buttons.dart';
import 'package:instagram/widgets/like_animation.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/utils/global_variables.dart';
import 'package:instagram/models/user.dart' as model;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:instagram/models/notifications.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);
  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String translatedText = '';
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    getComments();
    super.initState();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      // query snapshot and doc snapshot are similar only that doc recieved after we put doc and query when we put get after the collection
      commentLen = snap.docs.length;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      //to see the comment length
    });
  }

  Future<void> SaveLocally(BuildContext context) async {
    String url = widget.snap['postUrl'].toString();
    FileDownloader.downloadFile(
      url: url,
      onDownloadError: (String error) {
        print('Error downloading: $error');
      },
      onDownloadCompleted: (path) {
        final File file = File(path);
        print(file);
      },
    );
    showSnackBar(context, "Image Saved Sucessfully");
    Navigator.pop(context);
  }

  Future<void> DeletepostFun(BuildContext context) async {
    //getting the comments of this specific post from firebase
    QuerySnapshot comments = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments')
        .get();

    DocumentSnapshot gettingDeletedPost = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .get();
    String deleteResult =
        await FirestoreMethods().deletePost(widget.snap['postId']);
    if (deleteResult == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await FirestoreMethods()
                  .restorePost(gettingDeletedPost, comments);
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deletion failed'),
        ),
      );
    }
    Navigator.of(context).pop(); // Close the dialog
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          //Header section
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [

                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Profile(
                        uid: widget.snap['uid'],
                      ),
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      //getting the profile picture of whoever posted this post
                      widget.snap['profImage'].toString(),
                    ),
                  ),
                ),

                SizedBox(
                    width:
                        12), // Add space between the CircleAvatar and the username
                Text(
                  widget.snap['username'].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () async {
                    String postId = widget.snap['postId']; // Extracting postId
                    // Show the 'Delete' option when the three dots are clicked
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shrinkWrap: true,
                            children: [
                              if (widget.snap['uid'] ==
                                  context.read<UserProvider>().getUser.uid)
                                CustomButton(
                                  buttonText: 'Delete',
                                  onTapFunction: DeletepostFun,
                                ),
                              CustomButton(
                                buttonText: 'Save Post',
                                onTapFunction: SaveLocally,

                              )
                            ]),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.more_vert,
                  ),
                ),
              ],
            ),
          ),
          //image section
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                widget.snap['postId'].toString(),
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'].toString(),
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(Icons.favorite,
                        color: Colors.white, size: 80),
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          // like comment section
          Row(
            children: <Widget>[
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    List<dynamic> likes = widget.snap["likes"];
                    await FirestoreMethods().likePost(
                      widget.snap['postId'].toString(),
                      user.uid,
                      likes,
                    );
                    if (!likes.contains(user.uid)) {
                      await Notifications.sendNotification(
                          senderID: context.read<UserProvider>().getUser.uid,
                          receiverID: widget.snap["uid"],
                          postID: widget.snap["postId"],
                          typeID: "5ds9o3g3tG4x81i44rs7");
                    } else {
                      await NotificationsMethods.deleteNotificationByDetails(
                          context.read<UserProvider>().getUser.uid,
                          widget.snap["uid"],
                          widget.snap["postId"],
                          "5ds9o3g3tG4x81i44rs7");
                    }
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(
                      snap: widget.snap,
                      postId: widget.snap['postId'].toString(),
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_border,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // description of likes and comments
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                  child: Text(
                    //The ${} syntax is used to embed the value of widget.snap[''] into the text
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: primaryColor),
                              children: [
                                TextSpan(
                                  text: widget.snap['username'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  //The ${} syntax is used to embed the value of widget.snap[''] into the text
                                  text: ' ${widget.snap['description']}',
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            child: TextButton(
                                onPressed: () async {
                                  String translated =
                                      await TranslationApi.translate2(
                                          widget.snap['description'],
                                          'en',
                                          'ar');
                                  setState(() {
                                    translatedText = translated;
                                  });
                                },
                                child: Text('see translation')),
                          )
                        ],
                      ),
                      Text(translatedText),
                    ],
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.snap['postId'])
                      .collection('comments')
                      .snapshots(),
                  builder: (context, snapshot) {
                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    //   return CircularProgressIndicator(); // Or a loading indicator
                    // }

                    // if (snapshot.hasError) {
                    //   return Text('Error: ${snapshot.error}');
                    // }

                    if (snapshot.hasData) {
                      // Update commentLen with the current length of comments
                      commentLen = snapshot.data!.docs.length;

                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                snap: widget.snap,
                                postId: widget.snap['postId'].toString(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            'view all $commentLen comments',
                            style: const TextStyle(
                              fontSize: 16,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                      );
                    }

                    return SizedBox(); // Return an empty widget or handle other states
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    //got this DateFormat through intl package
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(fontSize: 14, color: secondaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
