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
    return Column(
      crossAxisAlignment: isMe ?  CrossAxisAlignment.end  : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: CustomPaint(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .7,
              ),
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
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10,left: 10,bottom: 25,right: 20),
                    child: Text(
                      message,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontSize: 18 ,
                          color: isMe ? AppColors.whiteColor : AppColors.primaryText
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 5,
                      right: 10,
                      child: Text(messageTimeInDay(messageTime),textAlign: TextAlign.left, style: TextStyle(fontSize: 10,color: isMe ? AppColors.whiteColor : AppColors.primaryText),))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
