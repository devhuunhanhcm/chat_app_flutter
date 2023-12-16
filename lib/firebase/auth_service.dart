import 'dart:typed_data';

import 'package:chat_app_flutter/firebase/firebase_messaging.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:chat_app_flutter/utils/loading/loading_dialog.dart';
import 'package:chat_app_flutter/utils/loading/message_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseAuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;
  String get userId => _auth.currentUser!.uid;

  Future<User?> signUp(String username, String fullName, String email,
      String password, String phone, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserModel user = UserModel(
          username: username,
          fullName: fullName,
          uid: userCredential.user!.uid,
          photoUrl: "",
          email: email,
          bio: "",
          followers: [],
          following: [],
          phone: phone,
          pushToken: '',
          isOnline: false);

      await _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(user.toJson());
      return userCredential.user;
    } catch (e) {
      Loading.hideLoading(context);
      MessageDialog.showMessage(context, e.toString(), "Signup failed");
      return null;
    }
  }

  UserModel get defaultUser => UserModel(
      uid: '',
      username: '',
      fullName: '',
      email: '',
      phone: '',
      photoUrl: '',
      bio: '',
      followers: [],
      following: [],
      pushToken: '',
      isOnline: false);

  Future<UserModel> getUser() async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(user!.uid).get();
    if (documentSnapshot.exists) {
      await FirebaseMessagingService.updateActiveStatus(true, user!.uid);
      return UserModel.fromSnap(documentSnapshot);
    }
    return defaultUser;
  }

  Future<String> getCurrentUserId() async {
    User currentUser = _auth.currentUser!;
    return currentUser.uid;
  }

  Future<UserModel> getUserById(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(uid).get();

    return UserModel.fromSnap(documentSnapshot);
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      FirebaseMessagingService.updateActiveStatus(
          false, _auth.currentUser!.uid);
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<UserModel>> getListUserFollowing() async {
    List<UserModel> users = [];
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    var userSnap = userDoc.data() as Map<String, dynamic>;
    List following = userSnap["following"];

    await _firestore
        .collection('users')
        .where("uid", whereIn: following)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          users.add(UserModel.fromSnap(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return users;
  }

  Future<List<UserModel>> findUser(String query) async {
    List<UserModel> users = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('users')
        .orderBy('username')
        .startAt([query]).endAt([query + "\uf8ff"]).get();
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        // Convert each document snapshot to your user model
        UserModel user = UserModel.fromSnap(doc);
        print(user.username);
        users.add(user);
      }
    }
    print(users.toString());
    return users;
  }
}
