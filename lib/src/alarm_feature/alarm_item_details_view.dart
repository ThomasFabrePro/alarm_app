import 'package:alarm_app/src/alarm_feature/alarm_item.dart';
import 'package:flutter/material.dart';

/// Displays detailed information about a AlarmItem.
class AlarmItemDetailsView extends StatelessWidget {
  const AlarmItemDetailsView({super.key});

  static const routeName = '/sample_item';
  static late AlarmItem alarm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(alarm.title),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
