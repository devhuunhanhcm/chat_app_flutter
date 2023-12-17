import 'dart:developer';

import 'package:chat_app_flutter/firebase/post_service.dart';
import 'package:chat_app_flutter/models/comment.dart';
import 'package:chat_app_flutter/models/post.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:chat_app_flutter/widget/comment_card.dart';
import 'package:chat_app_flutter/widget/contact_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CommentsScreen extends StatefulWidget {
  final UserModel user;
  final Post post;
  const CommentsScreen({super.key, required this.user, required this.post});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentController = TextEditingController();
  final PostService _postService = PostService();

  void postComment(String uid, String fullName, String photoUrl) async {
    try {
      String res = await _postService.postComment(
          widget.post.postId,
          commentController.text,
          uid,
          fullName,
          photoUrl,
          widget.post.commentNum + 1);

      if (res != 'success') {
        if (context.mounted) {}
      }
      setState(() {
        commentController.text = "";
      });
    } catch (err) {
      log(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(widget.post.postId)
                    .collection('comments')
                    .orderBy("datePublished", descending: true)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) => CommentCard(
                      comment: Comment.fromSnap(snapshot.data!.docs[index]),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  ContactAvatar(url: widget.user.photoUrl, size: 20),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey[300]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Comment as ${widget.user.fullName}',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => postComment(
                      widget.user.uid,
                      widget.user.fullName,
                      widget.user.photoUrl,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: const Icon(Icons.send_outlined),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
