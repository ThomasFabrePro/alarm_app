import 'package:alarm_app/services/firebase_helper.dart';
import 'package:alarm_app/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  var message = await FirebaseMessaging.instance.getInitialMessage();
  var data = message?.data;
  print('🔵firebase messaging payload : ${message?.data}');
  print('🔵firebase messaging payload : ${data}');
  print("Handling a background message: ${message?.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService notificationService = NotificationService();
  notificationService.initNotification();
//!test
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  var token = await messaging.getToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  print('🔵User granted permission: ${settings.authorizationStatus}');
  print('🔵firebasemessaging token : $token');
  notificationService.showNotification(
      title: 'TESTHelloWorld', body: 'TESTHelloWorld');
  // await FirebaseHelper.sendNotification(
  //     title: 'HelloWorld', body: 'HelloWorld', token: token!);
//!end test

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));
}
