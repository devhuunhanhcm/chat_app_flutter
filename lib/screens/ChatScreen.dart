import 'package:chat_app_flutter/firebase/chat_service.dart';
import 'package:chat_app_flutter/models/chat_room.dart';
import 'package:chat_app_flutter/models/message.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:chat_app_flutter/utils/utils.dart';
import 'package:chat_app_flutter/utils/style/app_colors.dart';
import 'package:chat_app_flutter/widget/chat_message_item.dart';
import 'package:chat_app_flutter/widget/contact_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final UserModel targetUser;
  final UserModel currentUser;
  final ChatRoom chatRoom;

  const ChatScreen(
      {super.key,
      required this.targetUser,
      required this.chatRoom,
      required this.currentUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        title: Row(
          children: [
            ContactAvatar(url: widget.targetUser.photoUrl, size: 25),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    widget.targetUser.fullName.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                ),
                widget.targetUser.isOnline
                    ? const Text(
                        "Online",
                        style:
                            TextStyle(color: Colors.greenAccent, fontSize: 12),
                      )
                    : Text(
                        "Offline",
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      )
              ],
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.call,
                color: AppColors.whiteColor,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.video_call,
                color: AppColors.whiteColor,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.help,
                color: AppColors.whiteColor,
              ))
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(widget.chatRoom.id)
                        .collection("messages")
                        .orderBy("createdAt", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          QuerySnapshot dataSnapshot =
                              snapshot.data as QuerySnapshot;

                          return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMessage =
                                  MessageModel.fromJson(dataSnapshot.docs[index]
                                      .data() as Map<String, dynamic>);

                              bool isSameDate = false;
                              String? newDate = '';
                              String messageTime = currentMessage
                                  .createAt!.microsecondsSinceEpoch
                                  .toString();
                              final DateTime date =
                                  returnDateAndTimeFormat(messageTime);

                              if (index == 0 && dataSnapshot.docs.length == 1) {
                                newDate = groupMessageDateAndTime(messageTime)
                                    .toString();
                              } else if (index ==
                                  dataSnapshot.docs.length - 1) {
                                newDate = groupMessageDateAndTime(messageTime)
                                    .toString();
                              } else {
                                MessageModel nextMessage =
                                    MessageModel.fromJson(
                                        dataSnapshot.docs[index + 1].data()
                                            as Map<String, dynamic>);
                                final DateTime date =
                                    returnDateAndTimeFormat(messageTime);
                                final DateTime prevDate =
                                    returnDateAndTimeFormat(nextMessage
                                        .createAt!.microsecondsSinceEpoch
                                        .toString());

                                isSameDate = date.isAtSameMomentAs(prevDate);

                                MessageModel prevMessage;
                                if (index > 0) {
                                  prevMessage = MessageModel.fromJson(
                                      dataSnapshot.docs[index - 1].data()
                                          as Map<String, dynamic>);
                                } else {
                                  prevMessage = currentMessage;
                                }
                                newDate = isSameDate
                                    ? ''
                                    : groupMessageDateAndTime(prevMessage
                                            .createAt!.microsecondsSinceEpoch
                                            .toString())
                                        .toString();
                              }

                              return Container(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      if (newDate.isNotEmpty)
                                        Center(
                                            child: Container(
                                                child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(newDate),
                                        ))),
                                      ChatMessageItem(
                                          isMe: currentMessage.sender ==
                                              widget.currentUser.uid,
                                          message:
                                              currentMessage.text.toString(),
                                          messageTime: currentMessage
                                              .createAt!.microsecondsSinceEpoch
                                              .toString()),
                                    ],
                                  ));
                            },
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                                "An error occured! Please check your internet connection."),
                          );
                        } else {
                          return const Center(
                            child: Text("Say hi to your new friend"),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.grey[200],
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter message"),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _chatService.sendMessage(
                            widget.chatRoom,
                            widget.currentUser,
                            widget.targetUser,
                            _messageController.text);
                        setState(() {
                          _messageController.text = '';
                        });
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
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
