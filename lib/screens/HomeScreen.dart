import 'dart:developer';

import 'package:chat_app_flutter/firebase/auth_service.dart';
import 'package:chat_app_flutter/firebase/firebase_messaging.dart';
import 'package:chat_app_flutter/providers/user_provider.dart';
import 'package:chat_app_flutter/screens/AccountScreen.dart';
import 'package:chat_app_flutter/screens/DiscoveryScreen.dart';
import 'package:chat_app_flutter/screens/FriendsScreen.dart';
import 'package:chat_app_flutter/screens/PostScreen.dart';
import 'package:chat_app_flutter/screens/MessageScreen.dart';
import 'package:chat_app_flutter/utils/style/app_colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final int tab;

  const HomeScreen({super.key, this.tab = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void initState() {
    addData();
    setState(() {
      index = widget.tab;
    });
    super.initState();
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (_authService.user != null) {
        if (message.toString().contains('resume')) {
          FirebaseMessagingService.updateActiveStatus(
              true, _authService.userId);
        }
        if (message.toString().contains('pause')) {
          FirebaseMessagingService.updateActiveStatus(
              false, _authService.userId);
        }
      }

      return Future.value(message);
    });
  }

  static const screens = [
    MessageScreen(),
    FriendsScreen(),
    PostScreen(),
    AccountScreen(),
  ];

  addData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Colors.grey, width: 0, style: BorderStyle.solid))),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.transparent,
            labelTextStyle: MaterialStateProperty.all(const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor)),
          ),
          child: NavigationBar(
            height: 70,
            backgroundColor: Colors.white60,
            selectedIndex: index,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: const [
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.message,
                  color: AppColors.primaryColor,
                ),
                icon: Icon(Icons.message_outlined),
                label: "Message",
              ),
              NavigationDestination(
                  selectedIcon:
                      Icon(Icons.contact_page, color: AppColors.primaryColor),
                  icon: Icon(Icons.contact_page_outlined),
                  label: "Friends"),
              NavigationDestination(
                  selectedIcon:
                      Icon(Icons.watch_later, color: AppColors.primaryColor),
                  icon: Icon(Icons.watch_later_outlined),
                  label: "Post"),
              NavigationDestination(
                  selectedIcon:
                      Icon(Icons.account_circle, color: AppColors.primaryColor),
                  icon: Icon(Icons.account_circle_outlined),
                  label: "Me"),
            ],
            onDestinationSelected: (index) {
              setState(() => this.index = index);
            },
          ),
        ),
      ),
      body: screens[index],
    );
  }
}
