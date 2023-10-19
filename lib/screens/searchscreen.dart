import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/screens/profilescreen.dart';
import 'package:instagram/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool showSearchedUsers = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: 'Search for a User',
          ),
          onFieldSubmitted: (String _) {
            if (searchController.text != '') {
              setState(() {
                showSearchedUsers = true;
              });
            } else {
              setState(() {
                showSearchedUsers = false;
              });
            }
          },
        ),
      ),
      body: showSearchedUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return ProfileScreen(
                                    uid: snapshot.data!.docs[index]
                                        .data()['uid']);
                              },
                            ),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                snapshot.data!.docs[index].data()['photoUrl']),
                          ),
                          title: Text(
                              snapshot.data!.docs[index].data()['username']),
                        ),
                      );
                    },
                  );
                }
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  return MasonryGridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                          snapshot.data!.docs[index]['postUrl']);
                    },
                  );
                }
              },
            ),
    );
  }
}
