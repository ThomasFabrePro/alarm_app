import 'package:alarm_app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService notificationService = NotificationService();

  tz.initializeTimeZones();
  notificationService.initNotification();
//!test

  // notificationService.showNotification(
  //     title: 'TESTHelloWorld', body: 'TESTHelloWorld');
  DateTime notificationDateTime =
      DateTime.now().add(const Duration(seconds: 20));
  notificationService.scheduleNotification(
      title: 'HelloWorld',
      body: '${notificationDateTime.toString()}',
      dateTime: notificationDateTime);
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
