import 'dart:math' show Random;

import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'alarm_item.dart';
import 'alarm_item_details_view.dart';

/// Displays a list of AlarmItems.
class AlarmItemListView extends StatelessWidget {
  const AlarmItemListView({
    super.key,
    // this.items,
  });

  static const routeName = '/';

  // final List<AlarmItem> items = const [];

  @override
  Widget build(BuildContext context) {
    int idOne = Random().nextInt(1000000000);
    int idTwo = Random().nextInt(1000000000);
    List<AlarmItem> items = [
      AlarmItem(idOne, 'title', 'description', DateTime.now().toString()),
      AlarmItem(idTwo, 'title2', 'description', DateTime.now().toString())
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('My alarms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alarm),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
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
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
              title: Text(item.title),
              leading: const CircleAvatar(
                // Display the Flutter Logo image asset.
                foregroundImage: AssetImage('assets/images/logo.jpg'),
              ),
              onTap: () {
                // Navigate to the details page. If the user leaves and returns to
                // the app after it has been killed while running in the
                // background, the navigation stack is restored.
                AlarmItemDetailsView.alarm = item;
                Navigator.restorablePushNamed(
                    context, AlarmItemDetailsView.routeName);
              });
        },
      ),
    );
  }
}
