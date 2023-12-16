import 'package:chat_app_flutter/utils/style/app_colors.dart';
import 'package:chat_app_flutter/utils/utils.dart';
import 'package:flutter/material.dart';

class ChatMessageItem extends StatelessWidget {
  final bool isMe;
  final String message;
  final String messageTime;

  const ChatMessageItem({super.key, required this.isMe, required this.message, required this.messageTime});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: isMe ? const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ) : const BorderRadius.only(
            topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12)
          ),
          color: isMe ? AppColors.primaryColor : AppColors.backgroundWhite,

        ),
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(message,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: isMe ? AppColors.whiteColor : AppColors.primaryText),textAlign: TextAlign.start,),
            Text(messageTimeInDay(messageTime),style: TextStyle(fontSize: 10,color: AppColors.secondaryText),)
          ],
        ),
      ),
    );
  }
}
