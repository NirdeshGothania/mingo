import 'dart:collection';

// import 'package:mingo/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:mingo/createContest.dart';
import 'package:mingo/loginPage.dart';
import 'package:mingo/sessionConstants.dart';

class adminPage1 extends StatefulWidget {
  const adminPage1({super.key});

  @override
  State<adminPage1> createState() => adminPage();
}

class adminPage extends State<adminPage1> {
  final _auth = FirebaseAuth.instance;
  final LinkedHashMap<Delta, dynamic> contestDetails =
      LinkedHashMap<Delta, dynamic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Admin Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff2b2d7f),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      _auth.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const loginPage1(),
                        ),
                      );
                    },
                    child: const Text('Sign Out')),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  // color: Colors.blue,
                  child: Center(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CreateContest(contestDetails: null),
                              ),
                            );
                          },
                          child: const Text('Create Contest'))),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        child: Center(
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
                return contestData['email'] == sessionConstants.email;
              }).toList();

              return ListView.builder(
                itemCount: filteredContests.length,
                itemBuilder: (context, index) {
                  final contest = filteredContests[index];
                  final contestData = contest.data() as Map<String, dynamic>;
                  print(contestData);
                  print(contestData.runtimeType);
                  final contestName = contestData['contestName'];
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
                        SizedBox(
                          width: 100, // Adjust the width as needed
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateContest(
                                      contestDetails: contestData),
                                ),
                              );
                            },
                            child: const Text("Edit Contest"),
                          ),
                        ),
                        const SizedBox(width: 8), // Add spacing between buttons
                        ElevatedButton(
                          onPressed: () {
                            _showDeleteConfirmationDialog(
                                contestData['contestId']);
                          },
                          child: const Text('Delete'),
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
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  deleteContest(contestId);
                  Navigator.of(context).pop(); // Close the dialog
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
