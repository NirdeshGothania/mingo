import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:mingo/ContestPage.dart';
import 'package:mingo/adminPage.dart';
import 'package:mingo/common_widgets.dart';

class addQuestionPage1 extends StatefulWidget {
  final dynamic contestId;
  const addQuestionPage1({
    Key? key,
    required this.contestId,
  }) : super(key: key);

  @override
  State<addQuestionPage1> createState() => addQuestionPage();
}

class addQuestionPage extends State<addQuestionPage1> {
  final _auth = FirebaseAuth.instance;
  final LinkedHashMap<Delta, dynamic> contestDetails =
      LinkedHashMap<Delta, dynamic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Add Question',
        ),
        actions: [
          FilledButton.icon(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const AdminPage1()));
            },
            icon: const Icon(Icons.create),
            label: const Text('Create Contest'),
          )
        ],
      ),
      body: Column(
        children: [
          const Text(
            'Questions',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          FilledButton.icon(
            onPressed: () {
              var emptyJson = const [
                {'insert': '\n'}
              ];
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ContestPage1(
                    questionId: "",
                    contestId: widget.contestId,
                    contestName: emptyJson,
                    question: emptyJson,
                    inputFormat: emptyJson,
                    outputFormat: emptyJson,
                    sampleTestCases: [
                      {
                        'input': emptyJson,
                        'output': emptyJson,
                        'explanation': emptyJson,
                      },
                    ],
                    hiddenTestCases: List.empty(growable: true),
                    constraints: emptyJson,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Question'),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: Container(
              child: Center(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Contest')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    final contests = snapshot.data!.docs;
                    final filteredContests = contests.where((contest) {
                      final contestData =
                          contest.data() as Map<String, dynamic>;
                      return contestData['contestId'] == widget.contestId;
                    }).toList();

                    return ListView.builder(
                      itemCount: filteredContests.length,
                      itemBuilder: (context, index) {
                        final contest = filteredContests[index];
                        final contestData =
                            contest.data() as Map<String, dynamic>;

                        // Convert contest data to Delta format

                        var contestListName =
                            Document.fromJson(contestData['contestName'])
                                .toPlainText();

                        print(contestListName);

                        return ListTile(
                          title: Text(
                            contestListName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FilledButton.icon(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ContestPage1(
                                        questionId: contestData['questionId'],
                                        contestId: widget.contestId,
                                        contestName: contestData['contestName'],
                                        question: contestData['question'],
                                        inputFormat: contestData['inputFormat'],
                                        outputFormat:
                                            contestData['outputFormat'],
                                        sampleTestCases:
                                            contestData['sampleTestCases'],
                                        hiddenTestCases:
                                            contestData['hiddenTestCases'],
                                        constraints: contestData['constraints'],
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit_square),
                                label: const Text("Edit Question"),
                              ),
                              const SizedBox(width: 8),
                              FilledButton.icon(
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                      contestData['questionId']);
                                },
                                icon: const Icon(Icons.delete),
                                label: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deleteContest(String? questionId) {
    FirebaseFirestore.instance
        .collection('Contest')
        .doc(questionId)
        .delete()
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Question deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting question: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _showDeleteConfirmationDialog(String? questionId) {
    if (questionId != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm Delete"),
            content:
                const Text("Are you sure you want to delete this question?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  deleteContest(questionId);
                  Navigator.of(context).pop();
                },
                child: const Text("Delete"),
              ),
            ],
          );
        },
      );
    }
  }
}
