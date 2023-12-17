import 'package:chat_app_flutter/firebase/auth_service.dart';
import 'package:chat_app_flutter/models/post.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:chat_app_flutter/providers/user_provider.dart';
import 'package:chat_app_flutter/utils/style/app_colors.dart';
import 'package:chat_app_flutter/widget/contact_avatar.dart';
import 'package:chat_app_flutter/widget/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;

    const List<Widget> tabs = [
      Tab(
        icon: Icon(
          Icons.home,
          color: Colors.grey,
        ),
      ),
      Tab(
        icon: Icon(
          Icons.video_collection,
          color: Colors.grey,
        ),
      ),
      Tab(
        icon: Icon(
          Icons.bookmark,
          color: Colors.grey,
        ),
      ),
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          profileHeaderWidget(context, widget.uid, user!.uid),
          const TabBar(tabs: tabs),
          SizedBox(
            height: 1000,
            child: TabBarView(
              children: [
                PostList(
                  uid: widget.uid,
                  currentUser: user!,
                ),
                const SizedBox(),
                const SizedBox(),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

Widget profileHeaderWidget(
    BuildContext context, String uid, String currentUserId) {
  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(color: Colors.white),
    child: Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 10),
      child: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
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
                height: 20,
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
                  infoWidget("Follows", userData.followers.length.toString()),
                  infoWidget("Following", userData.following.length.toString()),
                  infoWidget("Post", userData.postNum.toString()),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              currentUserId != userData.uid
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        userData.followers.contains(currentUserId)
                            ? ElevatedButton(
                                onPressed: () => {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[200],
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)))),
                                child: const Text(
                                  "Unfollow",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.blackColor),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () => {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)))),
                                child: const Text(
                                  "Follow",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.whiteColor),
                                ),
                              ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                    )
                  : const SizedBox(),
              const Divider(
                height: 10,
                thickness: 0.6,
              ),
            ]),
          );
        },
      ),
    ),
  );
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

class PostList extends StatelessWidget {
  final String uid;
  final UserModel currentUser;
  const PostList({super.key, required this.uid, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where("uid", isEqualTo: uid)
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
            physics: const NeverScrollableScrollPhysics(),
            itemCount: postDocs.length,
            itemBuilder: (context, index) {
              Post post = Post.fromSnap(postDocs[index]);
              return PostCard(post: post, user: currentUser);
            },
          );
        }
      },
    );
  }
}
