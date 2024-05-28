// Import necessary packages
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:mingo/addQuestionPage.dart';
import 'package:mingo/common_widgets.dart';
import 'package:mingo/timePicker.dart';
import 'package:uuid/uuid.dart';

import 'sessionConstants.dart';

class CreateContest extends StatefulWidget {
  final Map<String, dynamic>? contestDetails;
  const CreateContest({Key? key, required this.contestDetails})
      : super(key: key);

  @override
  State<CreateContest> createState() => _CreateContestState();
}

class _CreateContestState extends State<CreateContest> {
  String code = '';
  final TextEditingController contestName = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController rules = TextEditingController();
  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;
  late String contestid;

  @override
  void initState() {
    super.initState();

    contestid =
        widget.contestDetails?['contestId'] ?? const Uuid().v4().toString();

    if (widget.contestDetails != null) {
      contestName.text = widget.contestDetails!['contestName'] ?? '';
      description.text = widget.contestDetails!['description'] ?? '';
      rules.text = widget.contestDetails!['rules'] ?? '';
      startDate = widget.contestDetails!['startDate'] != null
          ? DateFormat('dd-MM-yyyy').parse(widget.contestDetails!['startDate'])
          : null;
      startTime = widget.contestDetails!['startTime'] != null
          ? TimeOfDay.fromDateTime(
              DateFormat('HH:mm').parse(widget.contestDetails!['startTime']))
          : null;
      endDate = widget.contestDetails!['endDate'] != null
          ? DateFormat('dd-MM-yyyy').parse(widget.contestDetails!['endDate'])
          : null;
      endTime = widget.contestDetails!['endTime'] != null
          ? TimeOfDay.fromDateTime(
              DateFormat('HH:mm').parse(widget.contestDetails!['endTime']))
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        automaticallyImplyLeading: true,
        title: Text(
          'Create Contest',
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Contest Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextField(
                controller: contestName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Contest Name',
                ),
              ),
              const SizedBox(height: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Start Date',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  FilledButton(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2025),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          startDate = selectedDate;
                        });
                        if (startDate != null) {
                          print(
                              'Start Date selected: ${DateFormat('dd-MM-yyyy').format(startDate!)}');
                        }
                      }
                    },
                    child: startDate == null
                        ? const Text('Select Start Date')
                        : Text(DateFormat('dd-MM-yyyy').format(startDate!)),
                  ),
                  const Text(
                    'Start Time',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  FilledButton(
                    onPressed: () async {
                      TimeOfDay? minimumTime;
                      if (DateFormat('dd-MM-yyyy').format(startDate!) ==
                          DateFormat('dd-MM-yyyy').format(DateTime.now())) {
                        minimumTime = TimeOfDay(
                          hour: TimeOfDay.now().hour,
                          minute: TimeOfDay.now().minute,
                        );
                      }

                      final selectedTime = await showCustomTimePicker(
                        context,
                        initialTime: TimeOfDay.now(),
                        minimumTime: minimumTime,
                      );

                      if (selectedTime != null) {
                        setState(() {
                          startTime = selectedTime;
                          print('Start Time selected: $startTime');
                          print(
                              'Start Time selected:- ${startTime!.hour} : ${startTime!.minute}');
                        });
                      }
                    },
                    child: startTime == null
                        ? const Text('Select Start Time')
                        : Text('${startTime!.hour} : ${startTime!.minute}'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'End Date',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  FilledButton(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: startDate!,
                        firstDate: startDate!,
                        lastDate: DateTime(2025),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          endDate = selectedDate;
                        });
                        print(
                            'End Date selected: ${DateFormat('dd-MM-yyyy').format(endDate!)}');
                      }
                    },
                    child: endDate == null
                        ? const Text('Select End Date')
                        : Text(DateFormat('dd-MM-yyyy').format(endDate!)),
                  ),
                  const Text(
                    'End Time',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  FilledButton(
                    onPressed: endDate == startDate
                        ? () async {
                            final selectedTime = await showCustomTimePicker(
                              context,
                              initialTime: TimeOfDay.now(),
                              minimumTime: TimeOfDay(
                                  hour: startTime!.hour,
                                  minute: startTime!.minute),
                            );

                            if (selectedTime != null) {
                              setState(() {
                                endTime = selectedTime;
                              });
                              print('End Time selected: $endTime');
                            }
                          }
                        : () async {
                            final selectedTime = await showCustomTimePicker(
                              context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (selectedTime != null) {
                              setState(() {
                                endTime = selectedTime;
                              });
                              print(
                                  'End Time selected: ${endTime!.hour} : ${endTime!.minute}');
                            }
                          },
                    child: endTime == null
                        ? const Text('Select End Time')
                        : Text('${endTime!.hour} : ${endTime!.minute}'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextField(
                controller: description,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Description',
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              const Text(
                'Instructions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextField(
                controller: rules,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Instructions',
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  // var contestid = widget.contestDetails!['contestId'] ?? const Uuid().v4().toString();
                  code = const Uuid().v4().substring(1, 5);
                  print('Code: $code');
                  if (validateFields()) {
                    createContest(
                      contestid,
                      contestName.text,
                      startDate,
                      startTime,
                      endDate,
                      endTime,
                      description.text,
                      rules.text,
                      SessionConstants.email!,
                      code,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => addQuestionPage1(
                          contestId: contestid,
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.save_as),
                label: const Text('Save and Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateFields() {
    if (contestName.text.isEmpty ||
        startDate == null ||
        startTime == null ||
        endDate == null ||
        endTime == null ||
        description.text.isEmpty ||
        rules.text.isEmpty ||
        code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill in all fields'),
      ));
      return false;
    } else if (endDate!.isBefore(startDate!) ||
        (endDate == startDate && isTimeBefore(endTime!, startTime!))) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('End date/time cannot be before start date/time'),
      ));
      return false;
    }
    return true;
  }

  bool isTimeBefore(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour < time2.hour) {
      return true;
    } else if (time1.hour == time2.hour) {
      return time1.minute < time2.minute;
    } else {
      return false;
    }
  }

  Future<void> createContest(
    var contestid,
    String contestName,
    DateTime? startDate,
    TimeOfDay? startTime,
    DateTime? endDate,
    TimeOfDay? endTime,
    String description,
    String rules,
    String email,
    String code,
  ) async {
    const serverUrl =
        '${SessionConstants.host}/createcontest1'; // Replace with your server URL

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contestId': contestid,
          'contestName': contestName,
          'startDate': DateFormat('dd-MM-yyyy').format(startDate!),
          'startTime': '${startTime!.hour}:${startTime.minute}',
          'endDate': DateFormat('dd-MM-yyyy').format(endDate!),
          'endTime': '${endTime!.hour}:${endTime.minute}',
          'description': description,
          'rules': rules,
          'email': email,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        print('Success! Response body: ${response.body}');
      } else {
        print('Error: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: CreateContest(
      contestDetails: {},
    ),
  ));
}
