import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  String? id;
  Map<String, dynamic>? participants;
  String? lastMessage;
  DateTime? lastMessageTime;

  ChatRoom(
      {this.id, this.participants, this.lastMessage, this.lastMessageTime});

  static ChatRoom fromJson(Map<String, dynamic> json) {
    DateTime dateTime = DateTime.now();
    if (json["lastMessageTime"] != null) {
      Timestamp timestamp = json["lastMessageTime"];
      dateTime = timestamp.toDate();
    }
    return ChatRoom(
      id: json["id"] ?? '',
      participants: json["participants"] ?? '',
      lastMessage: json["lastMessage"] ?? '',
      lastMessageTime: dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "participants": participants,
      "lastMessage": lastMessage,
      "lastMessageTime": lastMessageTime
    };
  }
}
