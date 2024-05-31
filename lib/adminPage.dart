import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:intl/intl.dart';
import 'package:mingo/common_widgets.dart';
import 'package:mingo/createContest.dart';
import 'package:mingo/loginPage.dart';
import 'package:mingo/sessionConstants.dart';
import 'package:mingo/student_list.dart';

class AdminPage1 extends StatefulWidget {
  const AdminPage1({super.key});

  @override
  State<AdminPage1> createState() => AdminPage();
}

class AdminPage extends State<AdminPage1> {
  final _auth = FirebaseAuth.instance;
  final LinkedHashMap<Delta, dynamic> contestDetails =
      LinkedHashMap<Delta, dynamic>();
  var adminName = '';
  String searchText = '';
  DateTime? selectedDate;
  final List<String> selectedContests = [];

  void handleSearch(String value) {
    setState(() {
      searchText = value;
    });
  }

  void handleDateSelect(DateTime? date) {
    setState(() {
      selectedDate = date;
    });
  }

  // void navigateToTablePage() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => TablePage(selectedContests: selectedContests),
  //     ),
  //   );
  // }

  void handleCheckbox(String contestId, bool isChecked) {
    setState(() {
      if (isChecked) {
        selectedContests.add(contestId);
      } else {
        selectedContests.remove(contestId);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getName();
  }

  void showViewTableDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Contests"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search Contests',
                  ),
                  onChanged: (value) {
                    // Implement search logic here
                  },
                ),
                const SizedBox(height: 10),
                // Add a date range picker here if needed
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('createContest')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    final contests = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: contests.length,
                      itemBuilder: (context, index) {
                        final contest = contests[index];
                        final contestData =
                            contest.data() as Map<String, dynamic>;
                        return CheckboxListTile(
                          title: Text(contestData['contestName']),
                          value: selectedContests.contains(contest.id),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedContests.add(contest.id);
                              } else {
                                selectedContests.remove(contest.id);
                              }
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // navigateToTablePage();
              },
              child: const Text("Proceed"),
            ),
          ],
        );
      },
    );
  }

// void _proceedToTablePage() {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => TablePage(selectedContests: selectedContests),
//     ),
//   );
// }

  void getName() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(SessionConstants.email)
        .get()
        .then((value) {
      final nameData = value.data();
      setState(() {
        adminName = nameData!['name'];
      });
    });
  }

  Widget buildViewTableDialog() {
    return AlertDialog(
      title: const Text('View Table'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: handleSearch,
            decoration: const InputDecoration(labelText: 'Search'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2101),
              );
              handleDateSelect(pickedDate);
            },
            child: Text(selectedDate != null
                ? 'Selected Date: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}'
                : 'Select Date'),
          ),
          const SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('createContest')
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
                final contestData = contest.data() as Map<String, dynamic>;
                final contestName =
                    contestData['contestName'].toString().toLowerCase();
                return contestName.contains(searchText.toLowerCase()) &&
                    (selectedDate == null ||
                        contestData['endDate'] == selectedDate!.toString());
              }).toList();
              return Column(
                children: filteredContests.map((contest) {
                  final contestData = contest.data() as Map<String, dynamic>;
                  final contestId = contest.id;
                  return CheckboxListTile(
                    title: Text(contestData['contestName']),
                    value: selectedContests.contains(contestId),
                    onChanged: (isChecked) {
                      handleCheckbox(contestId, isChecked!);
                    },
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // navigateToTablePage();
          },
          child: const Text('Proceed'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        automaticallyImplyLeading: false,
        title: Text(
          'Hi, $adminName',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FilledButton.icon(
                  onPressed: () {
                    showViewTableDialog();
                  },
                  icon: const Icon(Icons.table_chart),
                  label: const Text('View Table'),
                ),
                const SizedBox(
                  width: 5,
                ),
                Center(
                    child: FilledButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CreateContest(contestDetails: null),
                            ),
                          );
                        },
                        icon: const Icon(Icons.create),
                        label: const Text('Create Contest'))),
                const SizedBox(
                  width: 5,
                ),
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
                    label: const Text('Sign Out')),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('createContest')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            // var contestDetails;
            final contests = snapshot.data!.docs;
            final filteredContests = contests.where((contest) {
              final contestData = contest.data() as Map<String, dynamic>;
              return contestData['email'] == SessionConstants.email;
            }).toList();

            return ListView.builder(
              itemCount: filteredContests.length,
              itemBuilder: (context, index) {
                final contest = filteredContests[index];
                final contestData = contest.data() as Map<String, dynamic>;
                print(contestData);
                print(contestData.runtimeType);
                final contestName = contestData['contestName'];
                var et = (contestData['endTime'] as String).split(':');
                var endDateTime = DateFormat('dd-MM-yyyy:hh:mm').parse(
                    contestData['endDate'] +
                        ':${et[0].padLeft(2, '0')}:${et[1].padLeft(2, '0')}');
                var st = (contestData['startTime'] as String).split(':');
                var startDateTime = DateFormat('dd-MM-yyyy:hh:mm').parse(
                    contestData['startDate'] +
                        ':${st[0].padLeft(2, '0')}:${st[1].padLeft(2, '0')}');
                return ListTile(
                  title: Text(
                    contestName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Start Date: ${contestData['startDate']} Start time: ${contestData['startTime']}"),
                        Text(
                            "End Date: ${contestData['endDate']} End time: ${contestData['endTime']}"),
                      ]), // Add additional information as needed
                  trailing: Row(
                    mainAxisSize: MainAxisSize
                        .min, // Ensure the row takes only the necessary space
                    children: [
                      FilledButton.icon(
                          onPressed: endDateTime.isBefore(DateTime.now())
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentList(
                                          contestDetails: contestData),
                                    ),
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.remove_red_eye_outlined),
                          label: const Text('View Contest')),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CreateContest(contestDetails: contestData),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_square),
                        label: const Text("Edit Contest"),
                      ),
                      const SizedBox(width: 8), // Add spacing between buttons
                      FilledButton.icon(
                        onPressed: () {
                          _showDeleteConfirmationDialog(
                              contestData['contestId']);
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
    );
  }

  void _showDeleteConfirmationDialog(String? contestId) {
    if (contestId != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm Delete"),
            content:
                const Text("Are you sure you want to delete this contest?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  deleteContest(contestId);
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

  void deleteContest(String? contestId) {
    FirebaseFirestore.instance
        .collection('createContest')
        .doc(contestId)
        .delete()
        .then((value) {
      // Contest deleted successfully
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contest deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      // Error occurred while deleting contest
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting contest: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });

    FirebaseFirestore.instance
        .collection('Contest')
        .where('contestId', isEqualTo: contestId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        String docIdToDelete = querySnapshot.docs.first.id;
        FirebaseFirestore.instance
            .collection('Contest')
            .doc(docIdToDelete)
            .delete()
            .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Question deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          print('Document deleted successfully!');
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting contest: $error'),
              backgroundColor: Colors.red,
            ),
          );
          print('Error deleting document: $error');
        });
      } else {
        print('Document with contestId $contestId not found.');
      }
    }).catchError((error) {
      print('Error querying document: $error');
    });
  }
}
