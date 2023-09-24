import 'dart:math' show Random;

import 'package:alarm_app/services/database_helper.dart';
import 'package:alarm_app/src/alarm_feature/add_alarm_item_view.dart';
import 'package:alarm_app/widgets/alarm_card.dart';
import 'package:flutter/material.dart';

import '../../models/alarm_item.dart';

/// Displays a list of AlarmItems.
class AlarmItemListView extends StatefulWidget {
  const AlarmItemListView({
    super.key,
    // this.items,
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
    //setup AddAlarmItemView "alarm"
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
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text('My alarms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alarm),
            onPressed: () async {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              await createNewAlarm();
              Navigator.restorablePushNamed(
                  context, AddAlarmItemView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
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
                // Providing a restorationId allows the ListView to restore the
                // scroll position when a user leaves and returns to the app after it
                // has been killed while running in the background.
                restorationId: 'sampleItemListView',
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];

                  return AlarmCard(
                    alarmItem: item,
                    onTap: () {
                      alarm = item;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const AddAlarmItemView();
                      })).then((_) => setState(() {}));
                    },
                  );
                  // ListTile(
                  //     title: Text(item.title),
                  //     leading: const CircleAvatar(
                  //       // Display the Flutter Logo image asset.
                  //       foregroundImage: AssetImage('assets/images/logo.jpg'),
                  //     ),
                  //     onTap: () {
                  //       // Navigate to the details page. If the user leaves and returns to
                  //       // the app after it has been killed while running in the
                  //       // background, the navigation stack is restored.
                  //       alarm = item;
                  //       Navigator.push(context,
                  //           MaterialPageRoute(builder: (context) {
                  //         return const AddAlarmItemView();
                  //       })).then((_) => setState(() {}));
                  //       // Navigator.pushNamed(
                  //       //     context, AddAlarmItemView.routeName);
                  //       // Navigator.restorablePushNamed(
                  //       //     context, AddAlarmItemView.routeName);
                  //     });
                },

                // ),
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
