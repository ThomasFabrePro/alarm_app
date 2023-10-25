import 'dart:math' show Random;

import 'package:alarm_app/config.dart';
import 'package:alarm_app/services/database_helper.dart';
import 'package:alarm_app/src/alarm_feature/alarm_item_details_view.dart';
import 'package:alarm_app/widgets/alarm_card.dart';
import 'package:flutter/material.dart';

import '../../models/alarm_item.dart';

/// Displays a list of AlarmItems.
class AlarmItemListView extends StatefulWidget {
  const AlarmItemListView({
    super.key,
  });

  static const routeName = '/';

  @override
  State<AlarmItemListView> createState() => _AlarmItemListViewState();
}

class _AlarmItemListViewState extends State<AlarmItemListView> {
  Future<void> createNewAlarm() async {
    AlarmItem newAlarm = AlarmItem(Random().nextInt(100000000),
        title: "New Alarm",
        description: "My new alarm",
        day: DateTime.now().toString(),
        hourMinute: DateTime.now().toString().substring(11, 16),
        isOld: false);
    alarm = newAlarm;
    await alarm.dbInsertAlarm();
  }

  Future<List<AlarmItem>> fetchAlarms() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    return await dbHelper.fetchAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Config.primaryColor,
        foregroundColor: Config.white,
        onPressed: () async {
          await createNewAlarm().then((value) =>
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AlarmItemDetailsView();
              })).then((_) => setState(() {})));
        },
        child: const Icon(Icons.add_alarm),
      ),
      appBar: AppBar(
        title: const Text('My alarms'),
      ),
      body: FutureBuilder(
        future: fetchAlarms(),
        builder: (ctx, snapshot) {
          // Checking if future is resolved or not
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: const TextStyle(fontSize: 18),
                ),
              );

              // if we got our data
            } else if (snapshot.hasData) {
              final List<AlarmItem> items = snapshot.data as List<AlarmItem>;
              // Extracting data from snapshot object
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];

                  return AlarmCard(
                    alarmItem: item,
                    onTap: () {
                      alarm = item;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const AlarmItemDetailsView();
                      })).then((_) => setState(() {}));
                    },
                  );
                },
              );
            }
          }
          // Displaying LoadingSpinner to indicate waiting state
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
