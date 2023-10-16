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

  bool get isOver {
    return DateTime.now().isAfter(DateTime.parse(day));
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

  ///only update the databse, does not update the notification
  Future<void> updateDb() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    await dbHelper.updateAlarm(this);
  }

  ///update item in database and update the notification
  Future<void> updateAlarmAndNotif() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    Future.wait([
      dbHelper.updateAlarm(this),
      NotificationService().cancelNotification(id),
      scheduleNotification()
    ]);

    logger.t("Alarm Updated :: id: $id, title: $title, day: $day");
  }

  ///delete item in database and delete the notification
  Future<void> deleteAlarmAndNotif() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    await dbHelper.deleteAlarm(id);
    NotificationService().cancelNotification(id);

    logger.t("Alarm Deleted :: id: $id, title: $title, day: $day");
  }

  ///insert alarm in database but does not schedule the notification
  Future<void> dbInsertAlarm() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    await dbHelper.insertAlarm(this);
    logger.t("Alarm Inserted :: id: $id");
  }

  Future<void> scheduleNotification() async {
    await NotificationService().scheduleNotification(
        id: id,
        title: title,
        body: description,
        scheduledNotificationDateTime: DateTime.parse(day));
    logger.t(
        "Notification Scheduled:: id: $id, title: $title, day: ${DateTime.parse(day).toString()}");
  }

  Future<void> reschedule() async {
    DateTime date = DateTime.now().add(Duration(days: recurrencyInDays));
    day = "${date.toString().substring(0, 10)} $hourMinute";
    await updateAlarmAndNotif();
  }
}
