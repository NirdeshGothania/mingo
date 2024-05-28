import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:mingo/OpenContest.dart';
import 'package:mingo/common_widgets.dart';
import 'package:mingo/sessionConstants.dart';
import 'package:mingo/studentPage.dart';

class FinishContest extends StatefulWidget {
  final Map<String, dynamic>? contestDetails;
  final List<ContestQuestion> contestQuestions;
  const FinishContest(
      {super.key,
      required this.contestQuestions,
      required this.contestDetails});

  @override
  State<FinishContest> createState() => _FinishContestState();
}

class _FinishContestState extends State<FinishContest> {
  var textMessage = '';
  bool isViolated = false;

  void checkStatus() {
    FirebaseFirestore.instance
        .collection('createContest')
        .doc(widget.contestDetails!['contestId'])
        .collection('register')
        .doc(SessionConstants.email2)
        .get()
        .then((value) {
      var statusData = value.data() as Map<String, dynamic>;
      var status = statusData['status'];
      if (status == -1) {
        setState(() {
          isViolated = !isViolated;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: const Text(
          'Contest Finish Details',
        ),
        automaticallyImplyLeading: false,
        actions: [
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StudentPage1(
                    contestQuestions: widget.contestQuestions,
                    contestDetails: widget.contestDetails,
                    checkStatus: checkStatus,
                  ),
                ),
              );
              checkStatus();
            },
            icon: const Icon(Icons.chevron_right),
            label: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Continue'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: (!isViolated)
            ? Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.contestDetails!['contestName'],
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Questions Attempted: '),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.contestQuestions.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('createContest')
                            .doc(widget.contestDetails!['contestId'])
                            .collection('register')
                            .doc(SessionConstants.email2)
                            .collection('result')
                            .doc(widget.contestQuestions[index].questionId)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return const Center(child: Text('No Data'));
                          }
                          var resultDetails =
                              snapshot.data!.data() as Map<String, dynamic>?;
                          return ListTile(
                            title: Text(Document.fromDelta(
                                    widget.contestQuestions[index].contestName)
                                .toPlainText()
                                .trim()),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Marks achieved: ${resultDetails!['marks']}'),
                                Text(
                                    'Number of testcases passed: ${resultDetails['testCasesPassed'].length}')
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              )
            : const Text(
                'You have violated the rules and assigned zero marks',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
      ),
    );
  }
}
