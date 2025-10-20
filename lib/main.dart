import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bops_mobile/src/app.dart';
import 'package:bops_mobile/src/services/notification_services.dart';
import 'package:bops_mobile/src/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'firebase_options.dart';

NotificationsServices notificationsServices = NotificationsServices();
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // try {
    //
    //   FirebaseMessaging.onBackgroundMessage(
    //       _firebaseMessagingBackgroundHandler);
    // } catch (e) {
    //   print("ERROR ENABLING BACKGROUND MESSAGE HANDLER");
    // }
    // try {
    //
    //   notificationsServices.enableForegroundMessagesListener();
    // } catch (e) {
    //   print("ERROR ENABLING FOREGROUND MESSAGE HANDLER");
    // }
  } catch (e) {
    print("Error initializing firebase");
  }
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox(Constants.BOX_NAME);
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => MyApp(),
  //   ),
  // );
  runApp(MyApp());
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   if (message.notification != null) {
//     await Firebase.initializeApp();
//     AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         actionType: ActionType.Default,
//         id: 10,
//         channelKey: 'basic_channel',
//         title: message.notification!.title!,
//         body: message.notification!.body!,
//         wakeUpScreen: true,
//       ),
//     );
//   }
//   return;
// }
