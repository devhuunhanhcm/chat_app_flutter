import 'package:chat_app_flutter/config/routes/routes.dart';
import 'package:chat_app_flutter/firebase/auth_service.dart';
import 'package:chat_app_flutter/firebase/chat_service.dart';
import 'package:chat_app_flutter/models/chat_room.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:chat_app_flutter/providers/user_provider.dart';
import 'package:chat_app_flutter/screens/ChatScreen.dart';
import 'package:chat_app_flutter/screens/ProfileScreen.dart';
import 'package:chat_app_flutter/utils/style/app_colors.dart';
import 'package:chat_app_flutter/widget/contact_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuthService _authService = FirebaseAuthService();
  final ChatService _chatService = ChatService();

  void followUser(followingId) async {
    await _authService.followUser(_auth.currentUser!.uid, followingId);
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Friends",
            style: TextStyle(color: AppColors.whiteColor),
          ),
          backgroundColor: AppColors.primaryColor,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.whiteColor,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.searchingScreen);
          },
          child: const Icon(Icons.search_outlined),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            children: [
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "Followings",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _firestore
                      .collection('users')
                      .doc(_auth.currentUser!.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }

                    var currentUser = UserModel.fromSnap(snapshot.data!);

                    return ListView.builder(
                      itemCount: currentUser.following.length,
                      itemBuilder: (context, index) {
                        String followingUserId = currentUser.following[index];

                        return FutureBuilder(
                          future: _firestore
                              .collection('users')
                              .doc(followingUserId)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                            if (!userSnapshot.hasData) {
                              return const SizedBox();
                            }

                            var followingUser =
                                UserModel.fromSnap(userSnapshot.data!);

                            return GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(32))),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        height: 350,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ListTile(
                                              leading: ContactAvatar(
                                                  url: followingUser.photoUrl,
                                                  size: 30),
                                              title: Text(
                                                followingUser.fullName,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              subtitle:
                                                  const Text('View my profile'),
                                              onTap: () {},
                                              trailing: const Icon(
                                                  Icons.change_circle_outlined),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.message_outlined,
                                                  size: 28),
                                              title: const Text("Chat",
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              onTap: () async {
                                                ChatRoom? chatroomModel =
                                                    await _chatService
                                                        .getChatroomModel(
                                                            followingUser);

                                                if (chatroomModel != null) {
                                                  Navigator.pop(context);
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return ChatScreen(
                                                      targetUser: followingUser,
                                                      currentUser: user!,
                                                      chatRoom: chatroomModel,
                                                    );
                                                  }));
                                                }
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.account_circle_outlined,
                                                  size: 28),
                                              title: const Text("View profile",
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return ProfileScreen(
                                                      uid: followingUser.uid);
                                                }));
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.remove_circle_outline,
                                                  size: 28),
                                              title: const Text("Unfollow",
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              onTap: () {
                                                followUser(followingUser.uid);
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.cancel_outlined,
                                                  size: 30),
                                              title: const Text("Cancel",
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              onTap: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: ListTile(
                                title: Text(
                                  followingUser.fullName,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.blackColor),
                                ),
                                subtitle: Text(
                                  followingUser.isOnline ? "Online" : "Offline",
                                  style: TextStyle(
                                      color: followingUser.isOnline
                                          ? Colors.green
                                          : Colors.grey),
                                ),
                                leading: ContactAvatar(
                                    url: followingUser.photoUrl, size: 30),
                                trailing: const Icon(Icons.more_horiz_outlined),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
