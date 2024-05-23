import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mingo/sessionConstants.dart';

import 'EditorPage.dart';

class registerContest extends StatefulWidget {
  final Map<String, dynamic>? contestDetails;
  final Map<String, dynamic>? statusData;
  const registerContest(
      {Key? key, required this.contestDetails, required this.statusData})
      : super(key: key);

  @override
  State<registerContest> createState() => _registerContestState();
}

class _registerContestState extends State<registerContest> {
  late DateTime endDateDateTime;
  late DateTime startDateDateTime;
  late TimeOfDay startTimeDateTime;
  late TimeOfDay endTimeDateTime;
  bool allowEnter = false;
  var code_controller = TextEditingController();
  late List<ContestQuestion> contestQuestions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    endDateDateTime =
        DateFormat('dd-MM-yyyy').parse(widget.contestDetails!['endDate']);
    startDateDateTime =
        DateFormat('dd-MM-yyyy').parse(widget.contestDetails!['startDate']);
    startTimeDateTime = TimeOfDay.fromDateTime(
        DateFormat('HH:mm').parse(widget.contestDetails!['startTime']));
    endTimeDateTime = TimeOfDay.fromDateTime(
        DateFormat('HH:mm').parse(widget.contestDetails!['endTime']));
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
              '/${sessionConstants.email2!.replaceAll(RegExp('@iiitr.ac.in'), '')}');
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
          'contest_${contestQuestions[i].contestId}/Submissions/question_${contestQuestions[i].questionId}/${sessionConstants.email2!.replaceAll(RegExp('@iiitr.ac.in'), '')}';
      print(contestQuestions[i].code);
      await firebase_storage.FirebaseStorage.instance
          .ref(inputFilePath)
          .putString(contestQuestions[i].code);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(contestName);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Registered Contest Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff2b2d7f),
        actions: const [],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
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
              const Text(
                'Starts in',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),

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
                  allowEnter = true;
                  setState(() {});
                },
              ),

              const SizedBox(
                height: 20,
              ),

              FutureBuilder(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ElevatedButton(
                        onPressed: (!allowEnter)
                            ? () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Enter the Code"),
                                        content: TextField(
                                          onSubmitted: (_) {},
                                          controller: code_controller,
                                          decoration: InputDecoration(
                                            hintText: 'Enter code',
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(21),
                                              borderSide: const BorderSide(
                                                color: Color(0xff2b2d7f),
                                                width: 2,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(21),
                                              borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 172, 24, 14),
                                                width: 2,
                                              ),
                                            ),
                                            prefixIcon: const Icon(
                                              Icons
                                                  .supervised_user_circle_outlined,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              var code = code_controller.text
                                                  .toString();
                                              if (code ==
                                                  widget.contestDetails![
                                                      'code']) {
                                                await FirebaseFirestore.instance
                                                    .collection('createContest')
                                                    .doc(widget.contestDetails![
                                                        'contestId'])
                                                    .collection('register')
                                                    .doc(
                                                        sessionConstants.email2)
                                                    .set({
                                                  'status': 1,
                                                }).then((value) {
                                                  Navigator.pushReplacement(
                                                    context,
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
                                            child: const Text("Submit"),
                                          ),
                                        ],
                                      );
                                    });
                              }
                            : null,
                        child: const Text('Enter Contest'));
                  } else {
                    return const ElevatedButton(
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
