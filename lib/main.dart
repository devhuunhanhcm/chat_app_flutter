import 'package:chat_app_flutter/config/routes/router.dart';
import 'package:chat_app_flutter/config/routes/routes.dart';
import 'package:chat_app_flutter/firebase/firebase_messaging.dart';
import 'package:chat_app_flutter/firebase_options.dart';
import 'package:chat_app_flutter/providers/user_provider.dart';
import 'package:chat_app_flutter/utils/style/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessagingService.initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
              create: (context) => UserProvider())
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: MyRouter.generateRoute,
            initialRoute: AppRoutes.authCheck,
            theme: ThemeData(
                fontFamily: 'Roboto',
                useMaterial3: true,
                brightness: Brightness.light,
                scaffoldBackgroundColor: AppColors.whiteColor,
                primaryColor: AppColors.primaryColor,
                elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        foregroundColor: AppColors.whiteColor,
                        backgroundColor: AppColors.primaryColor,
                        side: const BorderSide(
                            color: Colors.transparent, width: 2))))));
  }
}
