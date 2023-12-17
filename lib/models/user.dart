import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String username;
  final String fullName;
  final String phone;
  final String email;
  final String uid;
  final String photoUrl;
  final String bio;
  final List followers;
  final List following;
  final String pushToken;
  final bool isOnline;
  final int postNum;

  UserModel(
      {required this.uid,
      required this.username,
      required this.fullName,
      required this.email,
      required this.phone,
      required this.photoUrl,
      required this.bio,
      required this.followers,
      required this.following,
      required this.pushToken,
      required this.postNum,
      required this.isOnline});

  Map<String, dynamic> toJson() => {
        "username": username,
        "fullName": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "phone": phone,
        "bio": bio,
        "followers": followers,
        "following": following,
        "pushToken": pushToken,
        "isOnline": isOnline,
        "postNum": postNum
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    UserModel user = UserModel(
      username: snapshot["username"] ?? '',
      uid: snapshot["uid"] ?? '',
      fullName: snapshot["fullName"] ?? '',
      email: snapshot["email"] ?? '',
      photoUrl: snapshot["photoUrl"] ?? '',
      bio: snapshot["bio"] ?? '',
      followers: snapshot["followers"] ?? [],
      following: snapshot["following"] ?? [],
      phone: snapshot["phone"] ?? '',
      isOnline: snapshot["isOnline"] ?? false,
      postNum: snapshot["postNum"] ?? 0,
      pushToken: snapshot["pushToken"] ?? '',
    );

    return user;
  }
}
