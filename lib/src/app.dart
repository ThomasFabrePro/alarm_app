import 'package:alarm_app/src/alarm_feature/alarm_item_details_view.dart';
import 'package:flutter/material.dart';
import 'alarm_feature/alarm_item_list_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case AlarmItemDetailsView.routeName:
                return const AlarmItemDetailsView();
              case AlarmItemListView.routeName:
              default:
                return const AlarmItemListView();
            }
          },
        );
      },
    );
  }
}
