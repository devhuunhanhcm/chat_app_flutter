import 'dart:developer';
import 'dart:typed_data';

import 'package:chat_app_flutter/firebase/auth_service.dart';
import 'package:chat_app_flutter/firebase/storage_methods.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:chat_app_flutter/providers/user_provider.dart';
import 'package:chat_app_flutter/utils/loading/loading_dialog.dart';
import 'package:chat_app_flutter/utils/loading/message_dialog.dart';
import 'package:chat_app_flutter/utils/style/app_colors.dart';
import 'package:chat_app_flutter/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  Uint8List? _file;

  @override
  void initState() {
    super.initState();
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a images'),
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

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  void udpate(String uid) async {
    Loading.showLoading(context);
    // start the loading

    try {
      String photoUrl = '';
      if (_file != null) {
        photoUrl =
            await StorageMethods().uploadImageToStorage('users', _file!, false);
      }
      // upload to storage and db
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'photoUrl': photoUrl,
        // Add other fields as needed
      });

      clearImage();
      Loading.hideLoading(context);
      MessageDialog.showMessage(
          context, "Update image successfull.", "Update images");
      update();
    } catch (err) {
      Loading.hideLoading(context);
      MessageDialog.showMessage(
          context, "Images is have error.Please try again.", "Post failed");
    }
  }

  update() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: _file != null
                            ? Image(
                                fit: BoxFit.cover, image: MemoryImage(_file!))
                            : user?.photoUrl == ""
                                ? const Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/images/default_avatar.jpg'))
                                : Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        user!.photoUrl.toString())),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _selectImage(context);
                  },
                  child: const CircleAvatar(
                    radius: 15,
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.whiteColor,
                    child: Icon(Icons.add_outlined),
                  ),
                )
              ],
            ),
            ReuseableRow(
                title: "Username",
                value: user!.username,
                iconData: Icons.person_2_outlined),
            ReuseableRow(
                title: "Full Name",
                value: user.fullName,
                iconData: Icons.person_2_outlined),
            ReuseableRow(
                title: "Phone",
                value: user.phone,
                iconData: Icons.phone_android_outlined),
            ReuseableRow(
                title: "Email",
                value: user.email,
                iconData: Icons.email_outlined),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton.icon(
                  onPressed: () {
                    udpate(user.uid);
                  },
                  icon: Icon(Icons.update_outlined),
                  label: const Text(
                    'Update',
                    style: TextStyle(fontSize: 20),
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}

class ReuseableRow extends StatelessWidget {
  final String title, value;
  final IconData iconData;

  const ReuseableRow(
      {super.key,
      required this.title,
      required this.value,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            leading: Icon(
              iconData,
              size: 30,
            ),
            trailing: Text(
              value,
              style: const TextStyle(fontSize: 16),
            )),
        Divider(
          color: AppColors.blackColor.withOpacity(0.4),
        )
      ],
    );
  }
}
