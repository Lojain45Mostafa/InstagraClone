import 'package:flutter/material.dart';
import 'package:instagram/screens/comments_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  bool isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
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
                  backgroundImage: NetworkImage('https://tse1.mm.bing.net/th?id=OIP.zgHJll70H9gbc-RGAvfwmgHaFj&pid=Api&P=0&h=220'
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
                        Text('username', 
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
              onDoubleTap: (){
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
                  child: Image.asset('assets/nature-8gp.png',
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
            children: [
              IconButton(
                onPressed: (){},
               icon: const Icon(
                Icons.favorite,
                color: Colors.red,
                ),
               ),
                IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context)=>CommentsScreen(),
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
                '1,567 likes',
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
                  text:'username' ,
                  style: const TextStyle( 
                    fontWeight: FontWeight.bold,
                    ),
                ),
                TextSpan(
                  text:'  this is some description to be replaced' ,
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
                      'view all 20 comments',
                    style: const TextStyle( 
                      fontSize: 16,
                     color: secondaryColor
                     ),
                    ),
                  ),
              ),
               Container(
                    padding: const EdgeInsets.symmetric(vertical:4 ),
                    child: Text(
                      '6/11/2023',
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