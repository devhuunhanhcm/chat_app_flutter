import 'dart:developer';

import 'package:chat_app_flutter/firebase/post_service.dart';
import 'package:chat_app_flutter/models/post.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:chat_app_flutter/screens/HomeScreen.dart';
import 'package:chat_app_flutter/utils/style/app_colors.dart';
import 'package:chat_app_flutter/utils/toast/toast.dart';
import 'package:chat_app_flutter/widget/comment_card.dart';
import 'package:chat_app_flutter/widget/contact_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final UserModel user;

  const PostCard({super.key, required this.post, required this.user});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLike = false;
  int likes = 0;
  int comments = 0;
  TextEditingController commentController = TextEditingController();
  PostService _postService = PostService();

  @override
  void initState() {
    setState(() {
      likes = widget.post.likes.length;
      isLike = widget.post.likes.contains(widget.user.uid);
      comments = widget.post.comments.length;
    });
    super.initState();
  }

  handleLike() async {
    String res = await PostService().likePost(
      widget.post.postId,
      widget.user.uid,
      widget.post.likes,
    );
    if (res == "success") {
      setState(() {
        isLike = !isLike;
        likes = isLike ? ++likes : --likes;
      });
    }
  }

  void postComment(String uid, String fullName, String photoUrl) async {
    try {
      String res = await _postService.postComment(
        widget.post.postId,
        commentController.text,
        uid,
        fullName,
        photoUrl,
      );

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
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: <Widget>[
                  ContactAvatar(url: widget.post.profImage, size: 20),
                  const SizedBox(width: 7.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.post.fullName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.0)),
                      const SizedBox(height: 5.0),
                      Text(widget.post.formattedDate)
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                          useRootNavigator: false,
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: ListView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: ['Hide this post.']
                                      .map(
                                        (e) => InkWell(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: Text(e),
                                            ),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            }),
                                      )
                                      .toList()),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.more_horiz_outlined)),
                  widget.post.uid == widget.user.uid
                      ? IconButton(
                          onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Delete this post.'),
                                  content: const Text(
                                      'The post will be deleted and cannot be recovered.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        String result = await PostService()
                                            .deletePost(widget.post.postId);
                                        if (result == 'success') {
                                          Navigator.pop(context, 'Cancel');
                                          showToast(
                                              message:
                                                  "Delete post successfully");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeScreen(
                                                      tab: 3,
                                                    )),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'OK',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          icon: const Icon(Icons.close))
                      : Container(),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Container(
              child: Text(widget.post.content,
                  style: const TextStyle(fontSize: 15.0),
                  textAlign: TextAlign.left)),
          const SizedBox(height: 10.0),
          widget.post.postUrl != ''
              ? SizedBox(
                  child: Image.network(
                    widget.post.postUrl.toString(),
                    fit: BoxFit.cover,
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(Icons.favorite, size: 15.0, color: Colors.red),
                  Text(' $likes'),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('$comments comments'),
                ],
              ),
            ],
          ),
          const Divider(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                style:
                    TextButton.styleFrom(foregroundColor: AppColors.blackColor),
                onPressed: handleLike,
                icon: isLike
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 20,
                      )
                    : const Icon(Icons.favorite_border, size: 20),
                label: const Text('Likes'),
              ),
              TextButton.icon(
                style:
                    TextButton.styleFrom(foregroundColor: AppColors.blackColor),
                onPressed: () {
                  showCommnet(context, widget.post, widget.user,
                      commentController, postComment);
                },
                icon: const Icon(
                  Icons.comment_outlined,
                  size: 24.0,
                  color: AppColors.blackColor,
                ),
                label: const Text('Comments'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

Future showCommnet(BuildContext context, Post post, UserModel user,
    TextEditingController commentController, postComment) {
  log(post.comments.length.toString());
  return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: 600,
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(post.postId)
                        .collection('comments')
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
                          snap: snapshot.data!.docs[index],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      ContactAvatar(url: user.photoUrl, size: 20),
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
                                hintText: 'Comment as ${user.username}',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => postComment(
                          user.uid,
                          user.fullName,
                          user.photoUrl,
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
      });
}
