import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? commentId;
  String? photoUrl;
  String? uid;
  String? fullName;
  String? text;
  DateTime? datePublished;

  Comment(
      {this.commentId,
      this.photoUrl,
      this.uid,
      this.text,
      this.fullName,
      this.datePublished});

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
      commentId: snapshot["commentId"] ?? '',
      uid: snapshot["uid"] ?? '',
      photoUrl: snapshot["photoUrl"] ?? '',
      text: snapshot["text"] ?? '',
      fullName: snapshot["fullName"] ?? '',
      datePublished: snapshot["datePublished"].toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "commentId": commentId,
      "uid": uid,
      "photoUrl": photoUrl,
      "text": text,
      "fullName": fullName,
      "datePublished": datePublished,
    };
  }
}
