import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/screens/comments_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/like_animation.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/utils/global_variables.dart';
import 'package:instagram/models/user.dart' as model;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async{
   try{
    QuerySnapshot snap = await FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').get();
    // query snapshot and doc snapshot are similar only that doc recieved after we put doc and query when we put get after the collection
  commentLen = snap.docs.length;
   } catch(e){
    showSnackBar(context, e.toString());
   }
   setState(() {
     //to see the comment length
   });
  }
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: EdgeInsets.symmetric(
        vertical: 10
      ),
      child: Column(
        children: [
          //Header section
          Container(
            padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    //getting the profile picture of whoever posted this post
                    widget.snap['profImage'].toString(),

                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                     
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                        widget.snap['username'].toString(), 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                onPressed: (){
                  showDialog(context: context, builder: (context) =>Dialog(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8,),
                      shrinkWrap: true ,
                      children: [
                        'Delete',
                        'edit',
                        'report',
                      ]
                      .map(
                        (e) =>InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                          child: Text(e),  
                        ),
                      ))
                      .toList()
                    ),
                  ));
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
               await FirestoreMethods().likePost(widget.snap['postId'].toString(),user.uid,widget.snap['likes'],
               );
               setState(() {
                 isLikeAnimating = true;
               });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                  height:MediaQuery.of(context).size.height*0.35,
                  width: double.infinity,
                  child: Image.network( widget.snap['postUrl'].toString(),
                  fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration( milliseconds: 200),
                  opacity: isLikeAnimating ? 1 :0 ,
                  child: LikeAnimation(
                    child:
                     const Icon(Icons.favorite , color: Colors.white, size: 80), 
                  isAnimating: isLikeAnimating,
                  duration: const Duration(
                    milliseconds: 400,
                  ),
                  onEnd: (){
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
            children:<Widget>[
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child:
              IconButton(
                onPressed: () async {
                await FirestoreMethods().likePost(widget.snap['postId'].toString(),user.uid,widget.snap['likes'],);
                },
               icon: widget.snap['likes'].contains(user.uid) ? const Icon(
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
                    builder: (context)=>CommentsScreen(
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
                onPressed: (){},
               icon: const Icon(
                Icons.send,
                ),
               ),
               Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                child: IconButton(
                onPressed: (){},
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
                style : Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900,),
                child : Text(
                  //The ${} syntax is used to embed the value of widget.snap[''] into the text
                '${widget.snap['likes'].length} likes',
                style : Theme.of(context).textTheme.bodyMedium,
              ),
              ),
              Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 8,
              ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle( color: primaryColor),
                  children: [
                    TextSpan(
                  text: widget.snap['username'].toString(),
                  style: const TextStyle( 
                    fontWeight: FontWeight.bold,
                    ),
                ),
                TextSpan(
                  //The ${} syntax is used to embed the value of widget.snap[''] into the text
                  text:' ${widget.snap['description']}' ,
                ),
                  ],
                ),
              ),
              ),
              InkWell(
                onTap: (){},
                child: 
                  Container(
                    padding: const EdgeInsets.symmetric(vertical:4 ),
                    child: Text(
                      'view all $commentLen comments',
                    style: const TextStyle( 
                      fontSize: 16,
                     color: secondaryColor
                     ),
                    ),
                  ),
              ),
               Container(
                    padding: const EdgeInsets.symmetric(vertical:4 ),
                    child:Text(

                    //got this DateFormat through intl package
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle( 
                      fontSize: 14,
                     color: secondaryColor
                     ),
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