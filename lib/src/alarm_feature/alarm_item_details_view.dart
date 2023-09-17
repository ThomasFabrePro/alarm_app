import 'package:flutter/material.dart';

/// Displays detailed information about a AlarmItem.
class AlarmItemDetailsView extends StatelessWidget {
  const AlarmItemDetailsView({super.key});

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
