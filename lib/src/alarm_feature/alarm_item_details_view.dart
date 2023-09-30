// import 'package:flutter/scheduler.dart';
import 'package:alarm_app/config.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter/material.dart';
import 'package:alarm_app/models/alarm_item.dart';
import 'package:alarm_app/services/date_helper.dart';
import 'package:alarm_app/widgets/custom_text_field.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:time_picker_sheet/widget/sheet.dart';
import 'package:time_picker_sheet/widget/time_picker.dart';

late AlarmItem alarm;

class AlarmItemDetailsView extends StatefulWidget {
  const AlarmItemDetailsView({super.key});

  static const routeName = '/alarm_details';

  @override
  State<AlarmItemDetailsView> createState() => _AddAlarmItemViewState();
}

class _AddAlarmItemViewState extends State<AlarmItemDetailsView> {
  Future<void> updateAndDone() async {
    String snackbarText = 'Successfully updated alarm "${alarm.title}".';
    Color snackbarColor = Config.successfullSnackBar;
    await alarm.updateAlarmAndNotif().onError((error, stackTrace) {
      snackbarText = 'Failed updating alarm "${alarm.title}".';
      snackbarColor = Config.errorSnackBar;
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            snackbarText,
            style: const TextStyle(color: Config.white),
          ),
          backgroundColor: snackbarColor,
        ),
      );
      Navigator.pop(context);
    });
  }

  Future<void> deleteAndDone() async {
    String snackbarText = 'Successfully deleted alarm "${alarm.title}".';
    Color snackbarColor = Config.successfullSnackBar;
    await alarm.deleteAlarmAndNotif().onError((error, stackTrace) {
      snackbarText = 'Failed deleting alarm "${alarm.title}".';
      snackbarColor = Config.errorSnackBar;
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            snackbarText,
            style: const TextStyle(color: Config.white),
          ),
          backgroundColor: snackbarColor,
        ),
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    double voidBoxHeight = 40;
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: alarm.isOld
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  await updateAndDone();
                },
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await deleteAndDone();
                },
              ),
        title: Row(
          children: [
            SizedBox(
              width: width * 0.62,
              child: TextFormField(
                initialValue: alarm.title,
                style: const TextStyle(
                    fontSize: Config.titleFontSize,
                    color: Config.white,
                    overflow: TextOverflow.ellipsis),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "New Alarm",
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: double.infinity,
                  child: Text("Description :",
                      style: TextStyle(
                        fontSize: Config.textFontSize + 1,
                        color: Config.orange,
                        overflow: TextOverflow.ellipsis,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    initialValue: alarm.description,
                    onChanged: (String value) async {
                      alarm.description =
                          value == "" ? alarm.description : value;
                      await alarm.updateDb();
                    }),
                SizedBox(
                  height: voidBoxHeight,
                ),
                DatePickerTxt(onConfirm: (DateTime date) async {
                  setState(() {
                    alarm.day =
                        "${date.toString().substring(0, 10)} ${alarm.hourMinute}";
                  });
                  await alarm.updateAlarmAndNotif();
                }),
                SizedBox(
                  height: voidBoxHeight,
                ),
                TimePickerTxt(onChanged: (DateTime time) async {
                  setState(() {
                    alarm.hourMinute = DateHelper.toHourMinute(time);
                    alarm.day =
                        "${alarm.day.toString().substring(0, 10)} ${alarm.hourMinute}";
                  });
                  await alarm.updateAlarmAndNotif();
                }),
                SizedBox(
                  height: voidBoxHeight,
                ),
                const Text(
                  'Select Recurrency In Days :',
                  style: TextStyle(
                      color: Config.orange, fontSize: Config.textFontSize),
                ),
                SizedBox(
                  height: voidBoxHeight,
                ),
                Center(
                  child: NumberPicker(
                    value: alarm.recurrencyInDays,
                    minValue: 0,
                    maxValue: 10,
                    textStyle: const TextStyle(
                        color: Config.orange, fontSize: Config.textFontSize),
                    selectedTextStyle: const TextStyle(
                        color: Config.white, fontSize: Config.titleFontSize),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Config.orange),
                    ),
                    axis: Axis.horizontal,
                    onChanged: (value) async {
                      setState(() => alarm.recurrencyInDays = value);
                      await alarm.updateDb();
                    },
                  ),
                ),
                SizedBox(
                  height: voidBoxHeight,
                ),
                Center(
                  child: ScheduleButton(onPressed: () async {
                    if (alarm.isOld) {
                      await deleteAndDone();
                    } else {
                      await updateAndDone();
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DatePickerTxt extends StatefulWidget {
  final Function onConfirm;
  const DatePickerTxt({super.key, required this.onConfirm}) : super();

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await picker.DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: now,
            maxTime: now.add(const Duration(days: 365 * 5)),
            theme: picker.DatePickerTheme(
                headerColor: Config.orange,
                backgroundColor: Colors.grey[800]!,
                itemStyle: const TextStyle(
                    color: Config.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                doneStyle: const TextStyle(color: Config.white, fontSize: 16)),
            onConfirm: (date) {
          widget.onConfirm(date);
        }, currentTime: DateTime.now(), locale: picker.LocaleType.en);
      },
      child: RichText(
        overflow: TextOverflow.clip,
        softWrap: true,
        text: TextSpan(
          text: 'Select Date :\n\n',
          style: const TextStyle(
              color: Config.orange, fontSize: Config.textFontSize - 1),
          children: <TextSpan>[
            TextSpan(
                text: DateHelper.getFormattedDate(DateTime.parse(alarm.day)),
                style: const TextStyle(
                    fontSize: Config.textFontSize, color: Config.white)),
          ],
        ),
      ),
    );
  }
}

class ScheduleButton extends StatelessWidget {
  final Function onPressed;
  const ScheduleButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                alarm.isOld ? Config.red : Config.orange),
            minimumSize: MaterialStateProperty.all(const Size(100, 50))),
        onPressed: () async {
          await onPressed();
        },
        child: Text(alarm.isOld ? "Delete" : "Save",
            style: const TextStyle(fontSize: Config.titleFontSize)));
  }
}

class TimePickerTxt extends StatefulWidget {
  final Function onChanged;
  const TimePickerTxt({super.key, required this.onChanged});

  @override
  State<TimePickerTxt> createState() => _TimePickerTxtState();
}

class _TimePickerTxtState extends State<TimePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await TimePicker.show<DateTime?>(
          context: context,
          sheet: TimePickerSheet(
            initialDateTime:
                DateTime.parse(alarm.day).add(const Duration(minutes: 5)),
            minuteInterval: 5,
            sheetTitle: 'What time',
            hourTitle: 'Hour',
            minuteTitle: 'Minute',
            saveButtonText: 'Save',
          ),
        );
        widget.onChanged(result ?? alarm.hourMinute);
      },
      child: RichText(
        overflow: TextOverflow.clip,
        softWrap: true,
        text: TextSpan(
          text: 'Select Time :\n\n',
          style: const TextStyle(
              color: Config.orange, fontSize: Config.textFontSize - 1),
          children: <TextSpan>[
            TextSpan(
                text: alarm.hourMinute,
                style: const TextStyle(
                    fontSize: Config.textFontSize, color: Config.white)),
          ],
        ),
      ),
    );
  }
}
