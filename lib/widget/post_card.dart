// ignore_for_file: use_build_context_synchronously

import 'package:chat_app_flutter/firebase/post_service.dart';
import 'package:chat_app_flutter/models/post.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:chat_app_flutter/screens/CommentsScreen.dart';
import 'package:chat_app_flutter/screens/HomeScreen.dart';
import 'package:chat_app_flutter/utils/style/app_colors.dart';
import 'package:chat_app_flutter/utils/toast/toast.dart';
import 'package:chat_app_flutter/widget/contact_avatar.dart';

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

  @override
  void initState() {
    super.initState();
    setState(() {
      likes = widget.post.likes.length;
      isLike = widget.post.likes.contains(widget.user.uid);
    });
  }

  @override
  void dispose() {
    super.dispose();
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
          Text(widget.post.content,
              style: const TextStyle(fontSize: 15.0),
              textAlign: TextAlign.left),
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
                  Text('${widget.post.commentNum} comments'),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                            user: widget.user, post: widget.post)),
                  );
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
