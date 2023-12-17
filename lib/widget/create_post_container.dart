import 'package:chat_app_flutter/config/routes/routes.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:flutter/material.dart';

class CreatePostContainer extends StatelessWidget {
  final UserModel? currentUser;

  const CreatePostContainer({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    void createNewPost() {
      Navigator.pushNamed(context, AppRoutes.createPost);
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 30),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/default_avatar.jpg'),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.createPost);
                        },
                        child: const Text(
                          "What\'s on your mind?.",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )),
                  ))
                ],
              ),
              const Divider(height: 10.0, thickness: 0.5),
              Container(
                height: 40.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () => print('Live'),
                      icon: const Icon(
                        Icons.videocam_outlined,
                        color: Colors.red,
                      ),
                      label: const Text('Video'),
                    ),
                    const VerticalDivider(width: 8.0),
                    TextButton.icon(
                      onPressed: () => print('Photo'),
                      icon: const Icon(
                        Icons.photo_library_outlined,
                        color: Colors.lightGreen,
                      ),
                      label: const Text('Photo'),
                    ),
                    const VerticalDivider(width: 8.0),
                    TextButton.icon(
                      onPressed: () => print('Room'),
                      icon: const Icon(
                        Icons.photo_album_outlined,
                        color: Colors.pinkAccent,
                      ),
                      label: const Text('Album'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
