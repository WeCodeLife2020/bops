import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../utils/object_factory.dart';

class NotificationsServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;



  Future init() async {
    final settings = await _requestPermission();
    bool isNotificationEnabled =
        settings.authorizationStatus == AuthorizationStatus.authorized;
    ObjectFactory().appHive.putIsNotificationPermission(
        isNotificationPermission: isNotificationEnabled);
    if (kDebugMode) {
      print('Notification status: $isNotificationEnabled');
    }

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await AwesomeNotifications().initialize(
          'resource://mipmap/launcher_icon',
          [
            NotificationChannel(
              channelGroupKey: 'basic_channel_group',
              locked: false,
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              enableVibration: true,
              importance: NotificationImportance.Max,
            ),
          ],
          channelGroups: [
            NotificationChannelGroup(
                channelGroupKey: 'basic_channel_group',
                channelGroupName: 'Basic group')
          ],
          debug: true);
    } else {
      await _requestPermission();
    }
  }

  Future enableForegroundMessagesListener() async {
    _registerForegroundMessageHandler();
  }

  Future<NotificationSettings> _requestPermission() async {
    return await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        announcement: false);
  }

  void _registerForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      if (kDebugMode) {
        print(" --- foreground message received ---");
        print(remoteMessage.notification!.title);
        print(remoteMessage.notification!.body);
      }
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          actionType: ActionType.Default,
          id: 10,
          channelKey: 'basic_channel',
          title: remoteMessage.notification!.title!,
          body: remoteMessage.notification!.body!,
        ),
      );
    });
  }
}
