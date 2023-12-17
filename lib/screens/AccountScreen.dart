import 'package:chat_app_flutter/config/routes/routes.dart';
import 'package:chat_app_flutter/firebase/auth_service.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:chat_app_flutter/providers/user_provider.dart';
import 'package:chat_app_flutter/screens/ProfileScreen.dart';
import 'package:chat_app_flutter/screens/ProfileScreen.dart';
import 'package:chat_app_flutter/utils/style/app_colors.dart';
import 'package:chat_app_flutter/utils/toast/toast.dart';
import 'package:chat_app_flutter/widget/contact_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.search_outlined, color: AppColors.whiteColor),
          onPressed: () {},
        ),
        backgroundColor: AppColors.primaryColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.qr_code_scanner,
              color: AppColors.whiteColor,
            ),
            tooltip: 'QRcode',
            onPressed: () {
              print("QRcode");
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: AppColors.whiteColor),
            tooltip: 'Settings',
            onPressed: () {
              print("Settings");
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            ListTile(
              leading: ContactAvatar(url: user?.photoUrl ?? '', size: 30),
              title: Text(
                user?.fullName ?? '',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              subtitle: const Text('View my profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProfileScreen(uid: user?.uid ?? '');
                }));
              },
              trailing: const Icon(Icons.change_circle_outlined),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text("Settings my profile"),
              subtitle: const Text('Update your profile.'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.myProfile);
              },
              trailing: const Icon(Icons.navigate_next_outlined),
            ),
            ListTile(
              leading: const Icon(Icons.cloud_outlined),
              title: const Text("My Cloud"),
              subtitle: const Text('Keep important messages'),
              onTap: () {},
              trailing: const Icon(Icons.navigate_next_outlined),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_outlined),
              title: const Text("Data on device"),
              subtitle: const Text('Manager your Chat data'),
              onTap: () {},
              trailing: const Icon(Icons.navigate_next_outlined),
            ),
            ListTile(
              leading: const Icon(Icons.shield_outlined),
              title: const Text("Account and security"),
              onTap: () {},
              trailing: const Icon(Icons.navigate_next_outlined),
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text("Privary"),
              onTap: () {},
              trailing: const Icon(Icons.navigate_next_outlined),
            ),
            ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await _authService.logout();
                    Navigator.pushNamed(context, AppRoutes.login);
                  } catch (e) {
                    showToast(message: "Logout failure.");
                  }
                },
                icon: const Icon(Icons.logout_outlined),
                label: const Text('Logout')),
          ],
        ),
      ),
    );
  }
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
