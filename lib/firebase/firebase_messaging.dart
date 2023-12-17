import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app_flutter/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';

class FirebaseMessagingService {
  static final _fireBaseMessaging = FirebaseMessaging.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> initNotifications() async {
    await _fireBaseMessaging.requestPermission();
    final fcmToken = await _fireBaseMessaging.getToken();

    log(fcmToken.toString());
  }

  static Future<String> getFirebaseMessageToken() async {
    await _fireBaseMessaging.requestPermission();
    String fcmToken =
        await _fireBaseMessaging.getToken().then((token) => token.toString());
    return fcmToken;
  }

  static Future<void> updateActiveStatus(bool isOnline, String userId) async {
    try {
      String token = await getFirebaseMessageToken();
      await _firestore.collection('users').doc(userId).update({
        'isOnline': isOnline,
        'pushToken': token,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> sendPushNotification(
      UserModel userModel, String msg) async {
    try {
      final body = {
        "to": userModel.pushToken,
        "notification": {
          "title": userModel.fullName, //our name should be send
          "body": msg,
          "android_channel_id": "chats"
        },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAtQqppaU:APA91bEVNBU9J-vSkY1n7FhcZPCjVvxwfpg7cyDtjWY1WeFGYDtdad2sZsIDXuPhSlxasB6zvUxkC1lU700zW0oLKaZIZIubeGhGnYoxlKBjU_HxfrtL-EvIRStAcHuRvDNDAJpdE0BD'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }
}
