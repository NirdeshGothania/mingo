import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mingo/OpenContest.dart';
import 'package:mingo/common_widgets.dart';
import 'package:mingo/completedContestPage.dart';
import 'package:mingo/loginPage.dart';
import 'package:mingo/sessionConstants.dart';

class ContestListItem {
  late String name;
  late DateTime startDate;
  late DateTime endDate;
}

class StudentPage1 extends StatefulWidget {
  final Map<String, dynamic>? contestDetails;
  final List<ContestQuestion>? contestQuestions;
  const StudentPage1(
      {super.key,
      this.checkStatus,
      this.contestQuestions,
      this.contestDetails});
  final Function()? checkStatus;

  @override
  State<StudentPage1> createState() => StudentPage();
}

class StudentPage extends State<StudentPage1> {
  final _auth = FirebaseAuth.instance;
  var email = SessionConstants.email2;
  var studentName = '';

  @override
  void initState() {
    super.initState();
    getName();
  }

  void getName() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(SessionConstants.email2)
        .get()
        .then((value) {
      final nameData = value.data();
      setState(() {
        studentName = nameData!['name'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        automaticallyImplyLeading: false,
        title: Text(
          'Hi, $studentName',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => CompletedContest(
                                contestDetails: widget.contestDetails,
                                contestQuestions: widget.contestQuestions)),
                      );
                    },
                    icon: const Icon(Icons.download_done_outlined),
                    label: const Text('Completed Contests')),
                const SizedBox(width: 5),
                FilledButton.icon(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const loginPage1(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Ongoing Contests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildContestList(context, ongoing: true),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Upcoming Contests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildContestList(context, ongoing: false),
          ],
        ),
      ),
    );
  }

  Widget _buildContestList(BuildContext context, {required bool ongoing}) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('createContest').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final contests = snapshot.data!.docs;

        var contestsList = <ContestListItem>[];
        final filteredContests = contests.where((contest) {
          final contestData = contest.data() as Map<String, dynamic>;
          var et = (contestData['endTime'] as String).split(':');
          var endDateTime = DateFormat('dd-MM-yyyy:hh:mm').parse(
              contestData['endDate'] +
                  ':${et[0].padLeft(2, '0')}:${et[1].padLeft(2, '0')}');
          var st = (contestData['startTime'] as String).split(':');
          var startDateTime = DateFormat('dd-MM-yyyy:hh:mm').parse(
              contestData['startDate'] +
                  ':${st[0].padLeft(2, '0')}:${st[1].padLeft(2, '0')}');
          contestsList.add(ContestListItem()
            ..name = contestData['contestName']
            ..startDate = startDateTime
            ..endDate = endDateTime);
          if (ongoing) {
            return (startDateTime.isBefore(DateTime.now()) &&
                endDateTime.isAfter(DateTime.now()));
          } else {
            return (startDateTime.isAfter(DateTime.now()));
          }
        }).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredContests.length,
          itemBuilder: (context, index) {
            final contest = filteredContests[index];
            final contestData = contest.data() as Map<String, dynamic>;
            final contestName = contestData['contestName'];
            return ListTile(
              title: Text(contestName),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Start Date: ${contestData['startDate']} Start time: ${contestData['startTime']}",
                  ),
                  Text(
                    "End Date: ${contestData['endDate']} End time: ${contestData['endTime']}",
                  ),
                ],
              ),
              trailing: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('createContest')
                    .doc(contestData['contestId'])
                    .collection('register')
                    .doc(email)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final isRegistered = snapshot.data!.exists;
                  final statusData0 = snapshot.data!;
                  final statusData =
                      statusData0.data() as Map<String, dynamic>?;
                  final status = statusData?['status'];

                  if (status == 2) {
                    return const Text('Completed',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.green,
                            fontStyle: FontStyle.italic));
                  } else if (status == -1) {
                    return const Text('Violated',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                            fontStyle: FontStyle.italic));
                  }

                  return (isRegistered &&
                          contestsList[index].endDate.isAfter(DateTime.now()))
                      ? FilledButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OpenContest(
                                    contestDetails: contestData,
                                    statusData: statusData),
                              ),
                            );
                          },
                          icon: const Icon(Icons.open_in_new),
                          label: const Text("Open Contest"),
                        )
                      : FilledButton.icon(
                          onPressed: (contestsList[index]
                                  .startDate
                                  .isAfter(DateTime.now()))
                              ? () {
                                  FirebaseFirestore.instance
                                      .collection('createContest')
                                      .doc(contestData['contestId'])
                                      .collection('register')
                                      .doc(email)
                                      .set(
                                    {
                                      'status': 0,
                                    },
                                  ).then(
                                    (value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Registered successfully'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OpenContest(
                                            contestDetails: contestData,
                                            statusData: statusData,
                                          ),
                                        ),
                                      );
                                      print('Registered successfully');
                                      setState(() {});
                                    },
                                  ).catchError(
                                    (error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Registration failed: $error'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      print('Registration failed: $error');
                                    },
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.add_box_outlined),
                          label: const Text("Register"),
                        );
                },
              ),
            );
          },
        );
      },
    );
  }
}
