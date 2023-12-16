import 'package:chat_app_flutter/config/routes/routes.dart';
import 'package:chat_app_flutter/screens/Authenticate.dart';
import 'package:chat_app_flutter/screens/CreatePostScreen.dart';
import 'package:chat_app_flutter/screens/FriendsScreen.dart';
import 'package:chat_app_flutter/screens/HomeScreen.dart';
import 'package:chat_app_flutter/screens/LoginScreen.dart';
import 'package:chat_app_flutter/screens/MyProfileScreen.dart';
import 'package:chat_app_flutter/screens/SearchingScreen.dart';
import 'package:chat_app_flutter/screens/SignUpScreen.dart';

import 'package:flutter/material.dart';

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.authCheck:
        return MaterialPageRoute(builder: (_) => Authenticate());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.homePage:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case AppRoutes.createPost:
        return MaterialPageRoute(builder: (_) => const CreatePostScreen());
      case AppRoutes.searchingScreen:
        return MaterialPageRoute(builder: (_) => const SearchingScreen());
      case AppRoutes.friendScreen:
        return MaterialPageRoute(builder: (_) => const FriendsScreen());
      case AppRoutes.myProfile:
        return MaterialPageRoute(builder: (_) => const MyProfileScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text("Not found Page 404.")),
                ));
    }
  }
}
