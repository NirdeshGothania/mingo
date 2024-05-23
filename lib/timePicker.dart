import 'dart:math';

import 'package:flutter/material.dart';

Future<TimeOfDay?> showCustomTimePicker(
  BuildContext context, {
  TimeOfDay? initialTime,
  TimeOfDay? minimumTime,
  TimeOfDay? maximumTime,
}) async {
  TimeOfDay? selectedTime;
  await showDialog(
    context: context,
    builder: (context) {
      return CustomTimePicker(
        initialTime: initialTime,
        minimumTime: minimumTime,
        maximumTime: maximumTime,
        onSubmit: (t) {
          selectedTime = t;
        },
      );
    },
  );
  return selectedTime;
}

class CustomTimePicker extends StatefulWidget {
  const CustomTimePicker({
    super.key,
    this.initialTime,
    this.minimumTime,
    this.maximumTime,
    required this.onSubmit,
  });

  final TimeOfDay? initialTime;
  final TimeOfDay? minimumTime;
  final TimeOfDay? maximumTime;
  final Function(TimeOfDay? selectedtTime) onSubmit;

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  var currentTime = TimeOfDay.now();
  var isSelectingHours = true;
  var isMinDef = false;
  var isMaxDef = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialTime != null) {
      currentTime = widget.initialTime!;
    }
    isMinDef = (widget.minimumTime != null);
    isMaxDef = (widget.maximumTime != null);
  }

  bool _isHourValid(int hour) {
    bool isValid = true;
    if (isMinDef && isMaxDef) {
      isValid = (hour >= widget.minimumTime!.hour) &&
          (hour <= widget.maximumTime!.hour);
    } else if (isMaxDef) {
      isValid = (hour <= widget.maximumTime!.hour);
    } else if (isMinDef) {
      isValid = (hour >= widget.minimumTime!.hour);
    }
    return isValid;
  }

  bool _isMinuteValid(int minute) {
    if (isMinDef && currentTime.hour == widget.minimumTime!.hour) {
      return (minute >= widget.minimumTime!.minute);
    }
    if (isMaxDef && currentTime.hour == widget.maximumTime!.hour) {
      return (minute <= widget.maximumTime!.minute);
    }
    return true;
  }

  TextStyle _getTextStyle(bool isEnabled) {
    return TextStyle(
        fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
        color:
            (isEnabled) ? Theme.of(context).colorScheme.primary : Colors.grey);
  }

  List<Widget> _generateStackChildren(double center) {
    if (isSelectingHours) {
      return List<int>.generate(12, (index) => index + 1).map(
            (e) {
              double theta = pi / 180 * 30 * e;
              double radius = 120;
              double bottom = center + radius * cos(theta);
              double left = center + radius * sin(theta);
              double width = 50;
              bool isEnabled = _isHourValid(e);
              return Positioned(
                left: left - width / 2,
                bottom: bottom,
                child: SizedBox(
                  width: width,
                  child: TextButton(
                    onPressed: (isEnabled)
                        ? () {
                            setState(() {
                              currentTime = TimeOfDay(
                                hour: e,
                                minute: currentTime.minute,
                              );
                              isSelectingHours = false;
                            });
                          }
                        : null,
                    child: Text(
                      e.toString(),
                      style: _getTextStyle(isEnabled),
                    ),
                  ),
                ),
              );
            },
          ).toList() +
          List<int>.generate(12, (index) => index + 13).map(
            (e) {
              String text = (e != 24) ? e.toString() : "00";
              double theta = pi / 180 * 30 * e;
              double radius = 150;
              double bottom = center + radius * cos(theta);
              double left = center + radius * sin(theta);
              double width = 50;
              bool isEnabled = _isHourValid((e != 24) ? e : 0);
              return Positioned(
                left: left - width / 2,
                bottom: bottom,
                child: SizedBox(
                  width: width,
                  child: TextButton(
                    onPressed: (isEnabled)
                        ? () {
                            setState(() {
                              currentTime = TimeOfDay(
                                hour: (e != 24) ? e : 0,
                                minute: currentTime.minute,
                              );
                              isSelectingHours = false;
                            });
                          }
                        : null,
                    child: Text(
                      text,
                      style: _getTextStyle(isEnabled),
                    ),
                  ),
                ),
              );
            },
          ).toList();
    }
    return List<int>.generate(12, (index) => index + 1).map(
      (e) {
        String text = (e != 12) ? (e * 5).toString() : "00";
        double theta = pi / 180 * 30 * e;
        double radius = 135;
        double bottom = center + radius * cos(theta);
        double left = center + radius * sin(theta);
        double width = 50;
        bool isEnabled = _isMinuteValid((e != 12) ? (e * 5) : 0);
        return Positioned(
          left: left - width / 2,
          bottom: bottom,
          child: SizedBox(
            width: width,
            child: TextButton(
              onPressed: (isEnabled)
                  ? () {
                      setState(() {
                        currentTime = TimeOfDay(
                          hour: currentTime.hour,
                          minute: (e != 12) ? (e * 5) : 0,
                        );
                      });
                    }
                  : null,
              child: Text(
                text,
                style: _getTextStyle(isEnabled),
              ),
            ),
          ),
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    double center = 180;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: center * 2 + 50,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isSelectingHours = true;
                      });
                    },
                    child: Text(
                      currentTime.hour.toString().padLeft(2, '0'),
                      style: TextStyle(
                          color: (isSelectingHours)
                              ? Theme.of(context).colorScheme.primary
                              : Colors.black,
                          fontSize: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .fontSize,
                          fontWeight: (isSelectingHours)
                              ? FontWeight.w700
                              : FontWeight.normal),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      ':',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isSelectingHours = false;
                      });
                    },
                    child: Text(
                      currentTime.minute.toString().padLeft(2, '0'),
                      style: TextStyle(
                          color: (!isSelectingHours)
                              ? Theme.of(context).colorScheme.primary
                              : Colors.black,
                          fontSize: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .fontSize,
                          fontWeight: (!isSelectingHours)
                              ? FontWeight.w700
                              : FontWeight.normal),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: center * 2,
                width: center * 2,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: _generateStackChildren(center),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      widget.onSubmit(null);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 15),
                  FilledButton(
                    onPressed: () {
                      widget.onSubmit(currentTime);
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
