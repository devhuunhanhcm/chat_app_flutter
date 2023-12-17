import 'package:chat_app_flutter/firebase/firebase_messaging.dart';
import 'package:chat_app_flutter/models/chat_room.dart';
import 'package:chat_app_flutter/models/message.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ChatRoom?> getChatroomModel(UserModel targetUser) async {
    ChatRoom? chatRoom;
    String currentUserId = _auth.currentUser!.uid;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.$currentUserId", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var docData = snapshot.docs[0].data();
      ChatRoom existingChatroom =
          ChatRoom.fromJson(docData as Map<String, dynamic>);
      chatRoom = existingChatroom;
    } else {
      String chatRoomId = const Uuid().v1();
      ChatRoom newChatroom = ChatRoom(
          id: chatRoomId,
          lastMessage: "",
          participants: {
            currentUserId.toString(): true,
            targetUser.uid.toString(): true,
          },
          lastMessageTime: null);

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;
    }
    return chatRoom;
  }

  void sendMessage(ChatRoom chatRoom, UserModel sender, UserModel targetUser,
      String message) async {
    String msg = message.trim();

    if (msg != "") {
      String messageId = const Uuid().v1();
      MessageModel newMessage = MessageModel(
          id: messageId,
          sender: sender.uid,
          createAt: DateTime.now(),
          text: msg,
          seen: false);

      await _firestore
          .collection("chatrooms")
          .doc(chatRoom.id)
          .collection("messages")
          .doc(newMessage.id)
          .set(newMessage.toMap());

      chatRoom.lastMessage = msg;
      chatRoom.lastMessageTime = DateTime.now();

      FirebaseMessagingService.sendPushNotification(targetUser, msg);

      await _firestore
          .collection("chatrooms")
          .doc(chatRoom.id)
          .set(chatRoom.toMap());
    }
  }
}
