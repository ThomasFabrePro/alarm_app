import 'package:alarm_app/services/notification_service.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;
import 'src/app.dart';
import 'package:logger/logger.dart';

Logger logger = Logger(
  printer: PrettyPrinter(
    colors: true,
  ),
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService notificationService = NotificationService();

  tz.initializeTimeZones();
  notificationService.initNotification();
  runApp(const MyApp());
}
