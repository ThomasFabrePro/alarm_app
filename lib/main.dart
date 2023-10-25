import 'package:alarm_app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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
  var permissionStatus = await Permission.notification.status;
  if (permissionStatus.isDenied) {
    await Permission.notification.request();
  }
  tz.initializeTimeZones();
  notificationService.initNotification();
  runApp(const MyApp());
}
