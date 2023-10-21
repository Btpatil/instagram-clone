import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload
  Future<String> uploadPost(String desc, Uint8List file, String uid,
      String username, String profileImage) async {
    String res = "Some error occured";
    try {
      String photoUrl =
          await StorageMethod().uploadImageToStorage('posts', true, file);
      String postId = const Uuid().v1();

      Post post = Post(
        desc: desc,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.tojson());

      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(String postId, String comment, String uid,
      String username, String profilePhoto) async {
    String res = 'Some error occured';
    try {
      if (comment.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePhoto': profilePhoto,
          'username': username,
          'uid': uid,
          'comment': comment,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'Successful';
        return res;
      } else {
        res = 'Comment cant be Empty! Enter some text';
        return res;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> deletePost(String postId) async {
    String res = 'Some error occured';
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
      res = 'success';
      return res;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> followUser(String currUserId, String followId) async {
    String res = 'Some error occured';
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(currUserId)
          .get();
      Map<String, dynamic> snapData = snap.data() as dynamic;
      List following = snapData['following'];
      // List followers = snapData['followers'];
      // print(snapData);

      if (following.contains(followId)) {
        res = 'unfollowed';
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([currUserId]),
        });

        await _firestore.collection('users').doc(currUserId).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        res = 'followed';
        await _firestore.collection('users').doc(currUserId).update({
          'following': FieldValue.arrayUnion([followId]),
        });

        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([currUserId]),
        });
      }
      return res;
    } catch (e) {
      return e.toString();
    }
  }
}
