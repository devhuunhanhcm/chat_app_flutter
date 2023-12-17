import 'dart:developer';

import 'package:chat_app_flutter/config/routes/routes.dart';
import 'package:chat_app_flutter/firebase/post_service.dart';
import 'package:chat_app_flutter/models/post.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:chat_app_flutter/providers/user_provider.dart';
import 'package:chat_app_flutter/utils/style/app_colors.dart';
import 'package:chat_app_flutter/widget/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final PostService _postService = PostService();
  List following = [''];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addData();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  addData() async {
    List followingId = await _postService.getUserFollowId();
    log(followingId.toString());
    if (mounted) {
      setState(() {
        following = followingId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        title: TextFormField(
          style: const TextStyle(color: AppColors.whiteColor, fontSize: 18),
          controller: _searchController,
          cursorColor: AppColors.whiteColor,
          decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Searching...",
              hintStyle: TextStyle(color: AppColors.whiteColor, fontSize: 18)),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, size: 32, color: AppColors.whiteColor),
            tooltip: 'Create new post',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.createPost);
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where("uid", whereIn: following)
            .orderBy("createAt", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error:'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No posts to display.'));
          } else {
            // Extract and display posts
            List<DocumentSnapshot> postDocs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: postDocs.length,
              itemBuilder: (context, index) {
                Post post = Post.fromSnap(postDocs[index]);
                return user != null
                    ? PostCard(post: post, user: user)
                    : const SizedBox();
              },
            );
          }
        },
      ),
    );
  }
}
