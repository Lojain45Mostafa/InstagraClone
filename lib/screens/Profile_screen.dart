import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/chatRoom.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/screens/new_message.dart';
import 'package:instagram/services/chatTest_service.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/follow_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final String uid;
  const Profile({super.key, required this.uid});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var userData = {}; //we will store the user's data here
  var postCount; //to check num of posts for this user
  var followers = 0; // the dynamic number of followers
  var following = 0; // the dynamic number of followings
  bool isFollowing =
      false; //checks if the user is followes or not for the follow button to change
  bool isLoading = false; //for visual inicator of loading

  @override
  void initState() {
    // to get data of user from firebase
    super.initState();
    getData(); //get datafrom db
  }

  getData() async {
    setState(() {
      isLoading = true;
    }); //when getting data the app will be loading
    try {
      //query or gettings a snapshot from db of user's data
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      userData = userSnap
          .data()!; // data from db is now stored in userData, ! mean not null
/*-------------------------------------------------------------------------------------------*/
      //get the count of posts
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid',
              isEqualTo: widget
                  .uid) // Use widget.uid instead of FirebaseAuth.instance.currentUser!.uid
          .get();
      postCount = postSnap.docs.length; //get length of list as in num of posts
/*-------------------------------------------------------------------------------------------*/
//following data
      followers =
          userData['followers'].length; //store current number of followers
      following =
          userData['following'].length; //store current number of following
      isFollowing = userData['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      showSnackBar(context, e.toString()); // show error in a snack bar
    }
    setState(() {
      isLoading = false; //after data is retrived, no more loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child:
                CircularProgressIndicator(), // if isLoading is true, show loading in ui
          )
        : Scaffold(
            appBar: AppBar(
                // the upper app bar in the profile page
                backgroundColor: mobileBackgroundColor,
                title: Text(userData['username']),
                centerTitle: false,
                actions: [

                  IconButton(
                    onPressed: () async {
                      ChatRoom room = await ChatService.createChatRoom(
                          context.read<UserProvider>().getUser.uid, widget.uid);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewMessage(
                                  room: room, reciever: room.receiver)));
                    },
                    icon: const Icon(Icons.messenger_outline),
                  ),
                  IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).colorScheme.primary,
                    ), // Icon
                  ),
                ]),
            body: ListView(
              children: [
                //elements of the profile page
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // the area with the followers and photo
                      Row(
                        children: [
                          CircleAvatar(
                            //profile pic
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            //idk why but it helps spacing
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  //for the stats of followers, posts, and others
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly, // we want same space between stats
                                  children: [
                                    buildStatColumn(postCount, 'posts'),
                                    buildStatColumn(followers, 'follower'),
                                    buildStatColumn(following, 'following'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly, //idk why this is the best
                                  children: [
                                    /*-------------------------------------------------*/
                                    //this is the dynamic profile button
                                    //if we r in the current user's profile page the button should be edit profile
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? Followbutton(
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            borderColor: Colors.grey,
                                            text: 'Edit Profile',
                                            textColor: primaryColor,
                                            function: () {},
                                          )
                                        : //if we r in the current user's profile page the button should be follow/unfollow
                                        /*-----------------------------------------*/
                                        isFollowing
                                            ? //check if following or not
                                            //if following, unfollow
                                            Followbutton(
                                                backgroundColor: Colors.white,
                                                borderColor: Colors.grey,
                                                text: 'Unfollow',
                                                textColor: Colors.black,
                                                function: () async {
                                                  await FirestoreMethods()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData[
                                                              'uid']); //current user id and the id of the user data retrieved erlier

                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            :
                                            /*-----------------------------------------*/
                                            //if not following (last case) follow
                                            Followbutton(
                                                backgroundColor: Colors.blue,
                                                borderColor: Colors.blue,
                                                text: 'Follow',
                                                textColor: Colors.white,
                                                function: () async {
                                                  await FirestoreMethods()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData[
                                                              'uid']); //current user id and the id of the user data retrieved erlier

                                                  setState(() {
                                                    //to update the ui
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                              )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        //user name
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['username'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        // the bio
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          userData['bio'],
                        ),
                      )
                    ],
                  ),
                ),

                const Divider(), // the line before the posts
                /*-----------------------------------------------------------------------------------------*/
                //posts
                FutureBuilder(
                    // bc its just a list that doesnt need to be realtime
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      // context?? dont remember, snapshot bc thats the type of data that holds db snapshot
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(), //loading
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic)
                            .docs
                            .length, // to get the number of posts
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, //3 posts each row
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 1.5,
                                childAspectRatio: 1),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap =
                              (snapshot.data! as dynamic).docs[index];
                          return Container(
                            child: Image(
                              image: NetworkImage(
                                  (snap.data()! as dynamic)['postUrl']),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    })
              ],
            ),
          );
  }

//-----------------------------------------------------------------------------------//
  // a widget for the stats
  Column buildStatColumn(int num, String lable) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          // the numbers
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
              top: 4), //some spacing between lable and number
          child: Text(
            // the lable
            lable,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400, //wight 400
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
  /**---------------------------- */
}
