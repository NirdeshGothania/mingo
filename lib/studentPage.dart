import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mingo/loginPage.dart';
import 'package:mingo/registerContest.dart';
import 'package:mingo/sessionConstants.dart';

class StudentPage1 extends StatefulWidget {
  const StudentPage1({Key? key}) : super(key: key);

  @override
  State<StudentPage1> createState() => StudentPage();
}

class StudentPage extends State<StudentPage1> {
  final _auth = FirebaseAuth.instance;
  late DateTime endDateDateTime;
  late DateTime startDateDateTime;
  var email = sessionConstants.email2;
  late TimeOfDay startTimeDateTime;
  late TimeOfDay endTimeDateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Student Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff2b2d7f),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const loginPage1(),
                  ),
                );
              },
              child: const Text('Sign Out'),
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
    return Container(
      child: StreamBuilder<QuerySnapshot>(
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

          final filteredContests = contests.where((contest) {
            final contestData = contest.data() as Map<String, dynamic>;
            final endDate = contestData['endDate'];
            final startDate = contestData['startDate'];
            final startTime = contestData['startTime'];
            final endTime = contestData['endTime'];

            if (endDate != null &&
                startDate != null &&
                startTime != null &&
                endTime != null) {
              endDateDateTime = DateFormat('dd-MM-yyyy').parse(endDate);
              startDateDateTime = DateFormat('dd-MM-yyyy').parse(startDate);
              startTimeDateTime =
                  TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(startTime));
              endTimeDateTime =
                  TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(endTime));

              if (ongoing) {
                return (((startDateDateTime.isBefore(DateTime.now()) ||
                        (startDateDateTime.isAtSameMomentAs(DateTime.now()) &&
                            ((startTime.isAtSameMomentAs(TimeOfDay.now()) ||
                                    startTime.isBefore(TimeOfDay.now())) &&
                                endTime.isAfter(TimeOfDay.now()))))) &&
                    (endDateDateTime.isAfter(DateTime.now())));
              } else {
                return (startDateDateTime.isAfter(DateTime.now()) ||
                    (startDateDateTime.isAtSameMomentAs(DateTime.now()) &&
                        startTime.isAfter(TimeOfDay.now())));
              }
            } else {
              return false;
            }
          }).toList();

          // final filteredContests = contests.where((contest) {
          //   final contestData = contest.data() as Map<String, dynamic>;
          //   final endDate = contestData['endDate'];
          //   final startDate = contestData['startDate'];
          //   final startTime = contestData['startTime'];
          //   final endTime = contestData['endTime'];

          //   if (endDate != null &&
          //       startDate != null &&
          //       startTime != null &&
          //       endTime != null) {
          //     final endDateDateTime = DateFormat('dd-MM-yyyy').parse(endDate);
          //     final startDateDateTime =
          //         DateFormat('dd-MM-yyyy').parse(startDate);
          //     final startTimeDateTime =
          //         TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(startTime));
          //     final endTimeDateTime =
          //         TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(endTime));

          //     final now = DateTime.now();
          //     final nowTimeOfDay = TimeOfDay.now();

          //     bool isSameTime(TimeOfDay t1, TimeOfDay t2) {
          //       return t1.hour == t2.hour && t1.minute == t2.minute;
          //     }

          //     int compareTimeOfDay(TimeOfDay start, TimeOfDay now) {
          //       if (start.hour < now.hour ||
          //           (start.hour == now.hour && start.minute < now.minute)) {
          //         return -1;
          //       } else if (start.hour > now.hour ||
          //           (start.hour == now.hour && start.minute > now.minute)) {
          //         return 1;
          //       }
          //       return 0;
          //     }

          //     if (ongoing) {
          //       return (startDateDateTime.isBefore(now) ||
          //               (startDateDateTime.isAtSameMomentAs(now) &&
          //                   (isSameTime(startTimeDateTime, nowTimeOfDay) ||
          //                       (compareTimeOfDay(
          //                               startTimeDateTime, nowTimeOfDay) <=
          //                           0)))) &&
          //           (endDateDateTime.isAfter(now) ||
          //               (endDateDateTime.isAtSameMomentAs(now) &&
          //                   ((compareTimeOfDay(endTimeDateTime, nowTimeOfDay) >
          //                           0) ||
          //                       isSameTime(endTimeDateTime, nowTimeOfDay))));
          //     } else {
          //       return startDateDateTime.isAfter(now) ||
          //           (startDateDateTime.isAtSameMomentAs(now) &&
          //               compareTimeOfDay(startTimeDateTime, nowTimeOfDay) >= 0);
          //     }
          //   } else {
          //     return false;
          //   }
          // }).toList();

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
                        "Start Date: ${contestData['startDate']} Start time: ${contestData['startTime']}"),
                    Text(
                        "End Date: ${contestData['endDate']} End time: ${contestData['endTime']}"),
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
                        statusData0.data() as Map<String, dynamic>;

                    return isRegistered
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => registerContest(
                                      contestDetails: contestData,
                                      statusData: statusData),
                                ),
                              );
                            },
                            child: const Text("Open Contest"),
                          )
                        : ElevatedButton(
                            onPressed: (startDateDateTime
                                        .isAfter(DateTime.now()) ||
                                    (startDateDateTime
                                            .isAtSameMomentAs(DateTime.now()) &&
                                        (contestData['startTime']
                                                .isAfter(TimeOfDay.now()) &&
                                            contestData['endTime']
                                                .isAtSameMomentAs(
                                                    TimeOfDay.now()))))
                                ? () {
                                    FirebaseFirestore.instance
                                        .collection('createContest')
                                        .doc(contestData['contestId'])
                                        .collection('register')
                                        .doc(email)
                                        .set({
                                      'status': 0,
                                    }).then((value) {
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
                                          builder: (context) => registerContest(
                                            contestDetails: contestData,
                                            statusData: statusData,
                                          ),
                                        ),
                                      );
                                      print('Registered successfully');
                                    }).catchError((error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Registration failed: $error'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      print('Registration failed: $error');
                                    });
                                  }
                                : null,
                            child: const Text("Register"),
                          );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
