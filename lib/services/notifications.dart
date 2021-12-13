import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class Notifications {
  Notifications._privateConstructor();
  static final Notifications _instance = Notifications._privateConstructor();
  factory Notifications() {
    return _instance;
  }

  final String busyLine = 'مش فاضي + روح شوف وراك ايه يا علق';

  void initialize() {
    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        'resource://drawable/logo',
        [
          NotificationChannel(
            channelKey: 'basic_channel2',
            channelName: 'Flash Chat',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Colors.blue,
            ledColor: Colors.white,
            playSound: true,
            soundSource: 'resource://raw/res_notification_sound',
            enableVibration: false,
            importance: NotificationImportance.Max,
          ),
        ]);
    notificationListener();
  }

  void push({String? sender, required String message}) {
    sender ??= '';
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        notificationLayout: NotificationLayout.BigText,
        id: 141,
        channelKey: 'basic_channel2',
        title: 'General Chat',
        body: '$sender: $message',
        //displayOnForeground: false,
      ),
      actionButtons: [
        NotificationActionButton(key: 'busy', label: busyLine),
        NotificationActionButton(key: 'input', label: 'Reply..', buttonType: ActionButtonType.InputField),
      ],
    );
  }

  void notificationListener() {
    AwesomeNotifications().actionStream.listen((event) {
      if (event.buttonKeyPressed == 'input')
        sendMessage(event.buttonKeyInput);
      else
        sendMessage(busyLine);
    });
  }
}
