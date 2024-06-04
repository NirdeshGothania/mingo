import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mingo/common_widgets.dart';
import 'package:mingo/sessionConstants.dart';

import 'EditorPage.dart';

class OpenContest extends StatefulWidget {
  final Map<String, dynamic>? contestDetails;
  final Map<String, dynamic>? statusData;
  const OpenContest(
      {Key? key, required this.contestDetails, required this.statusData})
      : super(key: key);

  @override
  State<OpenContest> createState() => _OpenContestState();
}

class _OpenContestState extends State<OpenContest> {
  late DateTime endDateDateTime;
  late DateTime startDateDateTime;
  late TimeOfDay startTimeDateTime;
  late TimeOfDay endTimeDateTime;
  bool allowEnter = false;
  var codeController = TextEditingController();
  late List<ContestQuestion> contestQuestions;
  DateTime? startDateTime;
  DateTime? endDateTime;
  bool isLoadingCodeSubmit = false;

  @override
  void initState() {
    super.initState();
    endDateDateTime =
        DateFormat('dd-MM-yyyy').parse(widget.contestDetails!['endDate']);
    startDateDateTime =
        DateFormat('dd-MM-yyyy').parse(widget.contestDetails!['startDate']);
    startTimeDateTime = TimeOfDay.fromDateTime(
        DateFormat('HH:mm').parse(widget.contestDetails!['startTime']));
    endTimeDateTime = TimeOfDay.fromDateTime(
        DateFormat('HH:mm').parse(widget.contestDetails!['endTime']));

    var et = (widget.contestDetails!['endTime'] as String).split(':');
    endDateTime = DateFormat('dd-MM-yyyy:hh:mm').parse(
        widget.contestDetails!['endDate'] +
            ':${et[0].padLeft(2, '0')}:${et[1].padLeft(2, '0')}');
    var st = (widget.contestDetails!['startTime'] as String).split(':');
    startDateTime = DateFormat('dd-MM-yyyy:hh:mm').parse(
        widget.contestDetails!['startDate'] +
            ':${st[0].padLeft(2, '0')}:${st[1].padLeft(2, '0')}');
  }

  Future<void> fetchData() async {
    final contests =
        await FirebaseFirestore.instance.collection('Contest').get();
    contestQuestions = contests.docs.where((contest) {
      final contestData = contest.data();
      return contestData['contestId'] == widget.contestDetails!['contestId'];
    }).map((e) {
      var q = e.data();
      print('HiddenTestCases: ${q['hiddenTestCases'].runtimeType}');
      return ContestQuestion(
        questionId: q['questionId'],
        contestId: q['contestId'],
        contestName: Delta.fromJson(q['contestName']),
        question: Delta.fromJson(q['question']),
        inputFormat: Delta.fromJson(q['inputFormat']),
        outputFormat: Delta.fromJson(q['outputFormat']),
        sampleTestCases: (q['sampleTestCases'] as List<dynamic>)
            .map((e) => SampleTestCase(
                  input: Delta.fromJson(e['input']),
                  output: Delta.fromJson(e['output']),
                  explanation: Delta.fromJson(e['explanation']),
                ))
            .toList(),
        constraints: Delta.fromJson(q['constraints']),
        code: q['code'] ??
            '#include<stdio.h>    \nint main() {\n    printf("Hello, world!");\n    return 0;\n}',
      );
    }).toList();
    if (widget.statusData!['status'] == 1) {
      await fetchCodeFiles();
    } else {
      await uploadCodeFiles();
    }
  }

  Future<void> fetchCodeFiles() async {
    for (int i = 0; i < contestQuestions.length; i++) {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('contest_${contestQuestions[i].contestId}')
          .child('/Submissions')
          .child('/question_${contestQuestions[i].questionId}')
          .child(
              '/${SessionConstants.email2!.replaceAll(RegExp('@iiitr.ac.in'), '')}');
      try {
        String newCodeFile = '';
        final downloadUrl = await ref.getDownloadURL();
        newCodeFile = await http.read(Uri.parse(downloadUrl));
        print(newCodeFile);

        contestQuestions[i].code = newCodeFile;
      } catch (error) {
        print('Error fetching code download URL: $error');
        // Handle network or other client-side errors here (e.g., display error message)
      }
    }
  }

