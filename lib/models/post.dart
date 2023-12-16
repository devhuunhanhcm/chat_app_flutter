import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String content;
  final String uid;
  final String fullName;
  final dynamic likes;
  final dynamic comments;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;

  const Post({
    required this.content,
    required this.uid,
    required this.fullName,
    required this.likes,
    required this.postId,
    required this.comments,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    Timestamp snapshotDate = snapshot["datePublished"];
    return Post(
        postId: snapshot["postId"] ?? '',
        postUrl: snapshot['postUrl'] ?? '',
        content: snapshot["description"] ?? '',
        likes: snapshot["likes"] ?? [],
        comments: snapshot["comments"] ?? [],
        datePublished: snapshotDate.toDate() ?? DateTime.now(),
        uid: snapshot["uid"] ?? '',
        fullName: snapshot["fullName"] ?? '',
        profImage: snapshot['profImage'] ?? '');
  }

  Map<String, dynamic> toJson() => {
        "postId": postId,
        'postUrl': postUrl,
        "description": content,
        "likes": likes,
        "comments": comments,
        "datePublished": datePublished,
        "uid": uid,
        "fullName": fullName,
        'profImage': profImage
      };
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(datePublished);
    if (difference.inHours >= 24) {
      final days = difference.inDays;
      return '$days day${days > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    }
  }
}
