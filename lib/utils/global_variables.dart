import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/add_post_screen.dart';
import 'package:instagram/screens/feedscreen.dart';
import 'package:instagram/screens/profilescreen.dart';
import 'package:instagram/screens/searchscreen.dart';

const webScreenSize = 600;

List<Widget> homescreens = [
  Center(
    child: FeedScree(),
  ),
  Center(
    child: SearchScreen(),
  ),
  AddPostScreen(),
  Center(
    child: Text('liked'),
  ),
  Center(
    child: ProfileScreen(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ),
  ),
];
