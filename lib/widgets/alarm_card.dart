import 'package:alarm_app/config.dart';
import 'package:alarm_app/models/alarm_item.dart';
import 'package:alarm_app/services/date_helper.dart';
import 'package:flutter/material.dart';

class AlarmCard extends StatefulWidget {
  final AlarmItem alarmItem;
  final Function onTap;
  const AlarmCard({super.key, required this.alarmItem, required this.onTap});

  @override
  State<AlarmCard> createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  Widget _buildRescheduleButton() {
    return widget.alarmItem.isOver && widget.alarmItem.recurrencyInDays != 0
        ? TextButton(
            onPressed: () async {
              await widget.alarmItem.reschedule();
              setState(() {});
            },
            child: Text(
              "Tap to schedule again\nin ${widget.alarmItem.recurrencyInDays} days from now",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: Config.textFontSize,
                decoration: TextDecoration.underline,
                color: Config.orange,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        : const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.35),
                    Colors.white.withOpacity(0.2),
                  ]),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white30,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(widget.alarmItem.title,
                      style: const TextStyle(
                          fontSize: Config.titleFontSize,
                          fontFamily: 'FireSansCondensed',
                          color: Config.orange,
                          overflow: TextOverflow.ellipsis)),
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    text: TextSpan(
                      text: DateHelper.getFormattedDate(
                          DateTime.parse(widget.alarmItem.day)),
                      style: const TextStyle(
                          fontSize: Config.textFontSize,
                          fontFamily: 'FireSansCondensed',
                          color: Config.white,
                          overflow: TextOverflow.ellipsis),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.alarmItem.isOver ? " (over)" : "",
                          style: const TextStyle(
                            fontSize: Config.textFontSize,
                            color: Config.orange,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.alarmItem.hourMinute,
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          )),
                      _buildRescheduleButton(),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
