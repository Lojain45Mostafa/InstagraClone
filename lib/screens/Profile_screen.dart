import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/follow_button.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // the upper app bar in the profile page
        backgroundColor: mobileBackgroundColor,
        title: Text('user name'),
        centerTitle: false,
      ),
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
                    const CircleAvatar(
                      //profile pic
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                          'https://th.bing.com/th/id/OIP.5WmM-nUxirNK9R-iAL4QRAHaHa?rs=1&pid=ImgDetMain'),
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
                              buildStatColumn(20, 'posts'),
                              buildStatColumn(150, 'follower'),
                              buildStatColumn(10, 'following'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceEvenly, //idk why this is the best
                            children: [
                              Followbutton(
                                  //its not just follow its also edit profile
                                  backgroundColor: mobileBackgroundColor,
                                  borderColor: Colors.grey,
                                  text: 'Edit Profile',
                                  textColor: primaryColor)
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
                    'username',
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
                    'bio',
                  ),
                )
              ],
            ),
          ),
          const Divider(),
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
