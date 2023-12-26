import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

Future<QuerySnapshot> searchUsers(String searchText) {
  // Access the Firestore instance and target the 'users' collection
  return FirebaseFirestore.instance
      .collection('users')
      // Order the documents by the 'username' field for more precise querying
      .orderBy('username')
      // Start the query at the specified searchText (case-sensitive)
      .startAt([searchController.text])
      // End the query at the end of the possible range of searchText (case-sensitive)
      // '\uf8ff' is a Unicode character that represents the end of a range
      .endAt([searchController.text + '\uf8ff'])
      // Perform the query and retrieve the result
      .get();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Search for a user',
          ),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUsers = true;
            });
          },
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: searchUsers(searchController.text),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData ||
                    (snapshot.data! as QuerySnapshot).docs.isEmpty) {
                  return const Center(
                    child: Text('No users found.'),
                  );
                } else {
                  return ListView.builder(
                    itemCount:
                        (snapshot.data! as QuerySnapshot).docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            (snapshot.data! as QuerySnapshot)
                                .docs[index]['photoUrl'],
                          ),
                        ),
                        title: Text(
                          (snapshot.data! as QuerySnapshot)
                              .docs[index]['username'],
                        ),
                      );
                    },
                  );
                }
              },
              )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

             return MasonryGridView.count(
              // Define the number of items in each row (3 items in this case)
              crossAxisCount: 3,
              // Determine the total number of items in the grid (length of fetched documents)
              itemCount: (snapshot.data! as dynamic).docs.length,
              // Define how each item in the grid will be built
              itemBuilder: (context, index) =>
                  // Create an Image widget for each item in the grid, using the URL from Firestore
                  Image.network(
                    (snapshot.data! as dynamic).docs[index]['postUrl'],
                    // Set the image's BoxFit property to cover the widget's bounds
                    fit: BoxFit.cover,
                  ),
              // Define the spacing between items along the main axis (vertical in this case)
              mainAxisSpacing: 8.0,
              // Define the spacing between items along the cross axis (horizontal in this case)
              crossAxisSpacing: 8.0,
);

              },
            ),
    );
  }
}

