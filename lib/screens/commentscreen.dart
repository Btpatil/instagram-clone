import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_providers.dart';
import 'package:instagram/resources/firestoremethods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/commentcard.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController comment = TextEditingController();
  bool isPostingComment = false;

  @override
  void dispose() {
    super.dispose();
    comment.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return CommentCard(
                    commentDetails: snapshot.data!.docs[index].data(),
                  );
                });
          }
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                user.photoUrl,
              ),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextField(
                  controller: comment,
                  decoration: InputDecoration(
                    hintText: "Comment as ${user.username}...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            isPostingComment
                ? const CircularProgressIndicator()
                : InkWell(
                    onTap: () async {
                      setState(() {
                        isPostingComment = true;
                      });
                      String res = await FirestoreMethods().postComment(
                          widget.postId,
                          comment.text,
                          user.uid,
                          user.username,
                          user.photoUrl);
                      if (res == 'Successful') {
                        showSnackBar('Comment Posted', context);
                        setState(() {
                          comment.text = '';
                          isPostingComment = false;
                        });
                      } else {
                        setState(() {
                          isPostingComment = false;
                        });
                        showSnackBar(res, context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Text(
                        'Post',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  )
          ],
        ),
      )),
    );
  }
}
