import 'package:alarm_app/models/alarm_item.dart';
import 'package:flutter/material.dart';

class AlarmCard extends StatefulWidget {
  final AlarmItem alarmItem;
  final Function onTap;
  const AlarmCard({super.key, required this.alarmItem, required this.onTap});

  @override
  State<AlarmCard> createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withAlpha(100),
                    Colors.white.withOpacity(0.4),
                    Colors.white.withOpacity(0.2),
                    // Colors.white.withOpacity(0.4),
                    // Colors.white.withOpacity(0.1),
                  ]),
              // color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white30,
                width: 2,
              ),
            ),
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Text(
                  widget.alarmItem.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'FireSansCondensed',
                    // color: Color.fromARGB(213, 0, 0, 0),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
