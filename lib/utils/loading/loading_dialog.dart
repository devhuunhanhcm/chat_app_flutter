import 'package:flutter/material.dart';

class Loading {
  static void showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
  }
  static void hideLoading(BuildContext context){
    Navigator.of(context).pop(Loading);
  }
}
