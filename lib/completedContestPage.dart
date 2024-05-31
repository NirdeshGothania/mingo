import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mingo/OpenContest.dart';
import 'package:mingo/common_widgets.dart';
import 'package:mingo/contestView.dart';
import 'package:mingo/sessionConstants.dart';

class ContestListItem {
  late String name;
  late DateTime startDate;
  late DateTime endDate;
  late int totalMarks;
  late String status;
}

class CompletedContest extends StatefulWidget {
  final Map<String, dynamic>? contestDetails;
  final List<ContestQuestion>? contestQuestions;

  const CompletedContest(
      {super.key, this.contestQuestions, this.contestDetails});

  @override
  State<CompletedContest> createState() => _CompletedContestState();
}

class _CompletedContestState extends State<CompletedContest> {
  bool isRegistered = false;

  Future<bool> checkStatus(String contestId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('createContest')
          .doc(contestId)
          .collection('register')
          .doc(SessionConstants.email2)
          .get();
      return snapshot.exists;
    } catch (e) {
      print('Error checking registration status: $e');
      return false;
    }
  }

  Future<int> fetchTotalMarks(String contestId) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('createContest')
          .doc(contestId)
          .collection('register')
          .doc(SessionConstants.email2)
          .collection('result')
          .get();

      int total = snapshot.docs.fold(0, (sum, doc) {
        var marks = doc.data()['marks'] as int? ?? 0;
        return sum + marks;
      });

      return total;
    } catch (e) {
      print('Error fetching total marks: $e');
      return 0;
    }
  }

  TextStyle getStatusTextStyle(String status) {
    switch (status) {
      case 'Violated':
        return const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        );
      case 'Submitted':
        return const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        );
      default:
        return const TextStyle();
    }
  }

  Future<String> fetchStatusText(String contestId) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('createContest')
          .doc(contestId)
          .collection('register')
          .doc(SessionConstants.email2)
          .get();

      var status = snapshot.data()?['status'] as int? ?? 0;

      switch (status) {
        case -1:
          return 'Violated';
        case 2:
          return 'Submitted';
        case 1:
          return 'Entered';
        case 0:
        default:
          return 'Registered';
      }
    } catch (e) {
      print('Error fetching status: $e');
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: Text('Completed Contest'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('createContest').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final contests = snapshot.data!.docs;
          var contestsList = <ContestListItem>[];
          var filteredContests = <QueryDocumentSnapshot>[];

          return FutureBuilder(
            future: Future.wait(contests.map((contest) async {
              final contestData = contest.data() as Map<String, dynamic>;
              var et = (contestData['endTime'] as String).split(':');
              var endDateTime = DateFormat('dd-MM-yyyy:HH:mm').parse(
                  contestData['endDate'] +
                      ':${et[0].padLeft(2, '0')}:${et[1].padLeft(2, '0')}');
              var st = (contestData['startTime'] as String).split(':');
              var startDateTime = DateFormat('dd-MM-yyyy:HH:mm').parse(
                  contestData['startDate'] +
                      ':${st[0].padLeft(2, '0')}:${st[1].padLeft(2, '0')}');

              int totalMarks = await fetchTotalMarks(contest.id);
              String status = await fetchStatusText(contest.id);

              contestsList.add(ContestListItem()
                ..name = contestData['contestName']
                ..startDate = startDateTime
                ..endDate = endDateTime
                ..totalMarks = totalMarks
                ..status = status);

              bool registered = await checkStatus(contest.id);

              if (endDateTime.isBefore(DateTime.now()) && registered) {
                filteredContests.add(contest);
              }
            }).toList()),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              return ListView.builder(
                itemCount: filteredContests.length,
                itemBuilder: (context, index) {
                  final contest = filteredContests[index];
                  final contestData = contest.data() as Map<String, dynamic>;
                  final contestName = contestData['contestName'];
                  final contestListItem = contestsList.firstWhere(
                      (item) => item.name == contestName,
                      orElse: () => ContestListItem());

                  var et = (contestData['endTime'] as String).split(':');
                  var st = (contestData['startTime'] as String).split(':');

                  return ListTile(
                    title: Text(contestName),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Start Date: ${contestData['startDate']} Start time: ${st[0].padLeft(2, '0')}:${st[1].padLeft(2, '0')}",
                        ),
                        Text(
                          "End Date: ${contestData['endDate']} End time: ${et[0].padLeft(2, '0')}:${et[1].padLeft(2, '0')}",
                        ),
                        Row(
                          children: [
                            const Text(
                              "Status: ",
                            ),
                            Text(
                              contestListItem.status,
                              style: getStatusTextStyle(contestListItem.status),
                            )
                          ],
                        ),
                        Text(
                          "Total Marks: ${contestListItem.totalMarks}",
                        ),
                      ],
                    ),
                    trailing: FilledButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ContestView(
                                    contestDetails: contestData,
                                    email: SessionConstants.email2,
                                  )));
                        },
                        icon: const Icon(Icons.remove_red_eye_outlined),
                        label: const Text('View Contest')),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
