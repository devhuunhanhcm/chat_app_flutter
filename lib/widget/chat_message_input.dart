import 'package:flutter/material.dart';

class MessageSendPart extends StatelessWidget {

  const MessageSendPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Flexible(
        child: TextField(
          style: TextStyle(fontSize: 16.0, color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Enter messages',
            labelStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.blue),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Xử lý sự kiện khi nhấn nút "Gửi"
                  },
                ),
                IconButton(
                  icon: Icon(Icons.emoji_emotions),
                  onPressed: () {
                    // Xử lý sự kiện khi nhấn nút biểu tượng cảm xúc
                  },
                ),
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    // Xử lý sự kiện khi nhấn nút ảnh
                  },
                ),
              ],
            ),
          ),
          maxLines: null,
        ),
      )



    );
  }
}
//Your all design is redy