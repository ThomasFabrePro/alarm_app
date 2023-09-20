import 'package:alarm_app/services/database_helper.dart';
import 'package:alarm_app/services/notification_service.dart';

/// A placeholder class that represents an entity or model.
class AlarmItem {
  AlarmItem(this.id,
      {required this.title,
      required this.description,
      required this.day,
      required this.hourMinute,
      this.recurrencyInDays = 0,
      this.isOld = true});
  final int id;
  String title;
  String description;
  String day;
  String hourMinute;
  int recurrencyInDays;
  bool isOld;

  // set updateTitle(String title) {
  //   this.title = title;
  //   dbUpdate();
  // }

  String get timeToDisplay {
    return "$day $hourMinute";
  }

  String get notificationTime {
    return "$day $hourMinute:00";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'day': day,
      'hourMinute': hourMinute,
    };
  }

  factory AlarmItem.fromMap(Map<String, dynamic> map) {
    return AlarmItem(
      map['id'],
      title: map['title'],
      description: map['description'],
      day: map['day'],
      hourMinute: map['hourMinute'],
    );
  }

  Future<void> dbUpdate() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    await NotificationService().cancelNotification(id);
    await scheduleNotification();
    dbHelper.updateAlarm(this);
  }

  Future<void> dbDelete() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    NotificationService().cancelNotification(id);
    dbHelper.deleteAlarm(id);
  }

  Future<void> dbInsert() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    dbHelper.insertAlarm(this);
  }

  Future<void> scheduleNotification() async {
    NotificationService().scheduleNotification(
        title: title,
        body: description,
        scheduledNotificationDateTime: DateTime.parse(day));
  }
}
