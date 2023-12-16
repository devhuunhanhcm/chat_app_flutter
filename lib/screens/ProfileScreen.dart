import 'package:chat_app_flutter/firebase/auth_service.dart';
import 'package:chat_app_flutter/firebase/post_service.dart';
import 'package:chat_app_flutter/models/post.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:chat_app_flutter/utils/style/app_colors.dart';
import 'package:chat_app_flutter/widget/contact_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel userData;
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  final FirebaseAuthService _authService = FirebaseAuthService();
  final PostService _postService = PostService();

  getData() async {
    try {
      UserModel user = await _authService.getUserById(widget.uid);

      List<Post> postSnap = await _postService.getPostByUserId(widget.uid);

      setState(() {
        postLen = postSnap.length;
        userData = user;
        followers = user.followers.length;
        following = user.following.length;
        isFollowing =
            user.followers.contains(FirebaseAuth.instance.currentUser!.uid);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var userData = UserModel.fromSnap(snapshot.data!);

          return Center(
            child: Column(children: [
              ContactAvatar(url: userData.photoUrl, size: 56),
              const SizedBox(
                height: 12,
              ),
              Text(
                userData.fullName,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Text(
                userData.email,
                style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  infoWidget("Follows", followers.toString()),
                  infoWidget("Following", following.toString()),
                  infoWidget("Post", followers.toString()),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => {},
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side: BorderSide(color: Colors.red)))),
                    child: const Text(
                      "Follow",
                      style:
                          TextStyle(fontSize: 20, color: AppColors.whiteColor),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  ElevatedButton(
                    onPressed: () => {},
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side: BorderSide(color: Colors.red)))),
                    child: const Text(
                      "Message",
                      style:
                          TextStyle(fontSize: 20, color: AppColors.whiteColor),
                    ),
                  )
                ],
              ),
              const Divider(
                height: 18,
                thickness: 0.6,
              ),
              Expanded(child: Container())
            ]),
          );
        },
      ),
    );
  }
}

Widget infoWidget(String title, String state) {
  return Expanded(
      child: Column(
    children: [
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      Text(
        state,
        style: const TextStyle(fontSize: 18),
      ),
    ],
  ));
}
