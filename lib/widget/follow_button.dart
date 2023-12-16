import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final String text;
  final Color textColor;

  const FollowButton(
      {Key? key,
      required this.backgroundColor,
      required this.text,
      required this.textColor,
      this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 110,
        child: ElevatedButton(
          onPressed: function,
          style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor, foregroundColor: textColor),
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 14),
          ),
        ));
  }
}
