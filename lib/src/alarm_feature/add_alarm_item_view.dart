// import 'package:flutter/scheduler.dart';
import 'package:alarm_app/src/alarm_feature/alarm_item_list_view.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter/material.dart';
import 'package:alarm_app/models/alarm_item.dart';
import 'package:alarm_app/services/date_helper.dart';
import 'package:alarm_app/widgets/custom_text_field.dart';
import 'package:time_picker_sheet/widget/sheet.dart';
import 'package:time_picker_sheet/widget/time_picker.dart';

late AlarmItem alarm;

class AddAlarmItemView extends StatefulWidget {
  const AddAlarmItemView({super.key});

  static const routeName = '/addAlarmItem';

  @override
  State<AddAlarmItemView> createState() => _AddAlarmItemViewState();
}

class _AddAlarmItemViewState extends State<AddAlarmItemView> {
  double fontSize = 18;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: alarm.isOld
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  await alarm.dbUpdate();
                  Navigator.pop(context);
                },
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  alarm.dbDelete();
                  Navigator.pop(context);
                },
              ),
        title: Row(
          children: [
            SizedBox(
              width: width * 0.62,
              child: TextFormField(
                initialValue: alarm.title,
                style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis),
                decoration: const InputDecoration(
                  fillColor: Colors.black,
                  border: InputBorder.none,
                  hintText: "0",
                ),
                onChanged: (value) {
                  setState(() {
                    alarm.title = value == "" ? alarm.title : value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: 1250,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text("Description :",
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ),
                  ),
                ),
                Flexible(
                  flex: 7,
                  child: SizedBox(
                    child: CustomTextField(
                        fontSize: fontSize,
                        initialValue: alarm.description,
                        onChanged: (String value) {
                          alarm.description =
                              value == "" ? alarm.description : value;
                        }),
                  ),
                ),
                Flexible(
                  flex: 7,
                  child: SizedBox(
                      height: height,
                      // child: Center(child: Text("Hello")),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DatePickerTxt(
                              fontSize: fontSize,
                              onConfirm: (DateTime date) {
                                setState(() {
                                  alarm.day =
                                      "${date.toString().substring(0, 10)} ${alarm.hourMinute}";
                                });
                              }),
                          Text(
                              "  ${DateHelper.getFormattedDate(DateTime.parse(alarm.day))}",
                              style: TextStyle(fontSize: fontSize)),
                          const SizedBox(height: 20),
                          TimePickerTxt(
                              fontSize: fontSize,
                              onChanged: (DateTime time) {
                                setState(() {
                                  alarm.hourMinute =
                                      DateHelper.toHourMinute(time);
                                  alarm.day =
                                      "${alarm.day.toString().substring(0, 10)} ${alarm.hourMinute}";
                                });
                              }),
                          Text("  ${alarm.hourMinute}",
                              style: TextStyle(fontSize: fontSize)),
                        ],
                      )),
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  child: ScheduleButton(
                    fontSize: fontSize,
                    onPressed: () async {
                      if (alarm.isOld) {
                        await alarm.dbDelete();
                      } else {
                        await alarm.dbUpdate();
                      }
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const AlarmItemListView();
                      })).then((_) => setState(() {}));
                      // ignore: use_build_context_synchronously
                      // Navigator.pop(context).then((_) => setState(() {}));
                      // Navigator.pop(context);
                    },
                  ),
                )),
              ],
            ),
          )),
    );
  }
}

class DatePickerTxt extends StatefulWidget {
  final double fontSize;
  final Function onConfirm;
  const DatePickerTxt(
      {super.key, required this.onConfirm, required this.fontSize})
      : super();

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        picker.DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: now,
            maxTime: now.add(const Duration(days: 365 * 5)),
            theme: picker.DatePickerTheme(
                headerColor: Colors.red[400],
                backgroundColor: Colors.grey[800]!,
                itemStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                doneStyle: const TextStyle(color: Colors.white, fontSize: 16)),
            onConfirm: (date) {
          widget.onConfirm(date);
        }, currentTime: DateTime.now(), locale: picker.LocaleType.en);
      },
      child: Text(
        'Select Starting Date',
        style: TextStyle(color: Colors.red[400], fontSize: widget.fontSize),
      ),
    );
  }
}

class ScheduleButton extends StatelessWidget {
  final double fontSize;
  final Function onPressed;
  const ScheduleButton({
    Key? key,
    required this.fontSize,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red[400]),
            minimumSize: MaterialStateProperty.all(const Size(100, 50))),
        onPressed: () async {
          await onPressed();
        },
        child: Text(alarm.isOld ? "Delete" : "Save",
            style: const TextStyle(fontSize: 22)));
  }
}

class TimePickerTxt extends StatefulWidget {
  final Function onChanged;
  final double fontSize;
  const TimePickerTxt(
      {super.key, required this.onChanged, required this.fontSize});

  @override
  State<TimePickerTxt> createState() => _TimePickerTxtState();
}

class _TimePickerTxtState extends State<TimePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final result = await TimePicker.show<DateTime?>(
          context: context,
          sheet: TimePickerSheet(
            initialDateTime:
                DateTime.parse(alarm.day).add(const Duration(minutes: 5)),
            minuteInterval: 5,
            sheetTitle: 'Set meeting schedule',
            hourTitle: 'Hour',
            minuteTitle: 'Minute',
            saveButtonText: 'Save',
          ),
        );
        widget.onChanged(result ?? alarm.hourMinute);
      },
      child: Text(
        'Select Time',
        style: TextStyle(color: Colors.red[400], fontSize: widget.fontSize),
      ),
    );
  }
}
