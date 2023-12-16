import 'dart:async';

import 'package:chat_app_flutter/config/routes/routes.dart';
import 'package:chat_app_flutter/firebase/auth_service.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:chat_app_flutter/utils/style/app_colors.dart';
import 'package:chat_app_flutter/widget/user_item_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchingScreen extends StatefulWidget {
  const SearchingScreen({super.key});

  @override
  _SearchingScreenState createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  List<String> contacts = [];
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _foundedUsers = [];

  Timer? _debouce;
  String searchText = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChange);
    getMyFollowContact();
    setState(() {});
  }

  getMyFollowContact() async {
    _foundedUsers = await _authService.getListUserFollowing();
  }

  _onSearchChange() {
    if (_debouce?.isActive ?? false) _debouce?.cancel();
    _debouce = Timer(const Duration(milliseconds: 500), () async {
      if (searchText != _searchController.text) {
        List<UserModel> users = await _authService
            .findUser(_searchController.text.trim().toLowerCase());
        setState(() {
          _foundedUsers = users;
        });
      }
      searchText = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Searching"),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                hintText: "Search",
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: Colors.grey, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide:
                      const BorderSide(width: 2, color: AppColors.primaryColor),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                child: ListView.builder(
                  itemCount: _foundedUsers.length,
                  itemBuilder: (context, index) {
                    return UserItem(
                        user: _foundedUsers[index],
                        currentUserId: FirebaseAuth.instance.currentUser!.uid);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.removeListener(_onSearchChange);
    _searchController.dispose();
    _debouce?.cancel();
  }
}
