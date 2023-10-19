import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String desc;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profileImage;
  final likes;

  const Post(
      {required this.desc,
      required this.uid,
      required this.username,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profileImage,
      required this.likes});

  Map<String, dynamic> tojson() => {
        'username': username,
        'uid': uid,
        'desc': desc,
        'postId': postId,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'profileImage': profileImage,
        'likes': likes
      };

  static Post fromsnap(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      desc: snapshot['desc'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      profileImage: snapshot['profileImage'],
      likes: snapshot['likes'],
    );
  }
}
