import 'package:chat_app_flutter/screens/HomeScreen.dart';
import 'package:chat_app_flutter/screens/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Authenticate extends StatelessWidget {
  Authenticate({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return HomeScreen(
        tab: 0,
      );
    } else {
      return LoginScreen();
    }
  }
}
