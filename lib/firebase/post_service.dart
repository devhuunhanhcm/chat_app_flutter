import 'package:chat_app_flutter/firebase/storage_methods.dart';
import 'package:chat_app_flutter/models/post.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadPost(
      String description, Uint8List? file, UserModel user) async {
    String res = "Some error occurred";
    try {
      String photoUrl = '';
      if (file != null) {
        photoUrl =
            await StorageMethods().uploadImageToStorage('posts', file, true);
      }

      String postId = const Uuid().v1();
      Post post = Post(
        postId: postId,
        content: description,
        likes: [],
        comments: [],
        datePublished: DateTime.now(),
        uid: user.uid,
        fullName: user.fullName,
        postUrl: photoUrl,
        profImage: user.photoUrl,
      );

      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<List<Post>> getPost() async {
    List<Post> posts = [];

    await _firestore.collection("posts").get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          posts.add(Post.fromSnap(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return posts;
  }

  Future<List<Post>> getPostUserFollow() async {
    String uid = _auth.currentUser!.uid;
    DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
    List following = (snap.data()! as dynamic)['following'];
    following.add(uid);
    List<Post> posts = [];

    await _firestore
        .collection("posts")
        .where("uid", whereIn: following)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          posts.add(Post.fromSnap(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return posts;
  }

  Future<List> getUserFollowId() async {
    String uid = _auth.currentUser!.uid;
    DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
    List following = (snap.data()! as dynamic)['following'];
    following.add(uid);

    return following;
  }

  Future<List<Post>> getPostByUserId(String userId) async {
    List<Post> posts = [];

    await _firestore
        .collection("posts")
        .where("uid", isEqualTo: userId)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          posts.add(Post.fromSnap(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return posts;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String fullName, String photoUrl) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'photoUrl': photoUrl,
          'fullName': fullName,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });

        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
