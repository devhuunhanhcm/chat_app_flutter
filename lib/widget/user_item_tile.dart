import 'package:chat_app_flutter/firebase/auth_service.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:chat_app_flutter/utils/style/app_colors.dart';
import 'package:chat_app_flutter/widget/contact_avatar.dart';
import 'package:chat_app_flutter/widget/follow_button.dart';
import 'package:flutter/material.dart';

class UserItem extends StatefulWidget {
  final UserModel user;
  final String currentUserId;

  const UserItem({super.key, required this.user, required this.currentUserId});

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  FirebaseAuthService _authService = FirebaseAuthService();
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isFollowing = widget.user.followers.contains(widget.currentUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: ListTile(
        leading: ContactAvatar(url: widget.user.photoUrl, size: 30),
        title: Text(
          widget.user.fullName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        trailing: isFollowing
            ? FollowButton(
                text: 'Unfollow',
                backgroundColor: AppColors.backgroundWhite,
                textColor: AppColors.secondaryText,
                function: () async {
                  await _authService.followUser(
                      widget.currentUserId, widget.user.uid);
                  setState(() {
                    isFollowing = false;
                    followers--;
                  });
                },
              )
            : FollowButton(
                text: 'Follow',
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                function: () async {
                  await _authService.followUser(
                      widget.currentUserId, widget.user.uid);
                  setState(() {
                    isFollowing = true;
                    followers++;
                  });
                },
              ),
        onTap: () {
          // Add functionality when a friend is tapped
          // For example, you can navigate to a chat screen
          // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(filteredFriends[index])));
        },
      ),
    );
  }
}