  Future<void> uploadCodeFiles() async {
    for (int i = 0; i < contestQuestions.length; i++) {
      String inputFilePath =
          'contest_${contestQuestions[i].contestId}/Submissions/question_${contestQuestions[i].questionId}/${SessionConstants.email2!.replaceAll(RegExp('@iiitr.ac.in'), '')}';
      print(contestQuestions[i].code);
      await firebase_storage.FirebaseStorage.instance
          .ref(inputFilePath)
          .putString(contestQuestions[i].code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        automaticallyImplyLeading: true,
        title: Text(
          'Registered Contest Page',
          style: TextStyle(color: Colors.white),
        ),
        actions: [],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.contestDetails!['contestName'],
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),

              Text(
                '${widget.contestDetails!['startDate']} , ${startTimeDateTime.format(context)} to ${widget.contestDetails!['endDate']} ,  ${endTimeDateTime.format(context)}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 20,
              ),
              startDateTime!.isAfter(DateTime.now())
                  ? const Text(
                      'Starts in',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )
                  : const Text(
                      'Started',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
              const SizedBox(
                height: 20,
              ),

              if (startDateTime!.isAfter(DateTime.now()))
                TimerCountdown(
                  format: CountDownTimerFormat.daysHoursMinutesSeconds,
                  endTime: DateTime.now().add(Duration(
                    days: startDateDateTime.isAfter(DateTime.now())
                        ? startDateDateTime.day - DateTime.now().day
                        : 0,
                    hours: startTimeDateTime.hour - TimeOfDay.now().hour,
                    minutes: startTimeDateTime.minute - TimeOfDay.now().minute,
                    seconds: 0,
                  )),
                  onEnd: () {
                    setState(() {
                      allowEnter = true;
                    });
                  },
                ),

              const SizedBox(
                height: 20,
              ),

              FutureBuilder(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return FilledButton.icon(
                      onPressed: (allowEnter ||
                              startDateTime!.isBefore(DateTime.now()))
                          ? () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        title: const Text("Enter the Code"),
                                        content: CustomTextField(
                                          iconData: Icons.password,
                                          onSubmitted: (_) async {
                                            var code =
                                                codeController.text.toString();
                                            if (code ==
                                                widget
                                                    .contestDetails!['code']) {
                                              setState(() {
                                                isLoadingCodeSubmit = true;
                                              });
                                              await FirebaseFirestore.instance
                                                  .collection('createContest')
                                                  .doc(widget.contestDetails![
                                                      'contestId'])
                                                  .collection('register')
                                                  .doc(SessionConstants.email2)
                                                  .set({
                                                'status': 1,
                                              }).then((value) {
                                                setState(() {
                                                  isLoadingCodeSubmit = false;
                                                });
                                                Navigator.of(context)
                                                  ..pop()
                                                  ..push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditorPage(
                                                        contestQuestions:
                                                            contestQuestions,
                                                        contestDetails: widget
                                                            .contestDetails,
                                                      ),
                                                    ),
                                                  );
                                                print(
                                                    'Entered Contest successfully');
                                              }).catchError((error) {
                                                setState(() {
                                                  isLoadingCodeSubmit = false;
                                                });
                                                print(
                                                    'Entered Contest: $error');
                                              });
                                            } else {
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content:
                                                      Text('Incorrect Code'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                          controller: codeController,
                                          hintText: 'Code',
                                          obscureText: true,
                                        ),
                                        actions: [
                                          FilledButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          FilledButton(
                                            onPressed: isLoadingCodeSubmit
                                                ? null
                                                : () async {
                                                    setState(() {
                                                      isLoadingCodeSubmit =
                                                          true;
                                                    });
                                                    var code = codeController
                                                        .text
                                                        .toString();
                                                    if (code ==
                                                        widget.contestDetails![
                                                            'code']) {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'createContest')
                                                          .doc(widget
                                                                  .contestDetails![
                                                              'contestId'])
                                                          .collection(
                                                              'register')
                                                          .doc(SessionConstants
                                                              .email2)
                                                          .set({
                                                        'status': 1,
                                                      }).then((value) {
                                                        setState(() {
                                                          isLoadingCodeSubmit =
                                                              false;
                                                        });
                                                        Navigator.of(context)
                                                          ..pop()
                                                          ..push(
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      EditorPage(
                                                                contestQuestions:
                                                                    contestQuestions,
                                                                contestDetails:
                                                                    widget
                                                                        .contestDetails,
                                                              ),
                                                            ),
                                                          );
                                                        print(
                                                            'Entered Contest successfully');
                                                      }).catchError((error) {
                                                        setState(() {
                                                          isLoadingCodeSubmit =
                                                              false;
                                                        });
                                                        print(
                                                            'Entered Contest: $error');
                                                      });
                                                    } else {
                                                      Navigator.of(context)
                                                          .pop();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Incorrect Code'),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  },
                                            child: isLoadingCodeSubmit
                                                ? const SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : const Text("Submit"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          : null,
                      icon: const Icon(Icons.arrow_right),
                      label: const Text('Enter Contest'),
                    );
                  } else {
                    return const FilledButton(
                      onPressed: null,
                      child: Text('Loading...'),
                    );
                  }
                },
              ),

              const SizedBox(
                height: 28,
              ),
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.contestDetails!['description'],
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 28,
              ),
              const Text(
                'Instructions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.contestDetails!['rules'],
                style: const TextStyle(fontSize: 18),
              ),

              // Text(contestName),
            ],
          ),
        ),
      ),
    );
  }
}

class SampleTestCase {
  final Delta input;
  final Delta output;
  final Delta explanation;

  const SampleTestCase({
    required this.input,
    required this.output,
    required this.explanation,
  });
}

class ContestQuestion {
  final String questionId;
  final String contestId;
  final Delta contestName;
  final Delta question;
  final Delta inputFormat;
  final Delta outputFormat;
  final List<SampleTestCase> sampleTestCases;
  final Delta constraints;
  String code;

  ContestQuestion({
    required this.questionId,
    required this.contestId,
    required this.contestName,
    required this.question,
    required this.inputFormat,
    required this.outputFormat,
    required this.sampleTestCases,
    required this.constraints,
    required this.code,
  });
}
