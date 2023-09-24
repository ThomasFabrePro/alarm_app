import 'package:alarm_app/main.dart';
import 'package:alarm_app/services/database_helper.dart';
import 'package:alarm_app/services/notification_service.dart';

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
      'recurrencyInDays': recurrencyInDays,
    };
  }

  factory AlarmItem.fromMap(Map<String, dynamic> map) {
    return AlarmItem(
      map['id'],
      title: map['title'],
      description: map['description'],
      day: map['day'],
      hourMinute: map['hourMinute'],
      recurrencyInDays: map['recurrencyInDays'],
    );
  }

  ///only update the databse
  Future<void> updateDb() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    dbHelper.updateAlarm(this);
  }

  ///update item in database and update the notification
  Future<void> dbUpdateAlarmAndNotif() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    await NotificationService().cancelNotification(id);
    await scheduleNotification();
    dbHelper.updateAlarm(this);
    logger.t("Alarm Updated :: id: $id, title: $title, day: $day");
  }

  ///delete item in database and delete the notification
  Future<void> dbDeleteAlarmAndNotif() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    NotificationService().cancelNotification(id);
    dbHelper.deleteAlarm(id);
    logger.t("Alarm Deleted :: id: $id, title: $title, day: $day");
  }

  ///insert alarm in database but does not schedule the notification
  Future<void> dbInsertAlarm() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    dbHelper.insertAlarm(this);
    logger.t("Alarm Inserted :: id: $id");
  }

  Future<void> scheduleNotification() async {
    NotificationService().scheduleNotification(
        id: id,
        title: title,
        body: description,
        scheduledNotificationDateTime: DateTime.parse(day));
    logger.t("Notification Scheduled:: id: $id, title: $title, day: $day");
  }
}
