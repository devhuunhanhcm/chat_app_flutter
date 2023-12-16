import 'dart:developer';

import 'package:chat_app_flutter/firebase/auth_service.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  UserModel? _user;

  UserModel? get getUser => _user;

  Future<void> refreshUser() async {
    log("fetch user info");
    UserModel userDetails = await _authService.getUser();

    _user = userDetails;
    notifyListeners();
  }
}
