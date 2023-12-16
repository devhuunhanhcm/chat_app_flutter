import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageDialog {
  static void showMessage(BuildContext context, String message, String title) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(MessageDialog);
                  },
                  child: const Text("OK"))
            ],
          );
        });
  }
}
