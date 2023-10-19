import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/resources/firestoremethods.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/followbutton.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userData = {};
  int postLength = 0;
  bool isLoading = true;
  bool isFollowing = false;

  void followFunc() async {
    String res = await FirestoreMethods()
        .followUser(FirebaseAuth.instance.currentUser!.uid, widget.uid);
    if (res == 'unfollowed') {
      getData();
      showSnackBar(res, context);
    } else if (res == 'followed') {
      getData();
      showSnackBar(res, context);
    } else {
      showSnackBar(res, context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    // setState(() {
    //   isLoading = false;
    // });
  }

  getData() async {
    try {
      DocumentSnapshot userssnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userssnap.data()! as Map<String, dynamic>;
      var postsnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLength = postsnap.docs.length;
      isFollowing = userData['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username'].toString()),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(userData['photoUrl']),
                            radius: 50,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumnWidget(postLength, 'Posts'),
                                    buildStatColumnWidget(
                                        userData['following'].length,
                                        'Following'),
                                    buildStatColumnWidget(
                                        userData['followers'].length,
                                        'Followers'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            bgColor: mobileBackgroundColor,
                                            borderColor: Colors.grey,
                                            text: 'Sign Out',
                                            textColor: primaryColor,
                                            function: () async {
                                              await AuthMethods().SignOut();
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return LoginScreen();
                                                  },
                                                ),
                                              );
                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                bgColor: Colors.white,
                                                borderColor: blueColor,
                                                text: 'Unfollow',
                                                textColor: Colors.black,
                                                function: followFunc,
                                              )
                                            : FollowButton(
                                                bgColor: blueColor,
                                                borderColor: blueColor,
                                                text: 'Follow',
                                                textColor: Colors.white,
                                                function: followFunc,
                                              ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
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
                        alignment: Alignment.centerLeft,
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap = snapshot.data!.docs[index];
                        return Container(
                          child: Image(
                            image: NetworkImage(snap['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }

  Column buildStatColumnWidget(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 4, left: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
