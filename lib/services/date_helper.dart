// import 'package:flutter/services.dart';
class DateHelper {
  static String getFormattedDate(DateTime date) {
    String day = getDay(date.weekday);
    String month = getMonth(date.month);
    return "$day ${date.day} $month ${date.year}";
  }

  static String getFormattedTime(DateTime date) {
    return "${date.hour}:${date.minute}";
  }

  static String getDay(int weekday) {
    switch (weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
      default:
        return "Sunday";
    }
  }

  static String toHourMinute(DateTime date) {
    String refactoredMinutes =
        date.minute < 10 ? "0${date.minute}" : "${date.minute}";
    return "${date.hour}:$refactoredMinutes";
  }

  String toDay(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  static String getMonth(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "Febuary";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
      default:
        return "December";
    }
  }
}
