import 'dart:typed_data';
import 'package:chat_app_flutter/firebase/post_service.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:chat_app_flutter/providers/user_provider.dart';
import 'package:chat_app_flutter/screens/HomeScreen.dart';
import 'package:chat_app_flutter/utils/loading/loading_dialog.dart';
import 'package:chat_app_flutter/utils/loading/message_dialog.dart';
import 'package:chat_app_flutter/utils/style/app_typography.dart';
import 'package:chat_app_flutter/utils/toast/toast.dart';
import 'package:chat_app_flutter/utils/utils.dart';
import 'package:chat_app_flutter/widget/contact_avatar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  Uint8List? _file;
  FocusNode writingTextFocus = FocusNode();
  TextEditingController _writingTextController = TextEditingController();
  PostService postService = PostService();

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImages(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImages(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _writingTextController.dispose();
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  void postImage(UserModel user) async {
    Loading.showLoading(context);
    // start the loading
    try {
      // upload to storage and db
      String res = await postService.uploadPost(
          _writingTextController.text, _file, user);

      Loading.hideLoading(context);
      if (res == "success") {
        showToast(message: "Post successfully!!");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const HomeScreen(
                    tab: 2,
                  )),
        );
        clearImage();
      }
    } catch (err) {
      Loading.hideLoading(context);
      MessageDialog.showMessage(
          context, "Images is have error.Please try again.", "Post failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
        actions: [
          ElevatedButton(
            onPressed: () {
              postImage(user!);
            },
            child: Icon(Icons.send),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  ContactAvatar(url: user!.photoUrl, size: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(
                      user.fullName,
                      style: MyTextStyle.textField
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            TextFormField(
              autofocus: true,
              focusNode: writingTextFocus,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Writing anything.',
              ),
              controller: _writingTextController,
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: null,
            ),
            _file != null
                ? Stack(children: [
                    SizedBox(
                      height: 400,
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter,
                          image: MemoryImage(_file!),
                        )),
                      ),
                    ),
                    Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                            onPressed: () {
                              clearImage();
                            },
                            icon: Icon(Icons.close)))
                  ])
                : Container(),
            _file == null
                ? Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.photo_library_outlined,
                            color: Colors.lightGreen,
                          ),
                          title: Text("Images/video",
                              style: MyTextStyle.bodyTextStyle
                                  .copyWith(fontSize: 17)),
                          onTap: () {
                            _selectImage(context);
                          },
                        ),
                        ListTile(
                            leading: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.pinkAccent,
                            ),
                            title: Text("Camera",
                                style: MyTextStyle.bodyTextStyle
                                    .copyWith(fontSize: 17)),
                            onTap: () {}),
                        ListTile(
                            leading: const Icon(
                              Icons.add_location_alt_outlined,
                              color: Colors.blueAccent,
                            ),
                            title: Text("Location",
                                style: MyTextStyle.bodyTextStyle
                                    .copyWith(fontSize: 17)),
                            onTap: () {}),
                      ],
                    ),
                  )
                : const Padding(padding: EdgeInsets.all(0))
          ],
        ),
      ),
    );
  }
}
