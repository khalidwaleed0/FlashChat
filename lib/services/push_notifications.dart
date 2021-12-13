import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'notifications.dart';

class PushNotifications {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  PushNotifications._privateConstructor();
  static final PushNotifications _instance = PushNotifications._privateConstructor();
  factory PushNotifications() {
    return _instance;
  }

  void foregroundListen() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        Notifications().push(message: message.notification!.body!);
      }
    });
  }
}
